import crypto from "node:crypto";
import http from "node:http";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { spawn } from "node:child_process";

const REDIRECT_URI = "http://127.0.0.1:3001/oauth/redirect";
const AUTHORIZE_URL = "https://www.canva.com/api/oauth/authorize";
const TOKEN_URL = "https://api.canva.com/rest/v1/oauth/token";
const REQUIRED_SCOPES = ["design:content:write", "design:meta:read", "folder:read", "folder:write"];
const here = path.dirname(fileURLToPath(import.meta.url));

class UsageError extends Error {}

function usage(message) {
  if (message) console.error(`Error: ${message}\n`);
  console.error(`Usage:
  node authorize-import.mjs --file <verified-pptx> --title <canva-title> --folder <folder-id> [--expected-pages <count>]

Required environment:
  CANVA_CLIENT_ID      The client ID shown in your Canva integration settings.
  CANVA_CLIENT_SECRET  The secret generated in your Canva integration settings.

Before running, configure this redirect URL in Canva exactly:
  ${REDIRECT_URI}

This helper opens Canva's approval page, receives the redirect locally, then passes
the short-lived access token directly to import-pptx.mjs. It never writes tokens or
client secrets to disk.`);
  throw new UsageError(message ?? "Invalid command line");
}

function parseArgs(argv) {
  const options = {};
  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index];
    if (!token.startsWith("--")) usage(`Unexpected argument: ${token}`);
    const key = token.slice(2);
    const value = argv[index + 1];
    if (!value || value.startsWith("--")) usage(`Missing value for --${key}`);
    options[key] = value;
    index += 1;
  }
  return options;
}

function openBrowser(url) {
  if (process.platform === "win32") {
    spawn("cmd.exe", ["/c", "start", "", url], { detached: true, stdio: "ignore" }).unref();
    return;
  }
  if (process.platform === "darwin") {
    spawn("open", [url], { detached: true, stdio: "ignore" }).unref();
    return;
  }
  spawn("xdg-open", [url], { detached: true, stdio: "ignore" }).unref();
}

function sendHtml(response, status, title, body) {
  response.writeHead(status, { "Content-Type": "text/html; charset=utf-8", "Cache-Control": "no-store" });
  response.end(`<!doctype html><title>${title}</title><main style="font-family:system-ui;max-width:42rem;margin:4rem auto;line-height:1.5"><h1>${title}</h1><p>${body}</p></main>`);
}

async function exchangeCode({ code, verifier, clientId, clientSecret }) {
  const credentials = Buffer.from(`${clientId}:${clientSecret}`, "utf8").toString("base64");
  const response = await fetch(TOKEN_URL, {
    method: "POST",
    headers: {
      Authorization: `Basic ${credentials}`,
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      grant_type: "authorization_code",
      code,
      code_verifier: verifier,
      redirect_uri: REDIRECT_URI,
    }),
  });
  const result = await response.json().catch(() => ({}));
  if (!response.ok || !result.access_token) {
    throw new Error(`Canva token exchange failed (${response.status}): ${result.message ?? JSON.stringify(result)}`);
  }
  return result.access_token;
}

async function getAccessToken(clientId, clientSecret) {
  const verifier = crypto.randomBytes(96).toString("base64url");
  const challenge = crypto.createHash("sha256").update(verifier).digest("base64url");
  const state = crypto.randomBytes(32).toString("base64url");
  // Match Canva's own Authorization URL generator: it uses RFC 3986 `%20`
  // separators for scopes rather than form-style `+` separators.
  const authorizationUrl = new URL(`${AUTHORIZE_URL}?${[
    `code_challenge=${encodeURIComponent(challenge)}`,
    "code_challenge_method=s256",
    `scope=${REQUIRED_SCOPES.join("%20")}`,
    "response_type=code",
    `client_id=${encodeURIComponent(clientId)}`,
    `state=${encodeURIComponent(state)}`,
    `redirect_uri=${encodeURIComponent(REDIRECT_URI)}`,
  ].join("&")}`);

  return new Promise((resolve, reject) => {
    let finished = false;
    const finish = (callback) => {
      if (finished) return;
      finished = true;
      clearTimeout(timeout);
      server.close();
      callback();
    };
    const server = http.createServer(async (request, response) => {
      const callbackUrl = new URL(request.url, REDIRECT_URI);
      if (callbackUrl.pathname !== "/oauth/redirect") {
        sendHtml(response, 404, "Not found", "This local helper only accepts Canva's OAuth redirect.");
        return;
      }
      const returnedState = callbackUrl.searchParams.get("state");
      const code = callbackUrl.searchParams.get("code");
      const oauthError = callbackUrl.searchParams.get("error");
      if (oauthError) {
        sendHtml(response, 400, "Canva authorization was not completed", "Return to the terminal to see the error.");
        finish(() => reject(new Error(`Canva authorization failed: ${oauthError}`)));
        return;
      }
      if (!code || returnedState !== state) {
        sendHtml(response, 400, "Authorization could not be verified", "Return to the terminal and retry.");
        finish(() => reject(new Error("OAuth callback missing a code or state did not match")));
        return;
      }
      try {
        const token = await exchangeCode({ code, verifier, clientId, clientSecret });
        sendHtml(response, 200, "Canva approved", "You can close this tab. The isolated Canva import is now running in your terminal.");
        finish(() => resolve(token));
      } catch (error) {
        sendHtml(response, 500, "Token exchange failed", "Return to the terminal to see the error.");
        finish(() => reject(error));
      }
    });
    const timeout = setTimeout(() => finish(() => reject(new Error("Timed out waiting for Canva approval after 10 minutes"))), 600_000);
    server.once("error", (error) => finish(() => reject(error)));
    server.listen(3001, "127.0.0.1", () => {
      console.log("Opening Canva approval in your browser. Sign in and click Allow.");
      openBrowser(authorizationUrl.toString());
    });
  });
}

async function main() {
  const options = parseArgs(process.argv.slice(2));
  const clientId = process.env.CANVA_CLIENT_ID;
  const clientSecret = process.env.CANVA_CLIENT_SECRET;
  if (!clientId || !clientSecret) usage("CANVA_CLIENT_ID and CANVA_CLIENT_SECRET must be set in this PowerShell session");
  if (!options.file || !options.title || !options.folder) usage("--file, --title, and --folder are required");
  const accessToken = await getAccessToken(clientId, clientSecret);
  console.log("Canva approved. Starting isolated PPTX import…");
  const child = spawn(process.execPath, [path.join(here, "import-pptx.mjs"), ...process.argv.slice(2)], {
    env: { ...process.env, CANVA_ACCESS_TOKEN: accessToken },
    stdio: "inherit",
  });
  await new Promise((resolve, reject) => {
    child.once("error", reject);
    child.once("exit", (code) => code === 0 ? resolve() : reject(new Error(`Importer exited with code ${code}`)));
  });
}

main().catch((error) => {
  if (!(error instanceof UsageError)) console.error(`Authorization/import stopped: ${error.message}`);
  process.exitCode = 1;
});

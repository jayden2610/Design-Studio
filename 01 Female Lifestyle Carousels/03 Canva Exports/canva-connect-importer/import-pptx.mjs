import fs from "node:fs/promises";
import path from "node:path";

const API_ROOT = "https://api.canva.com/rest/v1";
const MIME_TYPE = "application/vnd.openxmlformats-officedocument.presentationml.presentation";

class UsageError extends Error {}

function usage(message) {
  if (message) console.error(`Error: ${message}\n`);
  console.error(`Usage:
  node import-pptx.mjs --file <verified-pptx> --title <canva-title> --folder <folder-id> [--expected-pages <count>]

Required environment:
  CANVA_ACCESS_TOKEN  OAuth access token with design:content:write, design:meta:read,
                      folder:read, and folder:write scopes.

Example:
  $env:CANVA_ACCESS_TOKEN = '<short-lived-token>'
  node .\\import-pptx.mjs --file "..\\FINAL ETSY DELIVERY - FEMALE LIFESTYLE CAROUSELS\\02 SELLER ONLY - CANVA IMPORT FILES\\Playful Scrapbook Social - Nightstand Edit - Canva Import.pptx" --title "TEST Nightstand Import" --folder "FAHSbYdCEKo" --expected-pages 4`);
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

function wait(milliseconds) {
  return new Promise((resolve) => setTimeout(resolve, milliseconds));
}

async function request(url, options, label) {
  const response = await fetch(url, options);
  const body = await response.text();
  let data;
  try {
    data = body ? JSON.parse(body) : {};
  } catch {
    throw new Error(`${label} returned non-JSON (${response.status}): ${body.slice(0, 500)}`);
  }
  if (!response.ok) throw new Error(`${label} failed (${response.status}): ${data.message ?? JSON.stringify(data)}`);
  return data;
}

async function pollImport(token, jobId) {
  const deadline = Date.now() + 90_000;
  let interval = 1_500;
  while (Date.now() < deadline) {
    const result = await request(`${API_ROOT}/imports/${jobId}`, {
      headers: { Authorization: `Bearer ${token}` },
    }, "Get import job");
    const job = result.job;
    if (job?.status === "success") return job;
    if (job?.status === "failed") throw new Error(`Canva import failed: ${job.error?.code ?? "unknown"} — ${job.error?.message ?? "No message"}`);
    await wait(interval);
    interval = Math.min(interval * 1.4, 8_000);
  }
  throw new Error(`Timed out while waiting for Canva import job ${jobId}`);
}

async function main() {
  const options = parseArgs(process.argv.slice(2));
  const token = process.env.CANVA_ACCESS_TOKEN;
  if (!token) usage("CANVA_ACCESS_TOKEN is not set");
  if (!options.file || !options.title || !options.folder) usage("--file, --title, and --folder are required");
  if (options.title.length > 50) usage("Canva import titles are limited to 50 characters; pass a shorter --title");

  const file = path.resolve(options.file);
  const stats = await fs.stat(file).catch(() => null);
  if (!stats?.isFile()) usage(`PPTX file not found: ${file}`);
  if (path.extname(file).toLowerCase() !== ".pptx") usage("Only verified .pptx files are supported");

  const importMetadata = JSON.stringify({
    title_base64: Buffer.from(options.title, "utf8").toString("base64"),
    mime_type: MIME_TYPE,
  });
  console.log(JSON.stringify({ stage: "uploading", file, bytes: stats.size, destinationFolder: options.folder }));

  const importResult = await request(`${API_ROOT}/imports`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/octet-stream",
      "Content-Length": String(stats.size),
      "Import-Metadata": importMetadata,
    },
    body: await fs.readFile(file),
  }, "Create import job");
  const job = await pollImport(token, importResult.job?.id);
  const design = job.result?.designs?.[0];
  if (!design?.id) throw new Error("Canva import finished without a design ID");

  await request(`${API_ROOT}/folders/move`, {
    method: "POST",
    headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
    body: JSON.stringify({ item_id: design.id, to_folder_id: options.folder }),
  }, "Move imported design to folder");

  const metadata = await request(`${API_ROOT}/designs/${design.id}`, {
    headers: { Authorization: `Bearer ${token}` },
  }, "Get imported design metadata");
  const expectedPages = options["expected-pages"] ? Number(options["expected-pages"]) : undefined;
  if (expectedPages && metadata.design?.page_count !== expectedPages) {
    throw new Error(`Imported design has ${metadata.design?.page_count ?? "unknown"} page(s); expected ${expectedPages}. It remains in the test folder for review.`);
  }

  console.log(JSON.stringify({
    stage: "complete",
    designId: metadata.design?.id,
    title: metadata.design?.title,
    pageCount: metadata.design?.page_count,
    editUrl: metadata.design?.urls?.edit_url,
    folderId: options.folder,
    nextManualStep: "Inspect the imported Canva design, then create and separately test the buyer-safe Template link.",
  }, null, 2));
}

main().catch((error) => {
  if (!(error instanceof UsageError)) console.error(`Importer stopped: ${error.message}`);
  process.exitCode = 1;
});

# Video provider options for the gimbap roll

## Recommendation: Luma Dream Machine API

Luma is the closest fit to this Oil Motion brief because its API accepts both a start frame and an ending frame as `keyframes.frame0` and `keyframes.frame1`. That gives each adjacent segment a defined destination instead of asking the model to invent the final pose. The tradeoff is that the API currently expects image URLs, so the project needs a controlled upload/storage step for the private keyframes.

Suggested sequence:

1. Submit K0→K1, K1→K2, and K2→K3 as three separate generations.
2. Request the same aspect ratio and duration for all three.
3. Download the clips into `source/raw/`.
4. Concatenate and compile with the local FFmpeg wrapper.

## Other viable choices

| Provider | Strength | Main tradeoff for this project |
|---|---|---|
| Runway API | Strong image-to-video API and accepts data URIs, which avoids public keyframe URLs. | The documented flow is image-to-video from an input image; it is less direct for enforcing a supplied ending frame. |
| Google Veo on Vertex AI | High-quality managed video generation with Google Cloud controls. | Heavier setup: GCP project, billing, IAM, and a provider-specific long-running job flow. |
| fal.ai | One API surface for many video models, queue/webhook support, and base64/file inputs. | Model behavior varies; this is useful for testing providers but less predictable as a single locked pipeline. |
| Local LTX/Wan via ComfyUI | No per-generation vendor API and full local control. | Requires a capable GPU, model downloads, and more operational setup than this small motion study warrants. |

## Decision rule

Use Luma first when endpoint fidelity matters. Use Runway or fal.ai when fast experimentation matters. Use a local LTX/Wan workflow only if keeping the frames off third-party services is more important than setup time.

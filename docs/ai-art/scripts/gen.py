"""Generate one image through the official FLUX.2 [klein] 4B Space. Logs every attempt to out/log.jsonl."""
import json, os, shutil, sys, time
from gradio_client import Client, handle_file

STYLE = ("Style: soft glossy 3D clay render, smooth satin surface with gentle subsurface glow, "
         "pastel lilac, violet, peach, mint and pink gradients, plain deep violet background (#0C0816), "
         "soft studio lighting with a subtle rim light, centred composition, generous empty space, "
         "minimal and friendly, no text, no letters, no logo, no lime or yellow-green colour.")

def main():
    name, prompt = sys.argv[1], sys.argv[2]
    seed = int(sys.argv[3]); w = int(sys.argv[4]); h = int(sys.argv[5])
    refs = sys.argv[6:]
    out = os.path.join(os.path.dirname(__file__), "out")
    full = f"{prompt} {STYLE}"
    c = Client("black-forest-labs/FLUX.2-klein-4B", token=os.environ["HF_TOKEN"], verbose=False)
    rec = dict(name=name, seed=seed, width=w, height=h, refs=[os.path.basename(r) for r in refs],
               mode="Distilled (4 steps)", steps=4, guidance=1.0, prompt=full, t=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
    t0 = time.time()
    try:
        res, s = c.predict(prompt=full, input_images=[{"image": handle_file(r)} for r in refs],
                           mode_choice="Distilled (4 steps)", seed=seed, randomize_seed=False,
                           width=w, height=h, num_inference_steps=4, guidance_scale=1.0,
                           prompt_upsampling=False, api_name="/infer")
        path = res["path"] if isinstance(res, dict) else res
        ext = os.path.splitext(path)[1] or ".webp"
        dst = os.path.join(out, name + ext); shutil.copy(path, dst)
        rec.update(ok=True, file=os.path.basename(dst), returned_seed=int(s))
    except Exception as e:
        rec.update(ok=False, error=str(e)[:500])
    rec["secs"] = round(time.time() - t0, 1)
    with open(os.path.join(out, "log.jsonl"), "a") as f: f.write(json.dumps(rec) + "\n")
    print(json.dumps({k: v for k, v in rec.items() if k != "prompt"}))

main()

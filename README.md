# UST MVP — Quantum Foundation / Fractal Metascience Foundation

Executable MVP bundle:
- **GitHub Pages** deploy on every push to `main`.
- **Release pipeline** produces checksums and publishes research artifacts to Zenodo/Figshare (optional).

## Pages
The site is served from `/app/` (see `index.html` redirect).

## Secrets expected (GitHub → Settings → Secrets and variables → Actions)
- `ZENODO_TOKEN`
- `FIGSHARE_TOKEN`
- `OSF_TOKEN` (optional)
- `CLOUDFLARE_API_TOKEN` (optional)
- `CLOUDFLARE_ZONE_ID` (optional)
- `CLOUDFLARE_PURGE_URLS_JSON` (optional, JSON array of URLs)

## Publish trigger
Create a release tag, e.g. `v0.1.0` → pipeline runs.

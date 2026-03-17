
# rapid-container

This repository packages multiple versions of [Rapid](https://rapideditor.org) (a front-end OSM editor) into a single nginx Docker container, serving them as static files.

## How it works

- `rapid2` is installed from npm (`@rapideditor/rapid@^2.x`)
- `rapid3` is currently a local `file:../rapid` dependency (not yet published to npm); once published it will become a normal npm alias too
- `scripts/build.sh` installs nothing — it just copies `node_modules/rapid2/dist` and `node_modules/rapid3/dist` into `./dist/rapid2/` and `./dist/rapid3/`
- `./dist/` is **committed to git** so downstream projects can `git clone` without needing any build tooling
- The Dockerfile is intentionally minimal: it just copies `./dist/` into an nginx image

## Deployment context

This repo is consumed by [`workspaces-stack`](https://github.com/TaskarCenterAtUW/workspaces-stack) (a separate repo), which `git clone`s this project into a `rapid/` subfolder and builds the Docker image via `docker-compose.build.yml`. No build happens inside Docker — the pre-built `dist/` is all that's needed.

## Developer workflow

```sh
npm install        # or bun/yarn/pnpm — any package manager works
sh ./scripts/build.sh   # populates ./dist/
docker build -t rapid-container .
docker run -p 8080:80 rapid-container  # test at localhost:8080/rapid2/ and /rapid3/
```

## License

rapid-container is available under the [ISC License](https://opensource.org/licenses/ISC).
See the [LICENSE.md](LICENSE.md) file for more details.

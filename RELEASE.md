# Release Checklist

## Update `main` branch

The `main` branch includes only the scaffolding - shell scripts and Dockerfile.
The `dist/` folder (containing the various Rapid builds) is `.gitignore`d

```sh
git checkout main
npm install              # or bun/yarn/pnpm — any package manager works
sh ./scripts/build.sh    # populates ./dist/
docker build -t rapid-container .
```

You can test that the docker container does serve up Rapid as expected.
```sh
docker run --rm -p 8080:80 rapid-container
```
You should be able to access:
- http://localhost:8080/rapid2/
- http://localhost:8080/rapid3/


## Update `release` branch

The `release` branch checks in the contents of `dist/` too - this makes it suitable for deployment.
It's basically a copy of `main` but with one additional commit appended to it.
This will also be the commit that we tag for deployment.
(We use `-f` to force check-in all the files in `dist/`)

```sh
git checkout release
git reset --hard main
git add -f dist
git commit -m 'Check in build'
git push origin -f release
```


## Tag for Deployment

This repo is referenced by [`workspaces-stack`](https://github.com/TaskarCenterAtUW/workspaces-stack), which expects to find a `dev`, `stage`, or `prod` tag.  See the workspaces-stack [README](https://github.com/TaskarCenterAtUW/workspaces-stack/blob/main/README.md) for more details.

Tag the commit **on the `release` branch** that you want to promote for deployment.
(We use `-f` to force update the tags, as they likely exist pointing to previous commits)

```sh
git tag -f dev           # or stage, prod
git push -f origin dev   # or stage, prod
```

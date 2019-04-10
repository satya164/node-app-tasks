# GitHub Action to run tasks in a Node.js app

The action allows to run any [npm](https://www.npmjs.com)/[yarn](https://yarnpkg.com) command or a task defined in package.json. It also makes it possible to push code to GitHub for deploying.

The action will setup the following items automatically:

1. Configure the git repo to enable pushing code to remote (needs a `GITHUB_TOKEN` secret)
2. Configure npm to allow running `npm publish` (needs a `NPM_AUTH_TOKEN` secret)
3. Install project dependencies automatically (autodetects whether to use `yarn` or `npm`)

## Usage

## Secrets

* `NPM_AUTH_TOKEN` (optional): Authentication token required for `npm publish`
* `GITHUB_TOKEN` (optional): Authentication token required to push code to GitHub.

## Environment variables

* `PACKAGE_MANAGER` (optional): The package manager to use. Supported values are `yarn` and `npm`. Defaults to `yarn` if `yarn.lock` is detected, otherwise `npm` is used.
* `NPM_REGISTRY_URL` (optional): The registry for npm packages. Defaults to `registry.npmjs.org`.
* `NPM_STRICT_SSL` (optional): Whether to use SSL for the registry. Specify `false` if your registry is insecure and uses `http`. Defaults to `true`.

## Usage:

A simple workflow which runs the `deploy` script in `package.json` with `npm` can look like this:

```workflow
workflow "Deploy" {
  on = "push"
  resolves = "Pages"
}

action "Master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Pages" {
  needs = "Master"
  uses = "satya164/node-app-tasks@master"
  secrets = ["GITHUB_TOKEN"]
  env = {
    PACKAGE_MANAGER = "npm"
  }
  args = "run deploy"
}
```

You can do anything in the `deploy` script, for example build code, and push to `gh-pages`. e.g.:

```sh
git branch -D gh-pages
git checkout -b gh-pages && \
rm -rf dist && \
npm run build && \
git add -f dist/ && \
git commit -m 'Publish pages' && \
git push -fu origin gh-pages
git checkout @{-1}
```

## License

The `Dockerfile` and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

Container images built with this project include third party materials. See [THIRD_PARTY_NOTICE.md](THIRD_PARTY_NOTICE.md) for details.

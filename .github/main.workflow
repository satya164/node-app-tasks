workflow "Build and Publish" {
  on = "push"
  resolves = "Docker Publish"
}

action "Shellcheck" {
  uses = "actions/bin/shellcheck@master"
  args = "*.sh"
}

action "Docker Lint" {
  uses = "docker://replicated/dockerfilelint"
  args = ["Dockerfile"]
}

action "Build" {
  needs = ["Shellcheck", "Docker Lint"]
  uses = "actions/docker/cli@master"
  args = "build -t node-app-tasks ."
}

action "Docker Tag" {
  needs = ["Build"]
  uses = "actions/docker/tag@master"
  args = "node-app-tasks satya164/node-app-tasks --no-latest"
}

action "Publish Filter" {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Docker Login" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Publish" {
  needs = ["Docker Tag", "Docker Login"]
  uses = "actions/docker/cli@master"
  args = "push satya164/node-app-tasks"
}

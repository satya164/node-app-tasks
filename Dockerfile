FROM node:10-slim

LABEL version="1.0.0"
LABEL repository="http://github.com/satya164/http://github.com/satya164/node-app-tasks"
LABEL homepage="http://github.com/satya164/http://github.com/satya164/node-app-tasks"
LABEL maintainer="Satyajit Sahoo <satyajit.happy@gmail.com>"

LABEL "com.github.actions.name"="GitHub Action to run tasks in a Node.js app"
LABEL "com.github.actions.description"="The action allows to run any npm/yarn command or a task defined in package.json. It also makes it possible to push code to GitHub for deploying."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="black"

RUN apt-get update -qq && apt-get install --no-install-recommends -y git build-essential && rm -rf /var/lib/apt/lists/*

COPY LICENSE README.md THIRD_PARTY_NOTICE.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

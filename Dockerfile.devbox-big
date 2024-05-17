FROM jetpackio/devbox:latest AS base

# Installing your devbox project
WORKDIR /code
USER root:root
RUN mkdir -p /code && chown ${DEVBOX_USER}:${DEVBOX_USER} /code
USER ${DEVBOX_USER}:${DEVBOX_USER}
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock

# Step 6: Copying local flakes directories
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} ./tooling ./tooling

RUN devbox run -- echo "Installed Packages."

FROM base AS installer

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} . .

RUN devbox run -- echo "Install packages again"

RUN devbox run -- bun install --frozen-lockfile

CMD ["devbox", "shell"]

FROM installer AS release

COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} --from=installer /code /code

FROM node as build

ARG GIT_TAG=v1.4.3

WORKDIR /git

# clone repo version and install
RUN git clone https://github.com/awslabs/landing-zone-accelerator-on-aws; \
    cd landing-zone-accelerator-on-aws; \
    git checkout ${GIT_TAG}; \
    cd source; \
    yarn install;

FROM node:lts-alpine3.17 as final

# copy only needed files
COPY --from=build /git/landing-zone-accelerator-on-aws/source /app
COPY --from=build /git/landing-zone-accelerator-on-aws/reference/sample-configurations/aws-best-practices /src

# supress node deprecation warnings
ENV NODE_OPTIONS='--no-warnings'

# user will have to mount volume /src with their particular configuration
ENTRYPOINT ["yarn", "--cwd", "/app", "validate-config", "/src"]



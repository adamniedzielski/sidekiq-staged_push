FROM ruby:3.0.3-alpine
RUN apk add build-base sqlite-dev tzdata git bash
WORKDIR /library
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

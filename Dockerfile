# See: https://github.com/bitwalker/alpine-elixir-phoenix
FROM bitwalker/alpine-elixir:1.9 AS ex-builder

MAINTAINER John <mail@john.pub>

# Important!  Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like `apt-get update` won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2020-01-20

# Set exposed ports
ENV MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

RUN mix do compile

FROM bitwalker/alpine-elixir:1.9 as release

EXPOSE 5000
ENV PORT=5000 MIX_ENV=prod

# COPY --from=ex-builder /opt/app/_build /opt/app/_build
# COPY --from=ex-builder /opt/app/priv /opt/app/priv
# COPY --from=ex-builder /opt/app/config /opt/app/config
# COPY --from=ex-builder /opt/app/lib /opt/app/lib
# COPY --from=ex-builder /opt/app/deps /opt/app/deps
# COPY --from=ex-builder /opt/app/.mix /opt/app/.mix
# COPY --from=ex-builder /opt/app/mix.* /opt/app/

# alternatively you can just copy the whole dir over with:
COPY --from=ex-builder /opt/app /opt/app
# be warned, this will however copy over non-build files

USER default

CMD ["mix", "gql.dev"]

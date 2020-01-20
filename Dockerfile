# See: https://github.com/bitwalker/alpine-elixir-phoenix
FROM bitwalker/alpine-elixir-phoenix:latest AS phx-builder

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

# Same with npm deps
# ADD assets/package.json assets/
# RUN cd assets && \
#     npm install

ADD . .

# Run frontend build, compile, and digest assets
# RUN cd assets/ && \
#     npm run deploy && \
#     cd - && \

ENV SECRET_KEY_BASE=42
RUN mix phx.gen.secret

RUN mix do compile, phx.digest

FROM bitwalker/alpine-elixir:latest

EXPOSE 5000
ENV PORT=5000 MIX_ENV=prod

# COPY --from=phx-builder /opt/app/_build /opt/app/_build
# COPY --from=phx-builder /opt/app/priv /opt/app/priv
# COPY --from=phx-builder /opt/app/config /opt/app/config
# COPY --from=phx-builder /opt/app/lib /opt/app/lib
# COPY --from=phx-builder /opt/app/deps /opt/app/deps
# COPY --from=phx-builder /opt/app/.mix /opt/app/.mix
# COPY --from=phx-builder /opt/app/mix.* /opt/app/

# alternatively you can just copy the whole dir over with:
COPY --from=phx-builder /opt/app /opt/app
# be warned, this will however copy over non-build files

USER default
ENV SECRET_KEY_BASE=42

CMD ["mix", "phx.server"]
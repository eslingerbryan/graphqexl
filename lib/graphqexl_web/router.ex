defmodule GraphqexlWeb.Router do
  use GraphqexlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GraphqexlWeb do
    pipe_through :browser
    get "/", PageController, :index
  end

  scope "/api", GraphqexlWeb do
    pipe_through :api
  end

  scope "/docs", GraphqexlWeb do
    pipe_through :browser
  end

  scope "/graphql", GraphqexlWeb do
    pipe_through :browser

    get "/playground", PageController, :index
  end
end

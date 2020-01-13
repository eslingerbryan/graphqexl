defmodule GraphqexlWeb.PageController do
  use GraphqexlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

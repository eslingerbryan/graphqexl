defmodule Mix.Tasks.Docker.Publish do
  @doc """
  Publish the built application container to the given image repo

  ARGS
    - image_name, string, e.g.: "graphqexl"
    - image_repo, string, e.g.: "gcr.io/graphqexl"
    - image_tag, string, e.g.: "latest"
  """
  @spec run([String.t]) :: :ok
  def run([image_name, image_repo, image_tag]) do
    tag = image_tag || "#{git_sha}-dev"
    IO.puts "[STARTING] Publishing #{image_repo}/#{image_name}:#{tag}..."

    remote = docker_image(image_repo, image_name, tag)
    image_name
    |> docker_tag(remote)
    |> cmd_and(remote |> docker_push)

    IO.puts "[DONE] Publishing Docker image..."
  end

  @doc false
  defp cmd_and(cmd1, cmd2) do
    system_run(cmd1) && system_run(cmd2)
  end

  @doc false
  defp docker_image(name, repo, tag) do
    "#{repo}/#{name}:#{tag}"
  end

  @doc false
  defp local(image_name) do
    docker_image(image_name, "local-registry", "latest")
  end

  @doc false
  defp docker_push(remote) do
    IO.puts("[...] Pushing #{remote}")
    {"docker", ["push", remote]}
  end

  @doc false
  defp docker_tag(image_name, remote) do
    IO.puts("[...] Tagging #{remote}")
    {"docker", ["tag", local(image_name), remote]}
  end

  @doc false
  defp git_sha do
    {sha, status} = System.cmd("git", ["rev-parse", "--short=7", "HEAD"])
    sha |> String.trim
  end

  @doc false
  defp system_run({cmd, args}) do
    System.cmd(cmd, args, into: IO.stream(:stdio, :line))
  end
end

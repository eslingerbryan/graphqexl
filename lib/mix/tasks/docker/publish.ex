defmodule Mix.Tasks.Docker.Publish do
  @shortdoc """
  Publish the built application container to the given image repo
  """

  def run([image_name, image_repo, image_tag]) do
    tag = image_tag || "#{git_sha}-dev"
    IO.puts "[STARTING] Publishing #{image_repo}/#{image_name}:#{tag}..."

    remote = docker_image(image_repo, image_name, tag)
    image_name
    |> docker_tag(remote)
    |> cmd_and(remote |> docker_push)

    IO.puts "[DONE] Publishing Docker image..."
  end

  defp cmd_and(cmd1, cmd2) do
    system_run(cmd1) && system_run(cmd2)
  end

  defp docker_image(name, repo, tag) do
    "#{repo}/#{name}:#{tag}"
  end

  defp local(image_name) do
    docker_image(image_name, "local-registry", "latest")
  end

  defp docker_push(remote) do
    IO.puts("[...] Pushing #{remote}")
    {"docker", ["push", remote]}
  end

  defp docker_tag(image_name, remote) do
    IO.puts("[...] Tagging #{remote}")
    {"docker", ["tag", local(image_name), remote]}
  end

  defp git_sha do
    {sha, status} = System.cmd("git", ["rev-parse", "--short=7", "HEAD"])
    sha |> String.trim
  end

  defp system_run({cmd, args}) do
    System.cmd(cmd, args, into: IO.stream(:stdio, :line))
  end
end

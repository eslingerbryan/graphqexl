defmodule Mix.Tasks.Docker.Publish do
  @moduledoc """
  Publish the built application container to the given image repo
  """
  @moduledoc since: "0.1.0"

  @type exit_status:: non_neg_integer
  @type command_result:: {Collectable.t, exit_status}
  @type command_tuple:: {String.t, list(String.t)}

  @git_sha_args ["rev-parse", "--short=7", "HEAD"]

  @doc """
  Publish the built application container to the given image repo

  ARGS
    - image_name, string, e.g.: "graphqexl"
    - image_repo, string, e.g.: "gcr.io/graphqexl"
    - image_tag, string, e.g.: "latest"
  """
  @doc since: "0.1.0"
  @spec run([String.t]) :: :ok
  def run([image_name, image_repo, image_tag]) do
    tag = image_tag || "#{git_sha()}-dev"
    "[STARTING] Publishing #{image_repo}/#{image_name}:#{tag}..." |> IO.puts

    remote = docker_image(image_repo, image_name, tag)
    image_name
    |> docker_tag(remote)
    |> cmd_and(remote |> docker_push)

    "[DONE] Publishing Docker image..." |> IO.puts
  end

  @doc false
  @spec cmd_and(command_tuple, command_tuple):: command_result
  defp cmd_and(cmd1, cmd2), do: cmd1 |> system_run && cmd2 |> system_run

  @doc false
  @spec docker_image(String.t, String.t, String.t):: String.t
  defp docker_image(name, repo, tag), do: "#{repo}/#{name}:#{tag}"

  @doc false
  @spec local(String.t):: String.t
  defp local(image_name), do: image_name |> docker_image("local-registry", "latest")

  @doc false
  @spec docker_push(String.t):: {String.t, list(String.t)}
  defp docker_push(remote) do
    "[...] Pushing #{remote}" |> IO.puts
    {"docker", ["push", remote]}
  end

  @doc false
  @spec docker_tag(String.t, String.t):: command_tuple
  defp docker_tag(image_name, remote) do
    "[...] Tagging #{remote}" |> IO.puts
    {"docker", ["tag", local(image_name), remote]}
  end

  @doc false
  @spec git_sha:: String.t
  defp git_sha, do: "git" |> System.cmd(@git_sha_args) |> elem(0) |> String.trim


  @doc false
  @spec system_run(command_tuple):: command_result
  defp system_run({cmd, args}), do: System.cmd(cmd, args, into: IO.stream(:stdio, :line))
end

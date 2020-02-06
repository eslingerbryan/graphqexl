defmodule Mix.Tasks.Docker.Build do
  @moduledoc """
  Build the application's Docker Image
  """
  @moduledoc since: "0.1.0"

  @type exit_status:: non_neg_integer
  @type command_result:: {Collectable.t, exit_status}
  @type command_tuple:: {String.t, list(String.t)}

  @docker_buildkit {"DOCKER_BUILDKIT", "1"}

  @doc """
  Build the application's Docker image

  ARGS
    - image_name, string, e.g.: "graphqexl"
    - image_repo, string, e.g.: "gcr.io/absynthe"
    - release_name, string, e.g.: "stable"
  """
  @doc since: "0.1.0"
  @spec run([String.t]) :: :ok
  def run([image_name, image_repo, release_name]) do
    "[STARTING] Building #{image_repo}/#{image_name}:#{release_name} Docker image..." |> IO.puts

    image_name
    |> docker_build(image_repo, release_name)
    |> run_with_buildkit

    "[DONE] Building #{image_repo}/#{image_name}:#{release_name} Docker image..." |> IO.puts
  end

  @doc false
  @spec build_params(String.t, String.t, String.t):: list(String.t)
  defp build_params(image_name, image_repo, release_name) do
    [
      "build",
      ".",
      "-t",
      "#{image_repo}/#{image_name}",
      "--build-arg",
      "release_name=#{release_name}"
    ]
  end

  @doc false
  @spec docker_build(String.t, String.t, String.t):: command_tuple
  defp docker_build(image_name, image_repo, release_name),
       do: {"docker", image_name |> build_params(image_repo, release_name)}

  @doc false
  @spec run_with_buildkit(command_tuple):: command_result
  defp run_with_buildkit({cmd, args}),
       do: cmd |> System.cmd(args, env: [@docker_buildkit], into: :stdio |> IO.stream(:line))
end

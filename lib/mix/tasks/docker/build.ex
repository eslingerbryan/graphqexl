defmodule Mix.Tasks.Docker.Build do
  @shortdoc """
  Build the application's Docker image

  ARGS
    - image_name, string, e.g.: "graphqexl"
    - image_repo, string, e.g.: "gcr.io/absynthe"
    - release_name, string, e.g.: "stable"
  """

  def run([image_name, image_repo, release_name]) do
    IO.puts "[STARTING] Building #{image_repo}/#{image_name}:#{release_name} Docker image..."

    image_name
    |> docker_build(image_repo, release_name)
    |> run_with_buildkit

    IO.puts "[DONE] Building #{image_repo}/#{image_name}:#{release_name} Docker image..."
  end

  defp build_params(image_name, image_repo, release_name) do
    ["build", ".", "-t", "#{image_repo}/#{image_name}", "--build-arg", "release_name=#{release_name}"]
  end

  defp docker_build(image_name, image_repo, release_name) do
    {"docker", image_name |> build_params(image_repo, release_name)}
  end

  defp run_with_buildkit({cmd, args}) do
    System.cmd(cmd, args, env: [{"DOCKER_BUILDKIT", "1"}], into: IO.stream(:stdio, :line))
  end
end

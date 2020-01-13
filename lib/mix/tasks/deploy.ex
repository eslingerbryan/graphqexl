defmodule Mix.Tasks.Deploy do
  @shortdoc """
  Deploy the containerized application to Kubernetes via KDT
  """

  def run([image_name, do_deploy?]) do
    IO.puts "[STARTING] Deploy #{image_name}..."

    [
      kdt_generate,
      kdt_push([image_name]),
      kdt_publish,
    ] |> Enum.map(&IO.puts/1)

    !!do_deploy? && (kdt_deploy(image_name |> deploy_args) |> IO.puts)

    IO.puts "[DONE] Deploy #{image_name}"
  end

  defp deploy_args(image_name) do
    [
      "--context=gke_liveramp-eng-actfs_us-central1_actfs-prod",
      "--artifact=prod",
      "--project=#{image_name}",
      "--dry-run=false",
      "--build=late",
    ]
  end

  defp kdt_deploy(args), do: kdt_run("deploy", args)
  defp kdt_generate(), do: kdt_run("generate", [])
  defp kdt_generate(args), do: kdt_run("generate", args)
  defp kdt_publish(), do: kdt_run("publish", [])
  defp kdt_publish(args), do: kdt_run("publish", args)
  defp kdt_push(args), do: kdt_run("push", args)

  defp kdt_run(cmd, args) do
    {
      "docker",
      [
        "run",
        "--rm",
        "--workdir=/app",
        "--volume=#{System.cwd}}:/app",
        "--volume=/var/run/docker.sock:/var/run/docker.sock",
        "-e GIT_BRANCH=feature/ci",
        "gcr.io/liveramp-eng/kube_deploy_tools:2.2.26",
        "kdt",
        cmd
      ] |> Enum.concat(args)
    } |> system_cmd
  end

  defp system_cmd({cmd, args}) do
    cmd |> System.cmd(args, env: [{"DOCKER_BUILDKIT", "1"}])

    "[...] #{cmd} #{args |> Enum.join(" ")}"
  end
end

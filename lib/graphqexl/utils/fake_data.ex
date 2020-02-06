defmodule Graphqexl.Utils.FakeData do
  @moduledoc """
  Contains some basic fake post, comment and user data to use in development/testing.
  """
  @moduledoc since: "0.1.0"
  @users %{
    "0d3633a8-c271-42c8-9e30-1913930306ff" => %{
      id: "0d3633a8-c271-42c8-9e30-1913930306ff",
      created_at: "2020-01-25 03:02:06",
      updated_at: "2019-03-12 01:46:22",
      firstName: "Joe",
      lastName: "Schmoe",
      email: "joe.schmoe@gmail.com"
    },
    "96fd2987-76a5-431b-babd-73b643f14347" => %{
      id: "96fd2987-76a5-431b-babd-73b643f14347",
      created_at: "2019-12-29 23:42:53",
      updated_at: "2019-01-30 07:45:36",
      firstName: "Jill",
      lastName: "Somebody",
      email: "jsomebody@gmail.com",
    },
    "906bc692-54b9-4829-a4a5-101b55c84601" => %{
      id: "906bc692-54b9-4829-a4a5-101b55c84601",
      created_at: "2019-02-26 19:56:19",
      updated_at: "2019-03-01 20:08:30",
      firstName: "Testy",
      lastName: "McTesterson",
      email: "testy.mctesterson@gmail.com",
    },
  }

  @comments %{
    "116ac2a5-6515-40e0-a483-e211acf82642" => %{
      id: "116ac2a5-6515-40e0-a483-e211acf82642",
      created_at: "2020-01-08 18:12:15",
      updated_at: "2019-12-20 18:12:17",
      text: "Here is a comment",
      author: @users |> Map.get("0d3633a8-c271-42c8-9e30-1913930306ff"),
      parent: %{id: "efb97c69-f27e-49c5-b823-57a8a414ac1f"},
    },
    "5077d49f-3fee-49b3-9af0-5258f424a9a8" => %{
      id: "5077d49f-3fee-49b3-9af0-5258f424a9a8",
      created_at: "2019-07-26 14:05:53",
      updated_at: "2019-04-19 02:16:51",
      text: "Here is a second comment",
      author: @users |> Map.get("96fd2987-76a5-431b-babd-73b643f14347"),
      parent: %{id: "efb97c69-f27e-49c5-b823-57a8a414ac1f"},
    },
    "b0eecb6b-2333-45c0-891a-2bc80a4a7091" => %{
      id: "b0eecb6b-2333-45c0-891a-2bc80a4a7091",
      created_at: "2019-08-03 05:09:08",
      updated_at: "2019-02-08 02:02:14",
      text: "Here is a reply",
      author: @users |> Map.get("96fd2987-76a5-431b-babd-73b643f14347"),
      parent: %{id: "5077d49f-3fee-49b3-9af0-5258f424a9a8"},
    },
    "5b439242-4ff4-4207-9f65-5f8f18fd8664" => %{
      id: "5b439242-4ff4-4207-9f65-5f8f18fd8664",
      created_at: "2019-04-03 05:33:34",
      updated_at: "2019-12-16 18:51:54",
      text: "I disagree with your overall premise",
      author: @users |> Map.get("0d3633a8-c271-42c8-9e30-1913930306ff"),
      parent: %{id: "b1148cb4-add2-4c09-96eb-fceefa49be0d"},
    },
    "1b933f56-a9aa-4da3-8fad-6f6990b0420b" => %{
      id: "1b933f56-a9aa-4da3-8fad-6f6990b0420b",
      created_at: "2019-01-06 14:57:28",
      updated_at: "2019-06-01 06:32:00",
      text: "I disagree with your disagreement.",
      author: @users |> Map.get("906bc692-54b9-4829-a4a5-101b55c84601"),
      parent: %{id: "5b439242-4ff4-4207-9f65-5f8f18fd8664"},
    },
  }
  @doc """
  Get a single comment by ID

  Returns: `t:Map.t/0`
  """
  @doc since: "0.1.0"
  @spec comment(String.t) :: Map.t
  def comment(id), do: @comments |> Map.get(id)
  @doc """
  Get all comments

  Returns: `[t:Map.t/0]`
  """
  @doc since: "0.1.0"
  @spec comments :: list(Map.t)
  def comments, do: @comments

  @posts %{
    "efb97c69-f27e-49c5-b823-57a8a414ac1f" => %{
      id: "efb97c69-f27e-49c5-b823-57a8a414ac1f",
      created_at: "2019-03-16 11:22:47",
      updated_at: "2019-07-03 23:10:50",
      title: "This is a cool post",
      text: """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
      labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
      laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
      voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
      cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
      """,
      author: @users |> Map.get("906bc692-54b9-4829-a4a5-101b55c84601"),
      comments: @comments
                |> Enum.filter(
                     fn({_, comment}) ->
                       comment.parent.id == "efb97c69-f27e-49c5-b823-57a8a414ac1f"
                     end
                   ) |> Enum.map(&(&1 |> elem(1))),
    },
    "b1148cb4-add2-4c09-96eb-fceefa49be0d" => %{
      id: "b1148cb4-add2-4c09-96eb-fceefa49be0d",
      created_at: "2019-03-16 11:22:47",
      updated_at: "2019-07-03 23:10:50",
      title: "This is an awesome post",
      text: """
      On the other hand, we denounce with righteous indignation and dislike men who are so beguiled
      and demoralized by the charms of pleasure of the moment, so blinded by desire, that they
      cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those
      who fail in their duty through weakness of will, which is the same as saying through
      shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a
      free hour, when our power of choice is untrammelled and when nothing prevents our being able
      to do what we like best, every pleasure is to be welcomed and every pain avoided. But in
      certain circumstances and owing to the claims of duty or the obligations of business it will
      frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man
      therefore always holds in these matters to this principle of selection: he rejects pleasures
      to secure other greater pleasures, or else he endures pains to avoid worse pains.
      """,
      author: @users |> Map.get("906bc692-54b9-4829-a4a5-101b55c84601"),
    },
    comments: @comments
              |> Enum.filter(
                   fn({_, comment}) ->
                     comment.parent.id == "b1148cb4-add2-4c09-96eb-fceefa49be0d"
                   end
                 ) |> Enum.map(&(&1 |> elem(1))),
  }
  @doc """
  Get a single post by ID

  Returns: `t:Map.t/0`
  """
  @doc since: "0.1.0"
  @spec post(String.t) :: Map.t
  def post(id), do: @posts |> Map.get(id)
  @doc """
  Get all posts

  Returns: `[t:Map.t/0]`
  """
  @doc since: "0.1.0"
  @spec posts :: list(Map.t)
  def posts, do: @posts

  @doc """
  Get a single user by ID

  Returns: `t:Map.t/0`
  """
  @doc since: "0.1.0"
  @spec user(String.t) :: Map.t
  def user(id), do: @users |> Map.get(id)
  @doc """
  Get all users

  Returns: `[t:Map.t/0]`
  """
  @doc since: "0.1.0"
  @spec users :: list(Map.t)
  def users, do: @users
  @doc """
  Get all comments for a single user by ID

  Returns: `[t:Map.t/0]`
  """
  @doc since: "0.1.0"
  @spec user_comments(String.t) :: list(Map.t)
  def user_comments(id), do: @comments |> filter_by_author_id(id)
  @doc """
  Get all posts for a single user by ID

  Returns: `[t:Map.t/0]`
  """
  @doc since: "0.1.0"
  @spec user_posts(String.t) :: list(Map.t)
  def user_posts(id), do: @posts |> filter_by_author_id(id)

  @doc false
  @spec author_id(Map.t):: String.t
  defp author_id(map), do: map |> Map.get(:author) |> Map.get(:id)

  @doc false
  @spec filter_by_author_id(Map.t, String.t):: list(Map.t)
  defp filter_by_author_id(map, id), do: map |> Enum.filter(fn {_, v} ->  id == v |> author_id end)
end

defmodule MetaInspector do
  @moduledoc false

  def get_info(link) do
    link
    |> fetch_head
    |> get_all_meta_tags
    |> Enum.flat_map(&fetch_name_content/1)
    |> Enum.into(%{})
  end

  def search(map, key) do
    map
    |> Enum.find(fn {k, _} -> k =~ key end)
  end

  defp fetch_head(link) do
    id = HTTPoison.get!(link, %{}, stream_to: self).id
    loop(id)
  end
  defp get_all_meta_tags(string) do
    ~r/<meta.*?>/
    |> Regex.scan(string)
    |> List.flatten
  end
  defp fetch_name_content(string) do
    case Regex.run(~r/(name|property)=["'](.+?)["']/, string) do
      [_, _, name] ->
        case Regex.run(~r/content=["'](.+?)["']/, string) do
          [_, content] -> [{name, content}]
          nil -> []
      nil -> []
    end
  end

  defp loop(id, data \\ "") do
    receive do
      %HTTPoison.AsyncStatus{code: 200, id: ^id} -> loop(id, data)
      %HTTPoison.AsyncStatus{code: _, id: ^id} -> nil
      %HTTPoison.AsyncHeaders{id: ^id} -> loop(id, data)
      %HTTPoison.AsyncChunk{chunk: chunk, id: ^id} ->
        data = data <> chunk
        if data =~ "</head>" do
          data
        else
          loop(id, data <> chunk)
        end
      %HTTPoison.AsyncEnd{id: ^id} -> data
    end
  end
end

defmodule MetaInspectorTest do
  use ExUnit.Case
  doctest MetaInspector

  @link "http://www.imdb.com/title/tt0117500/"

  test "Gets the info about the link" do
    res = MetaInspector.get_info(@link)

    map = for key <- ["og:title", "description"],
      res = MetaInspector.search(res, key),
      res != nil,
      {k, value} = res,
      do: {key, value},
      into: %{}

    IO.inspect res
    assert map == %{
      "og:title" => "The Rock (1996)",
      "description" => "Directed by Michael Bay.  With Sean Connery, Nicolas Cage, Ed Harris, John Spencer. A mild-mannered chemist and an ex-con must lead the counterstrike when a rogue group of military men, led by a renegade general, threaten a nerve gas attack from Alcatraz against San Francisco."
    }
  end
end

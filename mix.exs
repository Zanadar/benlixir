defmodule Benlixir.Mixfile do
  use Mix.Project

  def project do
    [app: :benlixir,
     version: "0.1.7",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: description,
     package: package ]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    A small bencode library.
    """
  end

  defp package do
    [name: :bendy,
    maintainers: ["Zander Mackie"],
    licenses: ["MIT"],
    links: %{"Github" => "https://github.com/Zanadar/benlixir"}]
  end

  defp deps do
    [{:ex_doc, "~> 0.10", only: :dev}]
  end
end

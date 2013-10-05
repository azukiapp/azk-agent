defmodule AzkAgent.Utils.Representer do
  alias AzkAgent.Utils.JSON

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: :macros
      Module.register_attribute __MODULE__, :properties, accumulate: true
      Module.register_attribute __MODULE__, :links, accumulate: true

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def build(data) do
        unquote(__MODULE__).build_data(__MODULE__, @properties, @links, data)
      end
    end
  end

  defmacro property(p) do
    quote do
      @properties unquote(p)
    end
  end

  defmacro link(type, do: contents) do
    func = :"link_#{type}"
    var      = Macro.escape({:represented, [], nil})
    contents = Macro.escape(contents, unquote: true)

    quote bind_quoted: binding do
      @links type
      def unquote(func)(unquote(var)), do: unquote(contents)
    end
  end

  def build_data(module, properties, links, data) when
    not is_record(data, HashDict) and is_record(data) do
    build_data(module, properties, links, data.to_keywords)
  end

  def build_data(module, properties, links, data) do
    # Fix key acess
    data = Enum.map(data, fn
      {key, value} -> { :"#{key}", value }
    end)

    links = Enum.map(links, &{&1, [ href: apply(module, :"link_#{&1}", [data])]})
    dict  = Enum.map(properties, &{&1, data[&1]})
    dict  = Dict.put(dict, :_links, links)
    JSON.encode(dict, pre_encode: fn
      nil -> :null
      value -> value
    end)
  end
end


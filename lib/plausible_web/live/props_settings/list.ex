defmodule PlausibleWeb.Live.PropsSettings.List do
  @moduledoc """
  Phoenix LiveComponent module that renders a list of custom properties
  """
  use PlausibleWeb, :live_component

  attr(:props, :list, required: true)
  attr(:domain, :string, required: true)
  attr(:filter_text, :string)
  attr(:add_prop_loading, :boolean)

  def render(assigns) do
    ~H"""
    <div>
      <.filter_bar filter_text={@filter_text} placeholder="Search Properties">
        <div class="flex items-center space-x-2">
          <%= if @add_prop_loading do %>
            <svg class="inline w-4 h-4 ml-2 text-white animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          <% end %>
          <.button phx-click="add-prop" mt?={false} disabled={@add_prop_loading}>
            Add Property
          </.button>
        </div>
      </.filter_bar>
      <%= if is_list(@props) && length(@props) > 0 do %>
        <.table id="allowed-props" rows={Enum.with_index(@props)}>
          <:tbody :let={{prop, index}}>
            <.td id={"prop-#{index}"}><span class="font-medium">{prop}</span></.td>
            <.td actions>
              <.delete_button
                id={"disallow-prop-#{prop}"}
                data-confirm={delete_confirmation_text(prop)}
                phx-click="disallow-prop"
                phx-value-prop={prop}
                aria-label={"Remove #{prop} property"}
              />
            </.td>
          </:tbody>
        </.table>
      <% else %>
        <p class="mt-12 mb-8 text-center text-sm">
          <span :if={String.trim(@filter_text) != ""}>
            No properties found for this site. Please refine or
            <.styled_link phx-click="reset-filter-text" id="reset-filter-hint">
              reset your search.
            </.styled_link>
          </span>
          <span :if={String.trim(@filter_text) == "" && Enum.empty?(@props)}>
            No properties configured for this site.
          </span>
        </p>
      <% end %>
    </div>
    """
  end

  defp delete_confirmation_text(prop) do
    """
    Are you sure you want to remove the following property:

    #{prop}

    This will just affect the UI, all of your analytics data will stay intact.
    """
  end
end

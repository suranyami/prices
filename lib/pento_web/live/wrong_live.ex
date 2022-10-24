defmodule PentoWeb.WrongLive do
  @moduledoc false
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
  alias Pento.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {
      :ok,
      assign(
        socket,
        score: 0,
        number: :rand.uniform(10),
        message: "Guess a number.",
        session_id: session["live_socket_id"],
        current_user: user,
        time: time()
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2><%= @message %></h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
    </h2>
    <h2>
    <%= @message %> It's <%= @time %>
    <pre>
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
    </h2>
    """
  end

  def time() do
    Timex.local()
    |> Timex.format!("{h24}:{m}:{s}")
  end

  @spec handle_event(
          <<_::40>>,
          map,
          atom
          | %{:assigns => atom | %{:number => any, optional(any) => any}, optional(any) => any}
        ) :: {:noreply, any}
  def handle_event("guess", %{"number" => guess_string}, socket) do
    number = socket.assigns.number

    with {guess, _} <- Integer.parse(guess_string) do
      state =
        if guess == number do
          %{
            message: "You got it!",
            score: socket.assigns.score + 1,
            time: time()
          }
        else
          %{
            message: "Your guess: #{guess}. Wrong. Guess again. ",
            score: socket.assigns.score - 1,
            time: time()
          }
        end

      {:noreply, assign(socket, state)}
    else
      :error ->
        {:noreply, socket}
    end
  end
end

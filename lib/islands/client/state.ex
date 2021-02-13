# ┌─────────────────────────────────────────────────────────────────┐
# │ Inspired by the course "Elixir for Programmers" by Dave Thomas. │
# └─────────────────────────────────────────────────────────────────┘
defmodule Islands.Client.State do
  @moduledoc """
  Creates a client `state` struct for the _Game of Islands_.

  ##### Inspired by the course [Elixir for Programmers](https://codestool.coding-gnome.com/courses/elixir-for-programmers) by Dave Thomas.
  """

  alias __MODULE__
  alias Islands.{Engine, Game, Player, PlayerID, Tally}

  @default_options %{mode: :manual, pause: 0}
  @genders [:f, :m]
  @modes [:manual, :auto]
  @pause_range 0..10_000
  @player_ids [:player1, :player2]

  @enforce_keys [
    :game_name,
    :player_name,
    :gender,
    :player_id,
    :mode,
    :pause,
    :move,
    :tally
  ]
  defstruct [
    :game_name,
    :player_name,
    :gender,
    :player_id,
    :mode,
    :pause,
    :move,
    :tally
  ]

  @type t :: %State{
          game_name: Game.name(),
          player_name: Player.name(),
          gender: Player.gender(),
          player_id: PlayerID.t(),
          mode: :manual | :auto,
          pause: 0..10_000,
          move: [String.codepoint() | non_neg_integer | String.t()],
          tally: Tally.t()
        }

  @spec new(
          Game.name(),
          PlayerID.t(),
          Player.name(),
          Player.gender(),
          Keyword.t()
        ) :: t
  def new(game_name, player_id, player_name, gender, options \\ [])

  def new(game_name, player_id, player_name, gender, options)
      when is_binary(game_name) and is_binary(player_name) and
             player_id in @player_ids and gender in @genders and
             is_list(options) do
    %{mode: mode, pause: pause} = parse(options)

    %State{
      game_name: game_name,
      player_name: player_name,
      gender: gender,
      player_id: player_id,
      mode: mode,
      pause: pause,
      move: [],
      tally: Engine.tally(game_name, player_id)
    }
  end

  def new(_game_name, _player_id, _player_name, _gender, _options),
    do: {:error, :invalid_client_state_args}

  ## Private functions

  @spec parse(Keyword.t()) :: map
  defp parse(options), do: parse(options, @default_options)

  @spec parse(Keyword.t(), map) :: map
  defp parse([], options), do: options

  defp parse([{:mode, mode} | rest], options) when mode in @modes,
    do: parse(rest, %{options | mode: mode})

  defp parse([{:pause, pause} | rest], options) when pause in @pause_range,
    do: parse(rest, %{options | pause: pause})

  defp parse([_bad_option | rest], options), do: parse(rest, options)
end

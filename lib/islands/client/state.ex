# ┌─────────────────────────────────────────────────────────────────┐
# │ Inspired by the course "Elixir for Programmers" by Dave Thomas. │
# └─────────────────────────────────────────────────────────────────┘
defmodule Islands.Client.State do
  use PersistConfig

  @course_ref Application.get_env(@app, :course_ref)

  @moduledoc """
  Creates a client `state` struct for the _Game of Islands_.
  \n##### #{@course_ref}
  """

  alias __MODULE__
  alias Islands.{Engine, Player, PlayerID, Tally}

  @default_options %{mode: :manual, pause: 0, basic: false}
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
          game_name: String.t(),
          player_name: String.t(),
          gender: Player.gender(),
          player_id: PlayerID.t(),
          mode: :manual | :auto,
          pause: 0..10_000,
          move: [String.codepoint() | non_neg_integer | String.t()],
          tally: Tally.t() | nil
        }

  @spec new(String.t(), PlayerID.t(), String.t(), atom, Keyword.t()) :: t
  def new(game_name, player_id, player_name, gender, options \\ [])

  def new(game_name, player_id, player_name, gender, options)
      when is_binary(game_name) and is_binary(player_name) and
             player_id in @player_ids and gender in @genders and
             is_list(options) do
    %{mode: mode, pause: pause, basic: basic?} = parse(options)

    %State{
      game_name: game_name,
      player_name: player_name,
      gender: gender,
      player_id: player_id,
      mode: mode,
      pause: pause,
      move: [],
      tally: if(basic?, do: nil, else: Engine.tally(game_name, player_id))
    }
  end

  def new(_game_name, _player_id, _player_name, _gender, _options),
    do: {:error, :invalid_client_state_args}

  ## Private functions

  @spec parse(Keyword.t()) :: map
  defp parse(options), do: parse(options, @default_options)

  @spec parse(Keyword.t(), map) :: map
  defp parse([], options), do: options

  defp parse([{:basic, basic?} | rest], options) when is_boolean(basic?),
    do: parse(rest, %{options | basic: basic?})

  defp parse([{:mode, mode} | rest], options) when mode in @modes,
    do: parse(rest, %{options | mode: mode})

  defp parse([{:pause, pause} | rest], options) when pause in @pause_range,
    do: parse(rest, %{options | pause: pause})

  defp parse([_bad_option | rest], options), do: parse(rest, options)
end

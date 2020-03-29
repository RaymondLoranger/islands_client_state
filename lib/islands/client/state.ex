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
  alias Islands.{Player, PlayerID, Tally}

  @default_options [mode: :manual, pause: 0]
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
    :move
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
      when is_binary(game_name) and is_binary(player_name) and
             player_id in @player_ids and gender in @genders and
             is_list(options) do
    options = Keyword.merge(@default_options, options)
    [mode: mode, pause: pause] = options(options[:mode], options[:pause])

    %State{
      game_name: game_name,
      player_name: player_name,
      gender: gender,
      player_id: player_id,
      mode: mode,
      pause: pause,
      move: []
    }
  end

  ## Private functions

  @spec options(atom, non_neg_integer) :: Keyword.t()
  defp options(mode, pause) when mode in @modes and pause in @pause_range,
    do: [mode: mode, pause: pause]

  defp options(_mode, _pause), do: @default_options
end

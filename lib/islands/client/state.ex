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
          tally: Tally.t()
        }

  @spec new(String.t(), PlayerID.t(), String.t(), atom, atom, pos_integer) :: t
  def new(game_name, player_id, player_name, gender, mode, pause) do
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
end

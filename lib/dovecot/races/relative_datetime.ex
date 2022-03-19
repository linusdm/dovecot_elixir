defmodule Dovecot.Races.RelativeDateTime do
  use Ecto.Type

  @enforce_keys [:days, :time]
  defstruct [:days, :time]

  def type, do: :error

  def cast(input) when is_binary(input) do
    with [days, time] <- input |> String.trim() |> String.split(" "),
         {days, _} <- Integer.parse(days),
         {:ok, time} <- Time.from_iso8601(time) do
      {:ok, %__MODULE__{days: days, time: time}}
    else
      _ -> :error
    end
  end

  def cast(_), do: :error

  def load(_), do: :error

  def dump(_), do: :error

  def create(%Date{}, nil), do: nil

  def create(%Date{} = start_date, %NaiveDateTime{} = date_time) do
    %__MODULE__{
      days: Date.diff(NaiveDateTime.to_date(date_time), start_date),
      time: NaiveDateTime.to_time(date_time)
    }
  end

  def get_datetime(%Date{} = start_date, %__MODULE__{} = relative_datetime) do
    start_date
    |> Date.add(relative_datetime.days)
    |> NaiveDateTime.new!(relative_datetime.time)
  end
end

defimpl Phoenix.HTML.Safe, for: Dovecot.Races.RelativeDateTime do
  def to_iodata(%Dovecot.Races.RelativeDateTime{days: days, time: time}),
    do: "#{days} #{Time.to_iso8601(time)}"
end

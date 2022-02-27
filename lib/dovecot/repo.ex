defmodule Dovecot.Repo do
  use Ecto.Repo,
    otp_app: :dovecot,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  # TODO: determine tables to ignore when adding loft_id in where clause dynamically
  #       (check with __struct__(:fields) ?)
  @ignore_tables ["users", "users_tokens", "lofts"]

  @impl true
  def prepare_query(_operation, query, opts) do
    {table, _schema} = query.from.source

    cond do
      Enum.member?(@ignore_tables, table) || opts[:skip_loft_id] || opts[:schema_migration] ->
        {query, opts}

      loft_id = opts[:loft_id] ->
        {Ecto.Query.where(query, loft_id: ^loft_id), opts}

      true ->
        raise "expected loft_id or skip_loft_id to be set"
    end
  end

  @impl true
  def default_options(_operation) do
    [loft_id: get_loft_id()]
  end

  @tenant_key {__MODULE__, :loft_id}

  def put_loft_id(loft_id) do
    Process.put(@tenant_key, loft_id)
  end

  def get_loft_id() do
    Process.get(@tenant_key)
  end
end

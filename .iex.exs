alias Getaways.Vacation.{Place, Booking, Review}
alias Getaways.Accounts.User

alias Getaways.Repo
alias Getaways.Vacation
alias Getaways.Accounts

import Ecto.Query

defmodule App do
  def restart() do
    Application.stop(Getaways.Application)
    recompile()
    Application.ensure_all_started(Getaways.Application)
  end
end

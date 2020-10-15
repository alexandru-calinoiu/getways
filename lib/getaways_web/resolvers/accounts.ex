defmodule GetawaysWeb.Resolvers.Accounts do
  alias Getaways.Accounts
  alias GetawaysWeb.Schema.ChangesetErrors

  def signup(_, args, _) do
    case Accounts.create_user(args) do
      {:ok, user} ->
        {:ok, %{user: user, token: GetawaysWeb.AuthToken.sign(user)}}

      {:error, changeset} ->
        {:error,
         message: "Could not create account", details: ChangesetErrors.error_details(changeset)}
    end
  end

  def signin(_, %{username: username, password: password}, _) do
    case Accounts.authenticate(username, password) do
      {:ok, user} ->
        {:ok, %{user: user, token: GetawaysWeb.AuthToken.sign(user)}}

      :error ->
        {:erro, message: "Unknown username or password"}
    end
  end

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end
end

#   def signin(_, %{username: username, password: password}, _) do
#     case Accounts.authenticate(username, password) do
#       :error ->
#         {:error, "Whoops, invalid credentials!"}

#       {:ok, user} ->
#         token = GetawaysWeb.AuthToken.sign(user)
#         {:ok, %{user: user, token: token}}
#     end
#   end

#   def signup(_, args, _) do
#     case Accounts.create_user(args) do
#       {:error, changeset} ->
#         {
#           :error,
#           message: "Could not create account",
#           details: ChangesetErrors.error_details(changeset)
#         }

#       {:ok, user} ->
#         token = GetawaysWeb.AuthToken.sign(user)
#         {:ok, %{user: user, token: token}}
#     end
#   end

#   def me(_, _, %{context: %{current_user: user}}) do
#     {:ok, user}
#   end

#   def me(_, _, _) do
#     {:ok, nil}
#   end
# end

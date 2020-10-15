defmodule GetawaysWeb.Resolvers.Vacation do
  alias Getaways.Vacation
  alias GetawaysWeb.Schema.ChangesetErrors

  def place(_, %{slug: slug}, _) do
    {:ok, Vacation.get_place_by_slug!(slug)}
  end

  def places(_, args, _) do
    {:ok, Vacation.list_places(args)}
  end

  def reviews_for_place(place, _, _) do
    {:ok, Getaways.Vacation.reviews_for_places(place)}
  end

  def create_booking(_, args, %{context: %{current_user: user}}) do
    case Vacation.create_booking(user, args) do
      {:ok, booking} ->
        {:ok, booking}

      {:error, changeset} ->
        {:error,
         message: "Could not create booking", details: ChangesetErrors.error_details(changeset)}
    end
  end

  def cancel_booking(_, %{booking_id: booking_id}, %{context: %{current_user: user}}) do
    booking = Vacation.get_booking!(booking_id)

    if booking.user_id == user.id do
      case Vacation.cancel_booking(booking) do
        {:ok, booking} ->
          publish_booking_change(booking)
          {:ok, booking}

        {:error, changeset} ->
          {:error,
           message: "Could not cancel booking", details: ChangesetErrors.error_details(changeset)}
      end
    else
      {:error, message: "Can't cancel a booking"}
    end
  end

  def create_review(_, args, %{context: %{current_user: user}}) do
    case Vacation.create_review(user, args) do
      {:ok, review} ->
        {:ok, review}

      {:error, changeset} ->
        {:error,
         message: "Could not create review", details: ChangesetErrors.error_details(changeset)}
    end
  end

  defp publish_booking_change(booking) do
    Absinthe.Subscription.publish(
      GetawaysWeb.Endpoint,
      booking,
      booking_change: booking.place_id
    )
  end

  # def place(_, %{slug: slug}, _) do
  #   {:ok, Vacation.get_place_by_slug!(slug)}
  # end

  # def places(_, args, _) do
  #   {:ok, Vacation.list_places(args)}
  # end

  # def create_booking(_, args, %{context: %{current_user: user}}) do
  #   case Vacation.create_booking(user, args) do
  #     {:error, changeset} ->
  #       {:error,
  #        message: "Could not create booking",
  #        details: ChangesetErrors.error_details(changeset)
  #       }

  #     {:ok, booking} ->
  #       publish_booking_change(booking)
  #       {:ok, booking}
  #   end
  # end

  # def cancel_booking(_, args, %{context: %{current_user: user}}) do
  #   booking = Vacation.get_booking!(args[:booking_id])

  #   # Make sure the user owns the booking
  #   if (booking.user_id == user.id) do
  #     case Vacation.cancel_booking(booking) do
  #       {:error, changeset} ->
  #         {
  #           :error,
  #           message: "Could not cancel booking!",
  #           details: ChangesetErrors.error_details(changeset)
  #         }

  #       {:ok, booking} ->
  #         publish_booking_change(booking)
  #         {:ok, booking}
  #     end
  #   else
  #     {
  #       :error,
  #       message: "Hey, that's not your booking!"
  #     }
  #   end
  # end

  # def create_review(_, args, %{context: %{current_user: user}}) do
  #   case Vacation.create_review(user, args) do
  #     {:error, changeset} ->
  #       {
  #         :error,
  #         message: "Could not create review!",
  #         details: ChangesetErrors.error_details(changeset)
  #       }

  #     {:ok, review} ->
  #       {:ok, review}
  #   end
  # end

  # defp publish_booking_change(booking) do
  #   Absinthe.Subscription.publish(
  #     GetawaysWeb.Endpoint,
  #     booking,
  #     booking_change: booking.place_id
  #   )
  # end
end

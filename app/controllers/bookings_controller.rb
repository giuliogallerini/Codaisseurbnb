class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(booking_params[:room_id])
    # checkin, checkout = get_dates(booking_params)
    # if @room.available?(checkin, checkout)
      total_price = get_total_price(booking_params)
      @booking = current_user.bookings.create(booking_params.merge(total: total_price, price: @room.price ))
      if @booking.id
        redirect_to @booking.room, notice: "Thank you for booking!"
      # end
      else
        redirect_to @room, notice: "Sorry! This listing is not available during the dates you requested."
      end
  end

  private

  def get_total_price(booking_params)
    checkin, checkout = get_dates(booking_params)

    total_days = (checkout - checkin).to_i
    @room.price * total_days
  end

  def get_dates(booking_params)
    checkin  =  Date.new(booking_params["starts_at(1i)"].to_i,
                         booking_params["starts_at(2i)"].to_i,
                         booking_params["starts_at(3i)"].to_i)

    checkout =  Date.new(booking_params["ends_at(1i)"].to_i,
                         booking_params["ends_at(2i)"].to_i,
                         booking_params["ends_at(3i)"].to_i)

    return checkin, checkout
  end

  def booking_params
    params.require(:booking).permit(:starts_at, :ends_at, :room_id)
  end
end

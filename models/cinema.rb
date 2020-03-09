require("pry")

class Cinema

  attr_reader :room_sizes, :occupied_seats

  def initialize(room_sizes)
    @room_sizes= room_sizes
    @occupied_seats= @room_sizes.map{|seat| 0}
  end

  def can_customer_enter_room(room_index)
    if @occupied_seats[room_index] < @room_sizes[room_index]
      return true
    else
      return false
    end
  end

  def one_customer_occupies_seat(room_index)
    @occupied_seats[room_index]+=1
  end


end

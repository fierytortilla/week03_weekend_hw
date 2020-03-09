require_relative("../db/sql_runner")
require_relative("ticket")
require_relative("film")
require_relative("ticket")
require_relative("cinema")
require("pry-byebug")

class Screening

  attr_reader :film_id, :ticket_id, :id, :show_time

  def initialize(options)
    @film_id= options['film_id']
    @ticket_id= options['ticket_id']
    @show_time= options['show_time']
    @id= options['id'] if options['id']
  end

  def save()
    sql= "INSERT INTO screenings
          (film_id, ticket_id, show_time)
          VALUES
          ($1, $2, $3)
          RETURNING id"
    values=[@film_id, @ticket_id, @show_time]
    @id= SqlRunner.run(sql, values).first()['id']
  end

  def self.map_out(sql_results)
    return sql_results.map{|result| Screening.new(result)}
  end

  def self.all()
    sql= "SELECT * FROM screenings"
    return Screening.map_out(SqlRunner.run(sql))
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM screenings where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE screenings SET (
      film_id,
      ticket_id,
      show_time) =
    ($1, $2, $3)
    WHERE id = $4"
    values= [@film_id, @ticket_id, @show_time, @id]
    SqlRunner.run(sql, values)
  end

  def self.display_most_popular_show_time(film_id)
    sql= "SELECT show_time
          FROM (SELECT show_time, COUNT(*) as count,
             ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) as seqnum
             FROM screenings s JOIN
                tickets t
                ON s.ticket_id = t.id
                WHERE s.film_id = $1
                GROUP BY show_time
               ) st
          WHERE seqnum = 1"
    values= [film_id]
    show_time= SqlRunner.run(sql, values)
    return show_time[0]['show_time']
  end

  def self.customer_buys_ticket(customer, film, show_time, cinema, room_index)
    if customer.funds>= film.price && cinema.can_customer_enter_room(room_index)
      #binding.pry()
      customer.funds-=film.price
      cinema.one_customer_occupies_seat(room_index)
      ticket={'film_id'=>film.id, 'customer_id'=>customer.id}
      ticket= Ticket.new(ticket)
      ticket.save()
      screening= {'film_id'=>film.id, 'ticket_id'=>ticket.id, 'show_time'=> show_time}
      screening= Screening.new(screening)
      screening.save()
      return ticket, screening
    elsif customer.funds<film.price
      p "The customer does not have enough funds for the film."
      return nil
    elsif cinema.can_customer_enter_room(room_index)
      p "The screening has no more available seating."
      return nil
    else
    end
  end


end

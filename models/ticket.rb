require_relative("../db/sql_runner")
require_relative("customer")
require_relative("film")

class Ticket

  attr_reader :film_id, :customer_id, :id

  def initialize(options)
    @film_id= options['film_id']
    @customer_id= options['customer_id']
    @id= options['id'] if options['id']
  end

  def save()
    sql= "INSERT INTO tickets
          (film_id, customer_id)
          VALUES
          ($1, $2)
          RETURNING id"
    values=[@film_id, @customer_id]
    @id= SqlRunner.run(sql, values).first()['id']
  end

  def self.map_out(sql_results)
    return sql_results.map{|result| Ticket.new(result)}
  end

  def self.all()
    sql= "SELECT * FROM tickets"
    return Ticket.map_out(SqlRunner.run(sql))
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM tickets where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE tickets SET (
      film_id,
      customer_id) =
    ($1,$2)
    WHERE id = $3"
    values= [@film_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.display_all_customers_by_film(film_id)
    sql= "SELECT customers.* FROM customers
          INNER JOIN tickets
          ON tickets.customer_id = customers.id
          WHERE film_id = $1"
    values= [film_id]
    customers= SqlRunner.run(sql, values)
    return Customer.map_out(customers)
  end

  def self.display_all_films_by_customer(customer_id)
    sql= "SELECT films.* FROM films
          INNER JOIN tickets
          ON tickets.film_id = films.id
          WHERE customer_id = $1"
    values= [customer_id]
    films= SqlRunner.run(sql, values)
    return Film.map_out(films)
  end

  def self.check_number_of_customers_for_film(film_id)
    sql= "SELECT customers.* FROM customers
          INNER JOIN tickets
          ON tickets.customer_id = customers.id
          WHERE film_id = $1"
    values= [film_id]
    customers= SqlRunner.run(sql, values)
    return customers.count()
  end

  def self.check_number_of_tickets_from_customer(customer_id)
    sql= "SELECT films.* FROM films
          INNER JOIN tickets
          ON tickets.film_id = films.id
          WHERE customer_id = $1"
    values= [customer_id]
    films= SqlRunner.run(sql, values)
    return films.count()
  end


end

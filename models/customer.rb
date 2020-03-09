require_relative("../db/sql_runner")

class Customer

  attr_reader :name, :id
  attr_accessor :funds

  def initialize(options)
    @name= options['name']
    @funds= options['funds']
    @id= options['id'] if options['id']
  end

  def save()
    sql= "INSERT INTO customers
          (name, funds)
          VALUES
          ($1, $2)
          RETURNING id"
    values=[@name, @funds]
    @id= SqlRunner.run(sql, values).first()['id']
  end

  def self.map_out(sql_results)
    return sql_results.map{|result| Customer.new(result)}
  end

  def self.all()
    sql= "SELECT * FROM customers"
    return Customer.map_out(SqlRunner.run(sql))
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE customers SET (
      name,
      funds) =
    ($1,$2)
    WHERE id = $3"
    values= [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end


end

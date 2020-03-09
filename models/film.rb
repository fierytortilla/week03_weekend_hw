require_relative("../db/sql_runner")

class Film

  attr_reader :title, :price, :id

  def initialize(options)
    @title= options['title']
    @price= options['price'].to_i()
    @id= options['id'].to_i() if options['id']
  end

  def save()
    sql= "INSERT INTO films
          (title, price)
          VALUES
          ($1, $2)
          RETURNING id"
    values=[@title, @price]
    @id= SqlRunner.run(sql, values).first()['id']
  end

  def self.map_out(sql_results)
    return sql_results.map{|result| Film.new(result)}
  end

  def self.all()
    sql= "SELECT * FROM films"
    return Film.map_out(SqlRunner.run(sql))
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "
    UPDATE films SET (
      title,
      price) =
    ($1,$2)
    WHERE id = $3"
    values= [@title, @price, @id]
    SqlRunner.run(sql, values)
  end


end

require("minitest/autorun")
require "minitest/reporters"
require("pry-byebug")
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
#the code in sql_runner.rb gives us the ability to connect to our database and safely pass in prepared queries
require_relative("../db/sql_runner")
#the code in the Film class gives us access to the Film methods and attributes
require_relative("../models/film")

class PDA_Data_Test< Minitest::Test

  def search_data_in_database_films_table()
    #this query is designed to search for data in films table of the cinemas database whose title is equal to Miami Connection
    sql="SELECT * FROM films WHERE title='Miami Connection'"
    results= SqlRunner.run(sql)
    #the results of the SQL query are processed to become an array of Film objects, which have the data of the SQL query stored as attributes of the objects
    return Film.map_out(results)
  end

  def test_search_data_in_database_films_table()
    film_results= search_data_in_database_films_table()
    #if the search works, the first element of the film_results array will have the title "Miami Connection", which was inserted into the films table in the console.rb script (please refer to the Github link attached)
    assert_equal("Miami Connection", film_results[0].title)
  end


  def sort_data_in_database_films_table()
    #this query is designed to retrieve the titles and prices of films from the films table and then sort them by descending value
    sql= "SELECT title,price FROM films ORDER BY price DESC"
    results= SqlRunner.run(sql)
    #this array of Film objects will be sorted from highest to lowest ticket price
    return Film.map_out(results)
  end

  def test_sort_data_in_database_films_table()
    price_results= sort_data_in_database_films_table()
    #the most expensive movie had a ticket price of 10, while the cheapest movie had a ticket price of 5. So the first element of the array will have the highest price, while the last element will have the lowest.
    assert_equal(10, price_results.first().price)
    assert_equal(5, price_results.last().price)
  end

end

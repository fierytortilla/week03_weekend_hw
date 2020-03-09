require_relative("models/customer")
require_relative("models/film")
require_relative("models/ticket")
require_relative("models/screening")
require_relative("models/cinema")
require("pry-byebug")

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()
Screening.delete_all()

room_sizes= [20, 30, 5]
cinema= Cinema.new(room_sizes)

film1= Film.new({'title'=>'Jack and Jill', 'price'=>5})
film2= Film.new({'title'=>'Miami Connection', 'price'=>8})
film3= Film.new({'title'=>'The Room', 'price'=>10})
film4= Film.new({'title'=>'Princess Mononoke', 'price'=>9})


film1.save()
film2.save()
film3.save()
film4.save()

customer1= Customer.new({'name'=>'Viper', 'funds'=>50})
customer2= Customer.new({'name'=>'Jim Bob', 'funds'=>90})
customer3= Customer.new({'name'=>'Solid Snake', 'funds'=>2})

customer1.save()
customer2.save()


ticket_screening1= Screening.customer_buys_ticket(customer1, film1, '20:30',cinema, 1)
ticket_screening2= Screening.customer_buys_ticket(customer2, film1, '18:30',cinema, 2)
ticket_screening3= Screening.customer_buys_ticket(customer2, film1, '20:30',cinema, 1)

ticket_screening4= Screening.customer_buys_ticket(customer3, film2, '17:00', cinema,1)

Ticket.display_all_customers_by_film(film1.id)

Ticket.check_number_of_customers_for_film(film1.id)

Ticket.check_number_of_tickets_from_customer(customer1.id)

Screening.display_most_popular_show_time(film1.id)

binding.pry()

nil

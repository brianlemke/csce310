require 'rubygems'
require 'bundler/setup'
require 'faker'
require './models'

module RecordGenerator

  def RecordGenerator.generate_id(digits = 20)
    id = ''
    digits.times do
      id += Random.rand(10).to_s
    end
    id
  end

  def RecordGenerator.generate_date
    Time.at(rand * Time.now.to_i).to_date
  end

  def RecordGenerator.generate_customers(count)
    customers = []
    count.times do
      customer = nil
      begin
        customer = Models::Customer.new
        customer.customer_id = generate_id
        customer.first_name = Faker::Name.first_name
        customer.last_name = Faker::Name.last_name
        customer.birth_date = generate_date
      end while customers.include?(customer)
      customers << customer
    end
    customers
  end

  def RecordGenerator::write_customers(io, customers)
    customers.each do |customer|
      io.puts customer.insert_statement
    end
  end

  if __FILE__ == $0
    write_customers($stdout, generate_customers(100))
  end

end

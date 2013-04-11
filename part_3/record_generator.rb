require 'rubygems'
require 'bundler/setup'
require 'faker'
require './models'

module RecordGenerator

  NUM_CUSTOMERS = 100
  NUM_LIBRARIES = 100

  CUSTOMER_FILE = 'insert_customers.sql'
  LIBRARY_FILE  = 'insert_libraries.sql'

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

  def RecordGenerator.generate_libraries(count)
    libraries = []
    count.times do
      library = nil
      begin
        library = Models::Library.new
        library.name = Faker::Company.name
        library.address = Faker::Address.street_address
        library.city = Faker::Address.city
        library.zip = Faker::Address.zip_code
      end while libraries.include?(library)
      libraries << library
    end
    libraries
  end

  def RecordGenerator.write_inserts(io, models)
    models.each do |model|
      io.puts model.insert_statement
    end
  end

  if __FILE__ == $0
    customers = generate_customers(NUM_CUSTOMERS)
    libraries = generate_libraries(NUM_LIBRARIES)
    File.open(CUSTOMER_FILE, 'w') { |file| write_inserts(file, customers) }
    File.open(LIBRARY_FILE, 'w') { |file| write_inserts(file, libraries) }
  end

end

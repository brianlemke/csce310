require 'rubygems'
require 'bundler/setup'
require 'faker'
require './models'

module RecordGenerator

  NUM_CUSTOMERS = 100
  NUM_LIBRARIES = 100
  NUM_ITEMS     = 100
  NUM_LOANS     = 100
  NUM_EMPLOYEES = 100
  NUM_ACCESSES  = 100

  CUSTOMER_FILE = 'insert_customers.sql'
  LIBRARY_FILE  = 'insert_libraries.sql'
  ITEM_FILE     = 'insert_items.sql'
  LOAN_FILE     = 'insert_loans.sql'
  EMPLOYEE_FILE = 'insert_employees.sql'
  ACCESSES_FILE = 'insert_accesses.sql'

  MEDIA_TYPES = ['book', 'movie', 'audio']
  BOOK_GENRES = ['young adult', 'fantasy', 'sci-fi', 'non-fiction', 'fiction',
                 'romance', 'adventure', 'reference', 'travel', 'children']
  MOVIE_GENRES = ['western', 'comedy', 'romance', 'sci-fi', 'drama',
                  'documentary', 'educational']
  AUDIO_GENRES = ['rock', 'blues', 'classical', 'metal', 'pop', 'electronic',
                  'country', 'folk']

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

  def RecordGenerator.generate_year
    Array(1900...Time.now.year).sample
  end

  def RecordGenerator.generate_title
    Faker::Lorem.words(Random.rand(2..6)).join(' ')
  end

  def RecordGenerator.generate_salary
    Random.rand(500...10000) + Random.rand(0..100) / 100.0
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

  def RecordGenerator.generate_items(count, libraries)
    items = []
    count.times do
      item = nil
      begin
        item = Models::Item.new
        item.item_id = generate_id
        item.library_name = libraries.sample.name
        item.media_type = MEDIA_TYPES.sample

        if item.media_type == 'book'
          item.author = Faker::Name.name
          item.title = generate_title
          item.year = generate_year
          item.length = Random.rand(100..2000)
          item.genre = BOOK_GENRES.sample
        elsif item.media_type == 'movie'
          item.title = generate_title
          item.year = generate_year
          item.length = Random.rand(10..200)
          item.genre = MOVIE_GENRES.sample
        elsif item.media_type == 'audio'
          item.title = generate_title
          item.year = generate_year
          item.length = Random.rand(200..2000)
          item.genre = AUDIO_GENRES.sample
          item.artist = Faker::Name.name
        else
          raise Exception "Unknown media_type"
        end
      end while items.include?(item)
      items << item
    end
    items
  end

  def RecordGenerator.generate_employees(count, libraries)
    employees = []
    count.times do
      employee = nil
      begin
        employee = Models::Employee.new
        employee.employee_id = generate_id
        employee.last_name = Faker::Name.last_name
        employee.first_name = Faker::Name.first_name
        employee.title = Faker::Name.title
        employee.salary = generate_salary
        if Random.rand(10) != 0
          employee.library_name = libraries.sample.name
        end
      end while employees.include?(employee)
      employees << employee
    end
    employees
  end

  def RecordGenerator.generate_accesses(count, customers, libraries)
    access_list = []
    count.times do
      accesses = nil
      begin
        accesses = Models::Accesses.new
        accesses.customer_id = customers.sample.customer_id
        accesses.library_name = libraries.sample.name
      end while access_list.include?(accesses)
      access_list << accesses
    end
    access_list
  end

  def RecordGenerator.generate_loans(count, libraries, items)
    loans = []
    count.loans do
      loan = nil
      begin
        loan = Models::Loan.new
        loan.lendingLibrary = libraries.sample.name
        loan.borrowingLibrary = libraries.sample.name
        loan.dateOut = generate_date
        loan.itemID = items.sample.itemID
      end while loans.include?(loan)
      loans << loan
    end
    loans
  end

  def RecordGenerator.escape(value)
    if value.nil?
      'NULL'
    else
      value.to_s.gsub("'", "''")
      "'" + value.to_s.gsub("'", "''") + "'"
    end
  end

  def RecordGenerator.insert_libraries(libraries)
    raise ArgumentError "empty array" if libraries.empty?
    statement = "insert into Library (name, address, city, zip) values \n"
    libraries.each do |library|
      statement += "(#{escape library.name}, " +
                    "#{escape library.address}, " +
                    "#{escape library.city}, " +
                    "#{escape library.zip})"
      if library == libraries.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  def RecordGenerator.insert_customers(customers)
    raise ArgumentError "empty array" if customers.empty?
    statement = "insert into Customer (customerID, firstName, lastName, " +
                  "birthDate) values \n"
    customers.each do |customer|
      statement += "(#{escape customer.customer_id}, " +
                    "#{escape customer.first_name}, " +
                    "#{escape customer.last_name}, " +
                    "#{escape customer.birth_date.iso8601})"
      if customer == customers.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  def RecordGenerator.insert_items(items)
    raise ArgumentError "empty array" if items.empty?
    statement = "insert into Item (itemID, libraryName, mediaType, author, " +
                  "title, year, length, genre, artist) values \n"
    items.each do |item|
      statement += "(#{escape item.item_id}, " +
                    "#{escape item.library_name}, " +
                    "#{escape item.media_type}, " +
                    "#{escape item.author}, " +
                    "#{escape item.title}, " +
                    "#{escape item.year}, " +
                    "#{escape item.length}, " +
                    "#{escape item.genre}, " +
                    "#{escape item.artist})"
      if item == items.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  def RecordGenerator.insert_loans(loans)
    raise ArgumentError "empty array" if loans.empty?
    statement = "insert into Loan (lendingLibrary, borrowingLibrary, dateOut, itemId) values \n"
    loans.each do |loan|
      statement += "(#{escape loan.lendingLibrary}, "+
                    "#{escape loan.borrowingLibrary},"+
                    "#{escape loan.dateOut},"+
                    "#{escape loan.itemId})"
      if item == items.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  def RecordGenerator.insert_employees(employees)
    raise ArgumentError "empty array" if employees.empty?
    statement = "insert into Employee (employeeID, lastName, firstName, " +
                  "title, salary, libraryName) values \n"
    employees.each do |employee|
      statement += "(#{escape employee.employee_id}, " +
                    "#{escape employee.last_name}, " +
                    "#{escape employee.first_name}, " +
                    "#{escape employee.title}, " +
                    "#{employee.salary}, " +
                    "#{escape employee.library_name})"
      if employee == employees.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  def RecordGenerator.insert_accesses(access_list)
    raise ArgumentError "empty array" if access_list.empty?
    statement = "insert into Accesses (customerID, libraryName) values \n"
    access_list.each do |accesses|
      statement += "(#{escape accesses.customer_id}, " +
                    "#{escape accesses.library_name})"
      if accesses == access_list.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  if __FILE__ == $0
    customers = generate_customers(NUM_CUSTOMERS)
    libraries = generate_libraries(NUM_LIBRARIES)
    items = generate_items(NUM_ITEMS, libraries)
    employees = generate_employees(NUM_EMPLOYEES, libraries)
    accesses = generate_accesses(NUM_ACCESSES, customers, libraries)
    File.open(CUSTOMER_FILE, 'w') do |file|
      file.puts insert_customers(customers)
    end
    File.open(LIBRARY_FILE, 'w') do |file|
      file.puts insert_libraries(libraries)
    end
    File.open(ITEM_FILE, 'w') do |file|
      file.puts insert_items(items)
    end
    File.open(EMPLOYEE_FILE, 'w') do |file|
      file.puts insert_employees(employees)
    end
    File.open(ACCESSES_FILE, 'w') do |file|
      file.puts insert_accesses(accesses) end
  end

end

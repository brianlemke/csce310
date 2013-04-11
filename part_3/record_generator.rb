require 'rubygems'
require 'bundler/setup'
require 'faker'
require './models'

# Module containing the functions to generate a set of library data. Can be
# invoked as an executable script or used as a library.
module RecordGenerator

  # Set the number of records to generate for each relation
  NUM_CUSTOMERS = 500
  NUM_LIBRARIES = 30
  NUM_ITEMS     = 1000
  NUM_LOANS     = 200
  NUM_EMPLOYEES = 100
  NUM_ACCESSES  = 5000
  NUM_CHECKOUTS = 1000

  # Set the file names to write each relation to
  CUSTOMER_FILE = 'insert_customers.sql'
  LIBRARY_FILE  = 'insert_libraries.sql'
  ITEM_FILE     = 'insert_items.sql'
  LOAN_FILE     = 'insert_loans.sql'
  EMPLOYEE_FILE = 'insert_employees.sql'
  ACCESSES_FILE = 'insert_accesses.sql'
  CHECKOUT_FILE = 'insert_checkouts.sql'

  # Set the permissible values for some of the relations that enumerable fields
  MEDIA_TYPES = ['book', 'movie', 'audio']
  BOOK_GENRES = ['young adult', 'fantasy', 'sci-fi', 'non-fiction', 'fiction',
                 'romance', 'adventure', 'reference', 'travel', 'children']
  MOVIE_GENRES = ['western', 'comedy', 'romance', 'sci-fi', 'drama',
                  'documentary', 'educational']
  AUDIO_GENRES = ['rock', 'blues', 'classical', 'metal', 'pop', 'electronic',
                  'country', 'folk']

  # Generate a string of random digits
  def RecordGenerator.generate_id(digits = 20)
    id = ''
    digits.times do
      id += Random.rand(10).to_s
    end
    id
  end

  # Generate a random date after 1970
  def RecordGenerator.generate_date
    Time.at(rand * Time.now.to_i).to_date
  end

  # Generate a date after a given date (no more than three weeks after)
  def RecordGenerator.generate_later_date(date)
    Array((date + 1)..(date + 21)).sample
  end

  # Generate a random year since 1900
  def RecordGenerator.generate_year
    Array(1900...Time.now.year).sample
  end

  # Generate a Lorem Ipsum title
  def RecordGenerator.generate_title
    Faker::Lorem.words(Random.rand(2..6)).join(' ')
  end

  # Generate a salary as a floating value
  def RecordGenerator.generate_salary
    Random.rand(500...10000) + Random.rand(0..100) / 100.0
  end

  # Generate a fine as a floating value
  def RecordGenerator.generate_fine
    Random.rand(0...100) + Random.rand(0..100) / 100.0
  end

  # Generate a list of customers of size count
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

  # Generate a list of libraries of size count
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

  # Generate a list of items of size count
  def RecordGenerator.generate_items(count, libraries)
    items = []
    count.times do
      item = nil
      begin
        item = Models::Item.new
        item.item_id = generate_id
        item.library_name = libraries.sample.name
        item.media_type = MEDIA_TYPES.sample

        # Items need separate fields for each media type
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

  # Generate a list of employees of size count. Most employees will belong to
  # one of the libraries, but some will not.
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

  # Generate a list of accesses of size count. All accesses will have a valid
  # customer and library from the provided list.
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

  # Generate a list of loans of size count. All loans will have valid libraries
  # and items.
  def RecordGenerator.generate_loans(count, libraries, items)
    loans = []
    count.times do
      loan = nil
      begin
        loan = Models::Loan.new
        loan.lending_library = libraries.sample.name

        # Ensure that the borrowing library is different from the lending
        # library
        valid_borrowers = libraries.reject do |library|
          library.name == loan.lending_library
        end
        loan.borrowing_library = valid_borrowers.sample.name

        loan.date_out = generate_date

        # Ensure that the item belongs to the lending library
        valid_items = items.select do |item|
          item.library_name == loan.lending_library
        end
        loan.item_id = valid_items.sample.item_id unless valid_items.empty?
      end while loans.include?(loan) or loan.item_id.nil?
      loans << loan
    end
    loans
  end

  
  # Generate a list of checkouts of size count. All checkouts will have valid
  # customers, libraries, and items.
  def RecordGenerator.generate_checkouts(count, libraries, items, customers, accesses)
    checkouts = []
    count.times do
      checkout = nil
      begin
        checkout = Models::Checkout.new
        checkout.library_name = libraries.sample.name
        
        # Ensure that the customer has access to the library
        valid_accesses = accesses.select do |access|
          access.library_name == checkout.library_name
        end
        checkout.customer_id = valid_accesses.sample.customer_id unless valid_accesses.empty?

        # Ensure that the item belongs to the library
        valid_items = items.select do |item|
          item.library_name == checkout.library_name
        end
        checkout.item_id = valid_items.sample.item_id unless valid_items.empty?

        checkout.fine_amount = generate_fine
        checkout.date_out = generate_date
        checkout.date_due = generate_later_date(checkout.date_out)
      end while checkouts.include?(checkout) or checkout.customer_id.nil? or checkout.item_id.nil?
      checkouts << checkout
    end
    checkouts
  end

  # Replace all single quotes with two single quotes. Surround the string with
  # single quotes.
  def RecordGenerator.escape(value)
    if value.nil?
      'NULL'
    else
      value.to_s.gsub("'", "''")
      "'" + value.to_s.gsub("'", "''") + "'"
    end
  end

  # Create an insert into command for the libraries list.
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

  # Create an insert into command for the customers list.
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

  # Create an insert into command for the items list.
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
                    "#{item.year}, " +
                    "#{item.length}, " +
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

  # Create an insert into command for the loans list.
  def RecordGenerator.insert_loans(loans)
    raise ArgumentError "empty array" if loans.empty?
    statement = "insert into Loan (lendingLibrary, borrowingLibrary, dateOut, " +
                  "itemID) values \n"
    loans.each do |loan|
      statement += "(#{escape loan.lending_library}, "+
                    "#{escape loan.borrowing_library}, " +
                    "#{escape loan.date_out.iso8601}, " +
                    "#{escape loan.item_id})"
      if loan == loans.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  # Create an insert into command for the employees list
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

  # Create an insert into command for the accesses list
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

  # Create an insert into command for the checkouts list
  def RecordGenerator.insert_checkouts(checkouts)
    raise ArguementError "empty array" if checkouts.empty?
    statement = "insert into Checkout (libraryName, customerID, itemID, " +
      "fineAmount, dateOut, dateDue) values \n"
    checkouts.each do |checkout|
      statement += "(#{escape checkout.library_name}, " + 
                    "#{escape checkout.customer_id}, " +
                    "#{escape checkout.item_id}, " +
                    "#{checkout.fine_amount}, " +
                    "#{escape checkout.date_out.iso8601}, " +
                    "#{escape checkout.date_due.iso8601})"
      if checkout == checkouts.last
        statement += ";"
      else
        statement += ",\n"
      end
    end
    statement
  end

  # If we are running this file as a script, then generate all the data and
  # write it to insert files. Otherwise, do nothing (act as a library).
  if __FILE__ == $0
    # Generate arrays in order of dependencies
    puts "Generating customers..."
    customers = generate_customers(NUM_CUSTOMERS)
    puts "Generating libraries..."
    libraries = generate_libraries(NUM_LIBRARIES)
    puts "Generating items..."
    items = generate_items(NUM_ITEMS, libraries)
    puts "Generating employees..."
    employees = generate_employees(NUM_EMPLOYEES, libraries)
    puts "Generating accesses..."
    accesses = generate_accesses(NUM_ACCESSES, customers, libraries)
    puts "Generating checkouts..."
    checkouts = generate_checkouts(NUM_CHECKOUTS, libraries, items, customers, accesses)
    puts "Generating loans..."
    loans = generate_loans(NUM_LOANS, libraries, items)
    puts "Done generating"

    # Write the generated insert into commands to a files
    puts "Saving customers..."
    File.open(CUSTOMER_FILE, 'w') do |file|
      file.puts insert_customers(customers)
    end
    puts "Saving libraries..."
    File.open(LIBRARY_FILE, 'w') do |file|
      file.puts insert_libraries(libraries)
    end
    puts "Saving items..."
    File.open(ITEM_FILE, 'w') do |file|
      file.puts insert_items(items)
    end
    puts "Saving employees..."
    File.open(EMPLOYEE_FILE, 'w') do |file|
      file.puts insert_employees(employees)
    end
    puts "Saving accesses..."
    File.open(ACCESSES_FILE, 'w') do |file|
      file.puts insert_accesses(accesses)
    end
    puts "Saving checkouts..."
    File.open(CHECKOUT_FILE, 'w') do |file|
      file.puts insert_checkouts(checkouts)
    end
    puts "Saving loans..."
    File.open(LOAN_FILE, 'w') do |file|
      file.puts insert_loans(loans)
    end
    puts "Done"
  end
end

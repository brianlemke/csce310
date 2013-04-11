module Models

  def Models.escape(value)
    value.to_s.gsub("'", "''")
  end

  class Library

    def name
      @name
    end

    def name=(name)
      @name = name
    end

    def address
      @address
    end

    def address=(address)
      @address = address
    end

    def city
      @city
    end

    def city=(city)
      @city = city
    end

    def zip
      @zip
    end

    def zip=(zip)
      @zip = zip
    end

    def duplicate_keys?(library)
      return true if name == library.name
    end

    def ==(library)
      duplicate_keys?(library)
    end

    def insert_statement
      "insert into Library (name, address, city, zip) values (" +
        "'#{Models.escape(name)}', " +
        "'#{Models.escape(address)}', " +
        "'#{Models.escape(city)}', " +
        "'#{Models.escape(zip)}');"
    end

  end

  class Customer

    def customer_id
      @customer_id
    end

    def customer_id=(customer_id)
      @customer_id = customer_id
    end

    def first_name
      @first_name
    end

    def first_name=(first_name)
      @first_name = first_name
    end

    def last_name
      @last_name
    end

    def last_name=(last_name)
      @last_name = last_name
    end

    def birth_date
      @birth_date
    end

    def birth_date=(birth_date)
      @birth_date = birth_date
    end

    def duplicate_keys?(customer)
      return true if customer_id == customer.customer_id
      false
    end

    def ==(library)
      duplicate_keys?(library)
    end

    def insert_statement
      insert = "insert into Customer (customerID, firstName, lastName, " +
        "birthDate) values (" +
        "'#{Models.escape customer_id}', " +
        "'#{Models.escape first_name}', " +
        " '#{Models.escape last_name}', " +
        "'#{Models.escape birth_date.iso8601}');"
    end

  end
end

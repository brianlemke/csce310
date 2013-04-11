module Models

  def Models.escape(value)
    value.gsub("'", "''")
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
        "birthDate) values ('#{customer_id}', '#{Models.escape first_name}'" +
        ", '#{Models.escape last_name}', '#{birth_date.iso8601}');"
    end

  end
end

# File: models.rb
#
# This file containes the Models module, which contains the class definitions
# for the data objects representing a record in each of our database's
# relations.

module Models

  # Represents a record in the Library table. name is the primary key
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

    # Check whether this object has the same key as another Library
    def duplicate_keys?(library)
      if name == library.name
        true
      else
        false
      end
    end

    # For our purposes, equality means duplicate keys
    def ==(library)
      duplicate_keys?(library)
    end
  end

  # Represents a record in the Customer table. customer_id is the primary key
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

    # Check whether this object has the same key as another Customer
    def duplicate_keys?(customer)
      if customer_id == customer.customer_id
        true
      else
        false
      end
    end

    # For our purposes, equality means duplicate keys
    def ==(library)
      duplicate_keys?(library)
    end
  end

  # Represents a record in the Item table. customer_id and library_name
  # are the primary key
  class Item

    def item_id
      @item_id
    end

    def item_id=(item_id)
      @item_id = item_id
    end

    def library_name
      @library_name
    end

    def library_name=(library_name)
      @library_name = library_name
    end

    # Since the Item reliation is derived from an inheritance hierarchy,
    # this attribute determines which type of item this object is
    def media_type
      @media_type
    end

    def media_type=(media_type)
      @media_type = media_type
    end

    def author
      @author
    end

    def author=(author)
      @author = author
    end

    def title
      @title
    end

    def title=(title)
      @title = title
    end

    def year
      @year
    end

    def year=(year)
      @year = year
    end

    def length
      @length
    end

    def length=(length)
      @length = length
    end

    def genre
      @genre
    end

    def genre=(genre)
      @genre = genre
    end

    def artist
      @artist
    end

    def artist=(artist)
      @artist = artist
    end

    # Check if this object has the same key as another object
    def duplicate_keys?(item)
      if item_id == item.item_id and library_name == item.library_name
        true
      else
        false
      end
    end

    # For our purposes, equality means having the same key
    def ==(item)
      duplicate_keys?(item)
    end
  end

  # Represents a record in the Employee relation. The primary key is employee_id
  class Employee

    def employee_id
      @employee_id
    end

    def employee_id=(employee_id)
      @employee_id = employee_id
    end

    def last_name
      @last_name
    end

    def last_name=(last_name)
      @last_name = last_name
    end

    def first_name
      @first_name
    end

    def first_name=(first_name)
      @first_name = first_name
    end

    def title
      @title
    end

    def title=(title)
      @title = title
    end

    def salary
      @salary
    end

    def salary=(salary)
      @salary = salary
    end

    # This is not a mandatory attribute -- some employees can work for the
    # entire system rather than a single library
    def library_name
      @library_name
    end

    def library_name=(library_name)
      @library_name = library_name
    end

    # Check whether this object has the same key as another object
    def duplicate_keys?(employee)
      if employee_id == employee.employee_id
        true
      else
        false
      end
    end

    # For our purposes, equality means having the same key
    def ==(employee)
      duplicate_keys?(employee)
    end
  end

  # Represents a record in the Accesses table. customer_id and library_name are
  # the primary key
  class Accesses

    def customer_id
      @customer_id
    end

    def customer_id=(customer_id)
      @customer_id = customer_id
    end

    def library_name
      @library_name
    end

    def library_name=(library_name)
      @library_name = library_name
    end

    # Check whether this object has the same key as another object
    def duplicate_keys?(accesses)
      if customer_id == accesses.customer_id and library_name == accesses.library_name 
        true
      else
        false
      end
    end

    # For our purposes, equality means having the same key
    def ==(accesses)
      duplicate_keys?(accesses)
    end
  end

  # Represents a record in the Loan table. lending_library, item_id, and
  # date_out are the primary key
  class Loan

    def lending_library
      @lending_library
    end

    def lending_library=(lending_library)
      @lending_library = lending_library
    end

    def borrowing_library
      @borrowing_library
    end

    def borrowing_library=(borrowing_library)
      @borrowing_library = borrowing_library
    end

    def date_out
      @date_out
    end

    def date_out=(date_out)
      @date_out = date_out
    end

    def item_id
      @item_id
    end

    def item_id=(item_id)
      @item_id = item_id
    end

    # Check whether this object has the same key as another object
    def duplicate_keys?(loan)
      if lending_library == loan.lending_library and
         date_out == loan.date_out and
         item_id == loan.item_id
        true
      else
        false
      end
    end

    # For our purposes, equality means having the same key
    def ==(loan)
      duplicate_keys?(loan)
    end
  end
  
  # Represents a record in the Checkout table. library_name, item_id, and
  # date_out are the primary key
  class Checkout
  
    def library_name
      @library_name
    end

    def library_name=(library_name)
      @library_name = library_name
    end

    def customer_id
      @customer_id
    end

    def customer_id=(customer_id)
      @customer_id = customer_id
    end
  
    def item_id
      @item_id
    end

    def item_id=(item_id)
      @item_id = item_id
    end
	
    def fine_amount
      @fine_amount
    end
    
    def fine_amount=(fine_amount)
      @fine_amount = fine_amount
    end
    
    def date_out
      @date_out
    end
    
    def date_out=(date_out)
      @date_out = date_out
    end
    
    def date_due
      @date_due
    end
    
    def date_due=(date_due)
      @date_due= date_due
    end
    
    # Check whether this object has the same key as another object
    def duplicate_keys?(checkout)
      if item_id == checkout.item_id and
         library_name == checkout.library_name and
         date_out == checkout.date_out
        true
      else
        false
      end
    end
    
    # For our purposes, equality means having the same key
    def ==(checkout)
      duplicate_keys?(checkout)
    end
  end
end

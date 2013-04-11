module Models

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
      if name == library.name
        true
      else
        false
      end
    end

    def ==(library)
      duplicate_keys?(library)
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
      if customer_id == customer.customer_id
        true
      else
        false
      end
    end

    def ==(library)
      duplicate_keys?(library)
    end
  end

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

    def duplicate_keys?(item)
      if item_id == item.item_id and library_name == item.library_name
        true
      else
        false
      end
    end

    def ==(item)
      duplicate_keys?(item)
    end
  end

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

    def library_name
      @library_name
    end

    def library_name=(library_name)
      @library_name = library_name
    end

    def duplicate_keys?(employee)
      if employee_id == employee.employee_id
        true
      else
        false
      end
    end

    def ==(employee)
      duplicate_keys?(employee)
    end
  end

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

    def duplicate_keys?(accesses)
      if customer_id == accesses.customer_id and library_name == accesses.library_name 
        true
      else
        false
      end
    end

    def ==(accesses)
      duplicate_keys?(accesses)
    end
  end
end

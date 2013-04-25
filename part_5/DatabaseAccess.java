import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class DatabaseAccess
{
  private Connection conn;

  public static final String databaseUser     = "csce310";
  public static final String databasePassword = "";
  public static final String databaseName     = "csce310";
  public static final String databaseHost     = "localhost";


  private PreparedStatement getCustomer;
  private PreparedStatement getLibraries;
  private PreparedStatement addCustomer;
  private PreparedStatement addItem;
  private PreparedStatement getCustomerByName;
  private PreparedStatement getCustomerByLateFee;
  private PreparedStatement deleteEmployeeByID;
  // TODO: add all new SQL statements here

  public DatabaseAccess()
  {
    conn = null;
  }

  public boolean init()
  {
    String url = "jdbc:mysql://" + databaseHost + "/" + databaseName;
    if (databaseUser != "")
    {
      url += "?user=" + databaseUser;
      if (databaseUser != "")
      {
        url += "&password=" + databasePassword;
      }
    }

    try
    {
      Class.forName("com.mysql.jdbc.Driver").newInstance();
      conn = DriverManager.getConnection(url);

      return prepareStatements();
    }
    catch(Exception e)
    {
      System.out.println("Could not establish database connection: " + e);
      return false;
    }
  }

  public boolean prepareStatements()
  {
    String getCustomerString = "select * from Customer where customerId = ?";
    String getLibrariesString = "select * from Library order by name";
    String addCustomerString = "insert into Customer(customerID, lastName, " +
      "firstName, birthDate) values (?, ?, ?, ?)";
    String addItemString = "insert into Item(itemID, libraryName, mediaType, " +
      "author, title, year, length, genre, artist) values (?, ?, ?, ?, ?, ?, " +
      "?, ?, ?)";
    String getCustomerByNameString = 
    		"SELECT "+
    			"*"+
    		" FROM "+
    			Customer.CUSTOMER+
    			" JOIN "+
    			Accesses.ACCESSES+
    				" ON "+
    				Customer.CUSTOMER_ID+ " = "+ Accesses.CUSTOMER_ID+
    		" WHERE "+
    			Customer.FIRST_NAME+" = ?"+
    			" AND "+
    			Accesses.LIBRARY_NAME+" = ?";			
    String getCustomerByLateFeeString = 	
    		"SELECT "+
    				"result.firstName, result.lastName, result.totalFines, result.customerId"+
    		" FROM "+
				"( SELECT "+
	    			Customer.CUSTOMER_ID+ ", "+
	    			Customer.FIRST_NAME+ ", "+
	    			Customer.LAST_NAME+", "+
	    			
	    			"SUM( "+
	    				Checkout.FINE_AMOUNT+
	    			" ) as totalFines "+
	    		" FROM "+
	    			Customer.CUSTOMER+", "+
	    			Checkout.CHECKOUT+
	    		" WHERE "+
	    			Customer.CUSTOMER_ID+" = "+Checkout.CUSTOMER_ID+
	    		" GROUP BY "+
	    			Customer.CUSTOMER_ID+", "+
	    			Customer.FIRST_NAME+", "+
	    			Customer.LAST_NAME+
	    		" HAVING SUM( "+Checkout.FINE_AMOUNT+" ) > ?"+
	    		") AS result, "+
	    		
				"( SELECT "+
					"*"+
				" FROM "+
					Accesses.ACCESSES+
				" WHERE "+
					Accesses.LIBRARY_NAME+" = ?"+
				") AS lib "+
	    	" WHERE "+
				"lib.customerId = result.customerId";	
	String deleteEmployeeString = "DELETE FROM Employee WHERE employeeID = ?";
	// TODO: create any new SQL query strings here

    try
    {
      getCustomer = conn.prepareStatement(getCustomerString);
      getLibraries = conn.prepareStatement(getLibrariesString);
      addCustomer = conn.prepareStatement(addCustomerString);
      addItem = conn.prepareStatement(addItemString);
      getCustomerByName = conn.prepareStatement(getCustomerByNameString);
      getCustomerByLateFee = conn.prepareStatement(getCustomerByLateFeeString);
	  deleteEmployeeByID = conn.prepareStatement(deleteEmployeeString);
      // TODO: prepare any new statements here
      return true;
    }
    catch(SQLException e)
    {
      System.out.println("Error preparing statements: " + e);
      return false;
    }
  }

  public boolean terminate()
  {
    try
    {
      conn.close();
      return true;
    }
    catch(SQLException e)
    {
      System.out.println("Could not close database connection: " + e);
      return false;
    }
  }

  public boolean deleteEmployee(String employeeID) {
    try
    {
       deleteEmployeeByID.setString(1, employeeID);
       int rowCount = deleteEmployeeByID.executeUpdate();
        if (rowCount == 1)
        {
          return true;
        }
        else
        {
          return false;
        }
    }
	catch(SQLException e)
    {
      System.err.println("Error in getCustomer: " + e);
	  return false;
    }
  }
 
  public Customer getCustomer(String customerID)
  {
    try
    {
      getCustomer.setString(1, customerID);

      ResultSet rs = getCustomer.executeQuery();
      if (rs.next())
      {
        Customer customer = new Customer();
        customer.customerID = rs.getString("customerID");
        customer.lastName = rs.getString("lastName");
        customer.firstName = rs.getString("firstName");
        customer.birthDate = rs.getDate("birthDate");

        rs.close();
        return customer;
      }
      else
      {
        // No customers with that ID
        rs.close();
        return null;
      }
    }
    catch(SQLException e)
    {
      System.err.println("Error in getCustomer: " + e);
      return null;
    }
  }

  public ArrayList<Library> getLibraries()
  {
    ArrayList<Library> libraries = new ArrayList<Library>();

    try
    {
      ResultSet rs = getLibraries.executeQuery();

      while (rs.next())
      {
        Library l = new Library();
        l.name = rs.getString("name");
        l.address = rs.getString("address");
        l.city = rs.getString("city");
        l.zip = rs.getString("zip");
        libraries.add(l);
      }

      rs.close();
    }
    catch(SQLException e)
    {
      System.err.println("Error in getLibraries: " + e);
    }
    
    return libraries;
  }

  public boolean addCustomer(Customer c) 
  {
    try
    {
      addCustomer.setString(1, c.customerID);
      addCustomer.setString(2, c.lastName);
      addCustomer.setString(3, c.firstName);
      addCustomer.setDate(4, c.birthDate);

      int rowCount = addCustomer.executeUpdate();
      if (rowCount == 1)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(SQLException e)
    {
      System.err.println("Error in addCustomer: " + e);
      return false;
    }
  }

  public boolean addBook(Book b)
  {
    try
    {
      addItem.setString(1, b.itemID);
      addItem.setString(2, b.libraryName);
      addItem.setString(3, b.mediaType);
      addItem.setString(4, b.author);
      addItem.setString(5, b.title);
      addItem.setInt(6, b.year);
      addItem.setInt(7, b.length);
      addItem.setString(8, b.genre);
      addItem.setString(9, null);

      int rowCount = addItem.executeUpdate();
      if (rowCount == 1)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(SQLException e)
    {
      System.err.println("Error in addBook: " + e);
      return false;
    }
  }

  public boolean addMovie(Movie m)
  {
    try
    {
      addItem.setString(1, m.itemID);
      addItem.setString(2, m.libraryName);
      addItem.setString(3, m.mediaType);
      addItem.setString(4, null);
      addItem.setString(5, m.title);
      addItem.setInt(6, m.year);
      addItem.setInt(7, m.length);
      addItem.setString(8, m.genre);
      addItem.setString(9, null);

      int rowCount = addItem.executeUpdate();
      if (rowCount == 1)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(SQLException e)
    {
      System.err.println("Error in addMovie: " + e);
      return false;
    }
  }

  public boolean addAudio(Audio a)
  {
    try
    {
      addItem.setString(1, a.itemID);
      addItem.setString(2, a.libraryName);
      addItem.setString(3, a.mediaType);
      addItem.setString(4, null);
      addItem.setString(5, a.title);
      addItem.setInt(6, a.year);
      addItem.setInt(7, a.length);
      addItem.setString(8, a.genre);
      addItem.setString(9, a.artist);

      int rowCount = addItem.executeUpdate();
      if (rowCount == 1)
      {
        return true;
      }
      else
      {
        return false;
      }
    }
    catch(SQLException e)
    {
      System.err.println("Error in addAudio: " + e);
      return false;
    }
  }
 
  /**
   * Returns all users with the first name given
   * @param name
   * @return An arraylist of all users matching the criteria
   */
  public List<Customer> findUserByName(String name, String library){
	  ArrayList<Customer> customers = new ArrayList<Customer>();
	  ResultSet rs;
	  
	  try{
		  getCustomerByName.setString(1, name);
		  getCustomerByName.setString(2, library);
		  rs = getCustomerByName.executeQuery();
	  
		  while (rs.next()){
		    Customer customer = new Customer();
		    customer.customerID = rs.getString(Customer.CUSTOMER_ID);
		    customer.lastName = rs.getString(Customer.LAST_NAME);
		    customer.firstName = rs.getString(Customer.FIRST_NAME);
		    customer.birthDate = rs.getDate(Customer.BIRTHDATE);
		    
		    customers.add(customer);
		  }
		  rs.close();
	  } catch (SQLException e) {
		  System.err.println("Error in findUserByName");
		e.printStackTrace();
	  }
	  
	  return customers;
  }
  
  public List<String> findCustomerByLateFee(float fee, String libraryName){
	  ArrayList<String> customers = new ArrayList<String>();
	  ResultSet rs;
	  
	  try{
		  getCustomerByLateFee.setFloat(1, fee);
		  getCustomerByLateFee.setString(2, libraryName);
		  rs = getCustomerByLateFee.executeQuery();
	  
		  while (rs.next()){

		    String customer = new String();
  
		    customer+= Customer.CUSTOMER+": ";
		    customer+= "\n \t First Name: "+rs.getString("result.firstName");
		    customer+= "\n \t Last Name: "+rs.getString("result.lastName");
		    customer+= "\n \t Total Fines: "+rs.getFloat("result.totalFines");
		    customer+= "\n \t Customer Id: "+rs.getString("result.customerId");
		    
		    customers.add(customer);
		  }
		  
		  rs.close();
	  } catch (SQLException e) {
		  System.err.println("Error in findCustomerByLateFee");
		  e.printStackTrace();
	  }
	  
	  return customers;
  }

  // TODO: add any new database query/update helper methods here. Each method
  // should use PreparedStatements declared above. The methods should accept 
  // parameters and return values that use the custom data types, rather than
  // ResultSets.
}

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
  private PreparedStatement getLoan;
  private PreparedStatement addCustomer;
  private PreparedStatement addItem;
  private PreparedStatement getCustomerByName;
  private PreparedStatement getCustomerByLateFee;
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
	String getLoanString = "select * from Loan where itemID = ?";
	String addCustomerString = "insert into Customer values"; // might need to edit a little
    String addItemString = "insert into Item values";
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
    				//Customer.CUSTOMER_ID+ ", "+
    				//Customer.FIRST_NAME+ ", "+
    				//Customer.LAST_NAME+
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
	    		
    		
	// TODO: create any new SQL query strings here

    try
    {
      getCustomer = conn.prepareStatement(getCustomerString);
      getLibraries = conn.prepareStatement(getLibrariesString);
	  getLoan = conn.prepareStatement(getLoanString);
	  addCustomer = conn.prepareStatement(addCustomerString);
	  addItem = conn.prepareStatement(addItemString);
	  getCustomerByName = conn.prepareStatement(getCustomerByNameString);
	  getCustomerByLateFee = conn.prepareStatement(getCustomerByLateFeeString);
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
  
   public Loan getLoan(String itemID) 
  {
    try
	{
	  getLoan.setString(1,itemID);
	  ResultSet rs = getLoan.executeQuery();
	  if (rs.next())
	  {
	    Loan loan = new Loan();
		loan.lendingLibrary = rs.getString("lendingLibrary");
		loan.borrowingLibrary = rs.getString("borrowingLibrary");
		loan.dateOut = rs.getDate("dateOut");
		loan.itemID = rs.getString("itemID");
		
		rs.close();
		return loan;
	  }
	  else
	  {
	  
	    rs.close();
		return null;
	  }
	}
	catch(SQLException e)
	{
	System.err.println("Error in getLoan: " + e);
	return null;
	}
  }
  
  public void addCustomer(Customer c) 
  {
    try {
	  Statement s = conn.createStatement();
	  if (c.customerID != null) {
	    s.executeUpdate(addCustomer + "('" + c.customerID + "','"
	                    + c.lastName + "','" + c.firstName + "','"
					    + c.birthDate + "');");
		s.close();
	  }
	  else //primary key doesnt exist
		s.close();
	}
	catch(SQLException e)
	{
	  System.err.println("Error in addCustomer: " + e);
	}    
  }
  public void addMovie(Movie m)
  {
    try {
      Statement s = conn.createStatement();
	  if (m.itemID != null && m.libraryName != null) {
        s.executeUpdate(addItem + "('" + m.itemID + "','" + m.libraryName
					     + "','" + m.mediaType + "','" + m.title 
						 + "','" + m.year + "','" + m.length 
						 + "','" + m.genre + "');");      	
	    s.close();
	  }
	  else //primary key doesnt exist
	    s.close();
    }
	catch(SQLException e)
	{
	  System.err.println("Error in addMovie: " + e);
	}     
  }
  
  public void addBook(Book b)
  {
    try {
      Statement s = conn.createStatement();
	  if (b.itemID != null && b.libraryName != null) {
        s.executeUpdate(addItem + "('" + b.itemID + "','" + b.libraryName
					     + "','" + b.mediaType + "','" + b.author 
						 + "','" + b.title + "','" + b.year + "','" + b.length 
						 + "','" + b.genre + "');");      	
	    s.close();
	  }
	  else //primary key doesnt exist
	    s.close();
    }
	catch(SQLException e)
	{
	  System.err.println("Error in addBook: " + e);
	}     
  }
  
  public void addAudio(Audio a)
  {
    try {
      Statement s = conn.createStatement();
	  if (a.itemID != null && a.libraryName != null) {
        s.executeUpdate(addItem + "('" + a.itemID + "','" + a.libraryName
					     + "','" + a.mediaType + "','" + a.title 
						 + "','" + a.year + "','" + a.length 
						 + "','" + a.genre + "','" + a.artist + "');");      	
	    s.close();
	  }
	  else //primary key doesnt exist
	    s.close();
    }
	catch(SQLException e)
	{
	  System.err.println("Error in addAudio: " + e);
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
		// TODO Auto-generated catch block
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
		// TODO Auto-generated catch block
		e.printStackTrace();
	  }
	  
	  return customers;
  }
  

  // TODO: add any new database query/update helper methods here. Each method
  // should use PreparedStatements declared above. The methods should accept 
  // parameters and return values that use the custom data types, rather than
  // ResultSets.
}

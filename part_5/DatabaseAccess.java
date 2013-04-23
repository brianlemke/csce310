import java.sql.*;
import java.util.ArrayList;

public class DatabaseAccess
{
  private Connection conn;

  public static final String databaseUser     = "csce310";
  public static final String databasePassword = "";
  public static final String databaseName     = "csce310";
  public static final String databaseHost     = "localhost";

  private PreparedStatement getCustomer;
  private PreparedStatement getLibraries;
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
    String getCustomerString = "select * from Customer where customerID = ?";
    String getLibrariesString = "select * from Library order by name";
    // TODO: create any new SQL query strings here

    try
    {
      getCustomer = conn.prepareStatement(getCustomerString);
      getLibraries = conn.prepareStatement(getLibrariesString);
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
    finally
    {
      return libraries;
    }
  }

  // TODO: add any new database query/update helper methods here. Each method
  // should use PreparedStatements declared above. The methods should accept 
  // parameters and return values that use the custom data types, rather than
  // ResultSets.
}

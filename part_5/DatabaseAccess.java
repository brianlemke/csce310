import java.sql.*;

public class DatabaseAccess
{
  private Connection conn;

  public static final String databaseUser     = "csce310";
  public static final String databasePassword = "";
  public static final String databaseName     = "csce310";
  public static final String databaseHost     = "localhost";

  private PreparedStatement getCustomer;

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

    try
    {
      getCustomer = conn.prepareStatement(getCustomerString,
                                          ResultSet.TYPE_SCROLL_INSENSITIVE,
                                          ResultSet.CONCUR_READ_ONLY);
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
}

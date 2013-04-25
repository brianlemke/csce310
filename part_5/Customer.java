import java.sql.Date;

public class Customer
{
  public String customerID;
  public String lastName;
  public String firstName;
  public Date birthDate;
  
  public static final String CUSTOMER = "Customer";
  public static final String CUSTOMER_ID = CUSTOMER+".customerId";
  public static final String LAST_NAME =  CUSTOMER+".lastName";
  public static final String BIRTHDATE =  CUSTOMER+".birthDate";
  public static final String FIRST_NAME =  CUSTOMER+".firstName";
}

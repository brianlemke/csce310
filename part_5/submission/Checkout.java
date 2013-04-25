import java.sql.Date;

public class Checkout
{
  public String libraryName;
  public String customerID;
  public String itemID;
  public double fineAmount;
  public Date dateOut;
  public Date dateDue;
  
  public static final String CHECKOUT = "Checkout";
  public static final String LIBRARY_NAME = CHECKOUT+".libraryName";
  public static final String CUSTOMER_ID = CHECKOUT+".customerId";
  public static final String ITEM_ID = CHECKOUT+".itemId";
  public static final String FINE_AMOUNT = CHECKOUT+".fineAmount";
  public static final String DATE_OUT = CHECKOUT+".dateOut";
  public static final String DATE_DUE = CHECKOUT+".dateDue";
}

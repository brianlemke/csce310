import java.util.Scanner;

public class Main
{
  public static void main(String[] args)
  {
    DatabaseAccess db = new DatabaseAccess();
    db.init();
    
    Scanner sc = new Scanner(System.in);

    System.out.print("Enter customerID: ");
    String customerID = sc.nextLine();

    Customer c = db.getCustomer(customerID);
    if (c == null)
    {
      System.out.println("No customers found with id: " + customerID);
    }
    else
    {
      System.out.println("customerID: " + c.customerID);
      System.out.println("lastName: " + c.lastName);
      System.out.println("firstName: " + c.firstName);
      System.out.println("birthDate: " + c.birthDate.toString());
    }

    db.terminate();
  }
}

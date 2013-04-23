import java.util.ArrayList;
import java.util.Scanner;

public class UserInterface
{
  private DatabaseAccess db;
  private Scanner sc;
  private Library currentLibrary;

  public UserInterface(DatabaseAccess db)
  {
    this.db = db;
    sc = new Scanner(System.in);
    currentLibrary = null;
  }

  public void run()
  {
    selectLibrary();
    while (mainMenu());
  }

  private boolean mainMenu()
  {
    assert(currentLibrary != null);

    String header = "Current library: " + currentLibrary.name;
    ArrayList<String> choices = new ArrayList<String>();
    choices.add("Change current library");
    choices.add("Find a customer");
    choices.add("Find a loan");
    choices.add("Checkout an item");
    choices.add("Add a new item");
    choices.add("Add a new customer");
    choices.add("Pay a fine");
    choices.add("Exit");
    String prompt = "Enter the number of your choice: ";

    System.out.println(header);
    for (int i = 0; i < choices.size(); i++)
    {
      System.out.printf("%2d - %s\n", i + 1, choices.get(i));
    }

    int selection = readSelection(prompt, choices.size());

    switch(selection)
    {
      case 1:
        selectLibrary();
        break;
      case 2:
        searchCustomers();
        break;
      case 3:
        searchLoans();
        break;
      case 4:
        checkoutItem();
        break;
      case 5:
        addItem();
        break;
      case 6:
        addCustomer();
        break;
      case 7:
        payFine();
        break;
      case 8:
        return false; // Indicate the program should terminate
      default:
        assert(false);
    }

    return true; // Indicate that we should show the main menu again
  }

  private void selectLibrary()
  {
    ArrayList<Library> libraries = db.getLibraries();

    System.out.println("These are the available libraries in the system:");
    for (int i = 0; i < libraries.size(); i++)
    {
      System.out.printf("%3d - %s\n", i + 1, libraries.get(i).name);
    }

    String prompt = "Please enter the number of your library: ";
    int libraryIndex = readSelection(prompt, libraries.size());
    currentLibrary = libraries.get(libraryIndex - 1);
  }

  private void searchCustomers()
  {
    // TODO: this is a method stub
  }

  private void searchLoans()
  {
    // TODO: this is a method stub
  }

  private void checkoutItem()
  {
    // TODO: this is a method stub
  }

  private void addItem()
  {
    // TODO: this is a method stub
  }

  private void addCustomer()
  {
    // TODO: this is a method stub
  }

  private void payFine()
  {
    // TODO: this is a method stub
  }


  private int readSelection(String prompt, int maxSelection)
  {
    int selection = -1;
    boolean valid = false;
    System.out.print(prompt);

    while (!valid)
    {
      try
      {
        selection = sc.nextInt();
        if (selection > 0 && selection <= maxSelection)
        {
          valid = true;
        }
        else
        {
          System.out.print("Please enter an integer choice: ");
        }
      }
      catch(Exception e)
      {
        System.out.print("Please enter an integer choice: ");
      }
      finally
      {
        sc.nextLine();
      }
    }

    return selection;
  }
}

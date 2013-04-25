import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.io.Console;
import java.text.SimpleDateFormat;
import java.sql.Date;
import java.util.Locale;

public class UserInterface
{
  private DatabaseAccess db; // handles all database queries
  private Scanner sc;
  private Library currentLibrary;
  Console c = System.console();

  // Initialize the member variables
  public UserInterface(DatabaseAccess db)
  {
    this.db = db;
    sc = new Scanner(System.in);
    currentLibrary = null;
  }

  // Start the main menu loop
  public void run()
  {
    selectLibrary();
    while (mainMenu());
  }

  // Display the main menu and prompt for a selection. Upon a valid selection,
  // pass control to the submenu function
  private boolean mainMenu()
  {
    assert(currentLibrary != null);

    String header = "Current library: " + currentLibrary.name;
    ArrayList<String> choices = new ArrayList<String>();
    choices.add("Change current library");
    choices.add("Find a customer");
    choices.add("Checkout an item");
    choices.add("Add a new item");
    choices.add("Add a new customer");
    choices.add("Remove an employee");
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
        checkoutItem();
        break;
      case 4:
        addItem();
        break;
      case 5:
        addCustomer();
        break;
      case 6:
        removeEmployee();
        break;
      case 7:
        return false; // Indicate the program should terminate
      default:
        // readSelection ensures that the selection index is valid
        assert(false);
    }

    return true; // Indicate that we should show the main menu again
  }

  // Prompt the user to select the currently-used library from a list of all
  // libraries in the system
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

  // Allow the user to search for customers by first name, or to find all
  // customers with high late fees
  private void searchCustomers(){
    assert(currentLibrary != null);

    // Display a small sub-menu
    String header = "Searching " + currentLibrary.name + "for customer";
    ArrayList<String> choices = new ArrayList<String>();
    choices.add("Find By First Name");
    choices.add("Find By Late Fees");
    choices.add("Exit");
    String prompt = "Enter the number of your choice: ";

    System.out.println(header);
    for (int i = 0; i < choices.size(); i++){
      System.out.printf("%2d - %s\n", i + 1, choices.get(i));
    }

    int selection = readSelection(prompt, choices.size());

    switch(selection){
      case 1:
        String name = c.readLine("Enter the First Name: ");
        for(Customer customer : db.findUserByName(name, currentLibrary.name)){
          System.out.println("Customer: ");
          System.out.println("\t First Name: "+customer.firstName);
          System.out.println("\t Last Name: "+customer.lastName);
          System.out.println("\t Birthday: "+customer.birthDate);
          System.out.println("\t ID: "+customer.customerID);
        }
        break;
      case 2:
        String feestring = c.readLine("Enter minimum Late Fee: ");
        float fee = Float.parseFloat(feestring);
        for(String customer : db.findCustomerByLateFee(fee, currentLibrary.name)){
          System.out.println(customer);
        }
        break;
      default:
        break;
    }
  }

  // Allow the user to checkout a specific item to a library customer
  private void checkoutItem()
  {
    java.util.Date today = new java.util.Date();
    java.sql.Date sqlToday = new java.sql.Date(today.getTime());
    Checkout c = new Checkout();
    c.itemID = readID("Enter the 20 character itemID: ");
    c.customerID = readID("Enter the 20 character customerID: ");
    c.libraryName = currentLibrary.name;
    c.dateOut = sqlToday;
    if (db.checkoutItem(c))
    {
      System.out.println("Checkout successful!");
    }
    else
    {
      System.out.println("Oops. There was an error checking out.");
    }	
	
  }

  // Prompt the user to add a new item to the database.
  private void addItem()
  {
    // We must read different fields for different media types
    String prompt = "What type of item is it? \n 1. Book \n 2. Movie \n 3. Audio \n";
    int type = readSelection(prompt, 3);
    switch (type) {
      case 1: 
        addBook();
        break;
      case 2: 
        addMovie();
        break;
      case 3: 
        addAudio();
        break;
      default:
        assert(false);
    }
	
  }

  // Prompt the user to fill out information to add a new customer to the database
  private void addCustomer()
  {
    Customer c = new Customer();
    c.customerID = readID("Enter 20 character customer ID: ");
    System.out.print("Enter customer's last name: ");
    c.lastName = sc.nextLine();
    System.out.print("Enter customer's first name: ");
    c.firstName = sc.nextLine();
    c.birthDate = readDate("Enter customers birth date (e.g. January 13, 2012): ");

    if (db.addCustomer(c))
    {
      System.out.println("Customer successfully added!");
    }
    else
    {
      System.out.println("Oops. There was an error adding the new customer.");
    }
  }

  // Prompt the user to delete an employee from the database
  private void removeEmployee()
  {
	String id = readID("Enter 20 character employeeID to be removed: ");
	 if (db.deleteEmployee(id))
    {
      System.out.println("Employee successfully Deleted!");
    }
    else
    {
      System.out.println("Oops. There was an error deleting the employee.");
    }

  }

  // Prompt the user to fill out information to add a new book to the database
  private void addBook() 
  {
    Book b = new Book();
    b.itemID = readID("Enter 20 character item ID: ");
    b.libraryName = currentLibrary.name;
    b.mediaType = "book";
    System.out.print("Enter the author's full name: ");
    b.author = sc.nextLine();
    System.out.print("Enter the title: ");
    b.title = sc.nextLine();
    b.year = readInt("Enter the year: ", 1902, 2155);
    b.length = readInt("Enter the number of pages: ", 0, -1);
    System.out.print("Enter the genre: ");
    b.genre = sc.nextLine();

    if (db.addBook(b))
    {
      System.out.println("Book successfully added!");
    }
    else
    {
      System.out.println("Oops. There was an error adding the new book.");
    }
  }

  // Prompt the user to fill out information to add a new movie to the database
  private void addMovie()
  {
    Movie m = new Movie();

    m.itemID = readID("Enter 20 character item ID: ");
    m.libraryName = currentLibrary.name;
    m.mediaType = "movie";
    System.out.print("Enter the title: ");
    m.title = sc.nextLine();
    m.year = readInt("Enter the yaer: ", 1902, 2155);
    m.length = readInt("Enter the length in minutes: ", 0, -1);
    System.out.print("Enter the genre: ");
    m.genre = sc.nextLine();

    if (db.addMovie(m))
    {
      System.out.println("Movie successfully added!");
    }
    else
    {
      System.out.println("Oops. There was an error adding the new book.");
    }
  }
  
  // Prompt the user to fill out information to add a new audio item to the database
  private void addAudio()
  {
    Audio a = new Audio();

    a.itemID = readID("Enter 20 character item ID: ");
    a.libraryName = currentLibrary.name;
    a.mediaType = "audio";
    System.out.print("Enter the title: ");
    a.title = sc.nextLine();
    a.year = readInt("Enter the year: ", 1902, 2155);
    a.length = readInt("Enter the length in minutes: ", 0, -1);
    System.out.print("Enter the genre: ");
    a.genre = sc.nextLine();
    System.out.print("Enter the artist's full name: ");
    a.artist = sc.nextLine();

    if (db.addAudio(a))
    {
      System.out.println("Audio successfully added!");
    }
    else
    {
      System.out.println("Oops. There was an error adding the new audio.");
    }
  }

  // Read from standard input until a valid selection index is read, with 1 
  // being the minimum index and maxSelection being the maximum index
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

  // Read from standard input until a valid 20-character ID string is given.
  private String readID(String prompt)
  {
    String id = "";
    boolean valid = false;
    System.out.print(prompt);

    while (!valid)
    {
      id = sc.nextLine();
      if (id.length() == 20)
      {
        valid = true;
      }
      else
      {
        System.out.print("ID must be 20 characters: ");
      }
    }

    return id;
  }

  // Read from standard input until a valid date is given
  private java.sql.Date readDate(String prompt)
  {
    SimpleDateFormat parser = new SimpleDateFormat("MMMM d, yyyy", Locale.ENGLISH);

    boolean valid = false;
    java.util.Date date = null;
    System.out.print(prompt);

    while (!valid)
    {
      String entry = sc.nextLine();
      try
      {
        date = parser.parse(entry);
        valid = true;
      }
      catch(Exception e)
      {
        System.out.print("Date must be like January 13, 2012: ");
      }
    }

    return new java.sql.Date(date.getTime());
  }

  // Read from standard input until a valid integer with a range is given
  private int readInt(String prompt, int min, int max)
  {
    int result = -1;

    boolean valid = false;
    System.out.print(prompt);

    while (!valid)
    {
      try
      {
        result = sc.nextInt();
        sc.nextLine();
        if (min >= 0 && result < min)
        {
          System.out.print("Integer must be greater than " + min + ": ");
        }
        else if (max >= 8 && result > max)
        {
          System.out.print("Integer must be less than " + max + ": ");
        }
        else
        {
          valid = true;
        }
      }
      catch(Exception e)
      {
        System.out.print("Please enter an integer: ");
        sc.nextLine();
      }
    }

    return result;
  }
}

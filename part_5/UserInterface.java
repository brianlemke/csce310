import java.util.ArrayList;
import java.util.Scanner;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Date;

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
    String prompt = "What type of item is it? \n 1. Book \n 2. Movie \n 3. Audio \n";
	int type = readSelection(prompt, 3);
	switch (type) {
	  case 1: 
			  Book b = new Book(); 
			  b = bookPrompt(b);
			  db.addBook(b);
			  break;
	  case 2: 
			  Movie m = new Movie();
	          m = moviePrompt(m);
			  db.addMovie(m);
	          break;
	  case 3: 
			  Audio a = new Audio();  
	          a = audioPrompt(a);
			  db.addAudio(a);
	          break;
	}
	
  }

  private void addCustomer()
  {
    Customer c = new Customer();
    System.out.println("Customer(customerID,lastName,firstName,birthDate)");
	System.out.println("20 character customer ID");
	c.customerID = sc.next();
	System.out.println("Customer's last name?");
	c.lastName = sc.next();
	System.out.println("Customer's first name?");
	c.firstName = sc.next();
	System.out.println("Customer's date of birth?");
	String str = sc.nextLine();	
	try 
	{
	  Date date = new SimpleDateFormat("MMMM d, yyyy", Locale.ENGLISH).parse(str);
	  c.birthDate = date;
	  
	}
	catch(java.text.ParseException e) 
	{
	  System.err.println("Unable to parse date, exception: ");
	}
	db.addCustomer(c);
	
  }

  private void payFine()
  {
    // TODO: this is a method stub
  }
  
  private Book bookPrompt(Book b) 
  {
     System.out.println("Book(itemID,libraryName,mediaType,author,title,year,length,genre)");
     System.out.println("itemID: ");
	 b.itemID = sc.next();
	 System.out.println("libraryName: ");
	 b.libraryName = sc.next();
	 b.mediaType = "book";
	 System.out.println("author: ");
	 b.author = sc.next();
	 System.out.println("title: ");
	 b.title = sc.next();
	 System.out.println("year: ");
	 b.year = sc.nextInt();
	 System.out.println("length: ");
	 b.length = sc.nextInt();
	 System.out.println("genre: ");
	 b.genre = sc.next();
	 return b;
  }

  private Movie moviePrompt(Movie m)
  {

	System.out.println("Movie(itemID,libraryName,mediaType,title,year,length,genre)");
	System.out.println("itemID: ");
	m.itemID = sc.next();
	System.out.println("libraryName: ");
	m.libraryName = sc.next();
	m.mediaType = "movie";
	System.out.println("title: ");
	m.title = sc.next();
	System.out.println("year: ");
	m.year = sc.nextInt();
	System.out.println("length: ");
	m.length = sc.nextInt();
	System.out.println("genre: ");
	m.genre = sc.next();
	return m;
  }
  
  private Audio audioPrompt(Audio a)
  {
    System.out.println("Audio(itemID,libraryName,mediaType,title,year,length,genre,artist)");
    System.out.println("itemID: ");
	a.itemID = sc.next();
	System.out.println("libraryName: ");
	a.libraryName = sc.next();
	a.mediaType = "audio";
	System.out.println("title: ");
	a.title = sc.next();
	System.out.println("year: ");
	a.year = sc.nextInt();
	System.out.println("length: ");
	a.length = sc.nextInt();
	System.out.println("genre: ");
	a.genre = sc.next();
	System.out.println("artist: ");
	a.artist = sc.next();
	return a;
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

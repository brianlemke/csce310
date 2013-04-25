public class Main
{
  // Establish the database connection and invoke the user interface
  public static void main(String[] args)
  {
    DatabaseAccess db = new DatabaseAccess();
    db.init();
    
    UserInterface ui = new UserInterface(db);
    ui.run();

    db.terminate();
  }
}

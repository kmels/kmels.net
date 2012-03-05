//********************************************************************
//  PhoneList2.java       Author: Lewis/Loftus
//
//  Driver for testing searching algorithms.
//********************************************************************

public class PhoneList2
{
   //-----------------------------------------------------------------
   //  Creates an array of Contact objects, sorts them, then prints
   //  them.
   //-----------------------------------------------------------------
   public static void main (String[] args)
   {
      Contact test, found;
      Contact[] friends = new Contact[8];

      friends[0] = new Contact ("John", "Smith", "610-555-7384");
      friends[1] = new Contact ("Sarah", "Barnes", "215-555-3827");
      friends[2] = new Contact ("Mark", "Riley", "733-555-2969");
      friends[3] = new Contact ("Laura", "Getz", "663-555-3984");
      friends[4] = new Contact ("Larry", "Smith", "464-555-3489");
      friends[5] = new Contact ("Frank", "Phelps", "322-555-2284");
      friends[6] = new Contact ("Mario", "Guzman", "804-555-9066");
      friends[7] = new Contact ("Marsha", "Grant", "243-555-2837");

      test = new Contact ("Frank", "Phelps", "");
      found = (Contact) Searching.linearSearch(friends, test);
      if (found != null)
         System.out.println ("Found: " + found);
      else
         System.out.println ("The contact was not found.");
      System.out.println ();

      Sorting.selectionSort(friends);

      test = new Contact ("Mario", "Guzman", "");
      found = (Contact) Searching.binarySearch(friends, test);
      if (found != null)
         System.out.println ("Found: " + found);
      else
         System.out.println ("The contact was not found.");
   }
}

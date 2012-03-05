import java.util.Vector;
import java.util.Enumeration;

public class Enumeracion {

   public static void main(String args[])
   {
     // construct a vector containing two strings:
     Vector<String> v = new Vector<String>();

     v.add("Hello");
     v.add("world!");
   
     // construct an enumeration to view values of v
     Enumeration i = (Enumeration)v.elements();

     while (i.hasMoreElements())
     {
        // SILLY: v.add(1,"silly");
        System.out.print(i.nextElement()+" "); 
     }
     System.out.println();
   }

}
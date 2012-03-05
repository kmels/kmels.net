import java.util.Vector;


public class Iteracion {

   public static void main(String args[])
   {
     // construct a vector containing two strings:
     Vector<String> v = new Vector<String>();

     v.add("Hello");
     v.add("world!");
   
     VectorIterator i = new VectorIterator(v); 

     // construct an iterator to view values of v
     while (i.hasNext())
     {
        System.out.print(i.next()+" ");
     }     

     System.out.println();
   }

}
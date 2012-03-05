

import java.util.*;

/*
This Java comparator example compares employees on the basis of 
their age and name and sort it in that order.
*/

public class JavaComparatorExample{

    public static void main(String args[]){
    /*
        Employee array which will hold employees
    */

    Employee employee[] = new Employee[2];

   //set different attributes of the individual employee.
   employee[0] = new Employee();
   employee[0].setAge(40);
   employee[0].setName("Joe");
   employee[1] = new Employee();
   employee[1].setAge(20);
   employee[1].setName("Mark");

   System.out.println("Order of employee before sorting is");

   //print array as is.
   for(int i=0; i < employee.length; i++){
      System.out.println( "Employee " + (i+1) + " name :: " + employee[i].getName() + ", Age :: " + employee[i].getAge());
   }

   /*
   Sort method of the Arrays class sorts the given array.
   Signature of the sort method is,
   static void sort(Object[] object, Comparator comparator)
 
   IMPORTANT: All methods defined by Arrays class are static. Arrays class
   serve as a utility class.

   */


   /*
   Sorting array on the basis of employee age by passing AgeComparator
   */

   Arrays.sort(employee, new AgeComparator());
   System.out.println("\n\nOrder of employee after sorting by employee age is");
   for(int i=0; i < employee.length; i++){
       System.out.println( "Employee " + (i+1) + " name :: " + employee[i].getName() + ", Age :: " + employee[i].getAge());
   }


   /*
   Sorting array on the basis of employee Name by passing NameComparator
   */
   Arrays.sort(employee, new NameComparator());
   System.out.println("\n\nOrder of employee after sorting by employee name is");      
   for(int i=0; i < employee.length; i++){
       System.out.println( "Employee " + (i+1) + " name :: " + employee[i].getName() + ", Age :: " + employee[i].getAge());
   }

 }

}


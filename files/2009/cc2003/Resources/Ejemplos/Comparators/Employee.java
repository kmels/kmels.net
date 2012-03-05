/*
Java Comparator example. 
This Java Comparator example describes how java.util.Comparator interface is implemented 
to compare Java user defined classe's objects.
These Java Comparator is passed to Collection's sorting method 
( for example Collections.sort method)to perform sorting of Java user defined classe's objects.
*/

import java.util.*;

/*

java.util.Comparator interface declares two methods,
1) public int compare(Object object1, Object object2) and
2) boolean equals(Object object)
*/

/*
We will compare objects of the Employee class using custom comparators
on the basis of employee age and name.
*/

class Employee{
      private int age;
      private String name;
      
      public void setAge(int age){        
             this.age=age;
      }

      public int getAge(){          
             return this.age;
      }

      public void setName(String name){         
             this.name=name;
      }

      public String getName(){
             return this.name;
      }     

}


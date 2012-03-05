

import java.util.*;

/*

java.util.Comparator interface declares two methods,
1) public int compare(Object object1, Object object2) and
2) boolean equals(Object object)
*/

/*
User defined java comaprator.
To create custom java comparator Implement Comparator interface and
define compare method.
The below given comparator compares employees on the basis of their age.
*/

class AgeComparator implements Comparator{

      public int compare(Object emp1, Object emp2){
         //parameter are of type Object, so we have to downcast it to Employee objects
         int emp1Age = ( (Employee) emp1).getAge();
         int emp2Age = ( (Employee) emp2).getAge();
         if( emp1Age > emp2Age )
             return 1;
         else if( emp1Age < emp2Age )
             return -1;
         else
             return 0;
      }

}

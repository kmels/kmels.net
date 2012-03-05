//********************************************************************
//  SeasonTester.java       Author: Lewis/Loftus
//
//  Demonstrates the use of a full enumerated type.
//********************************************************************

public class SeasonTester
{
   //-----------------------------------------------------------------
   //  Iterates through the values of the Season enumerated type.
   //-----------------------------------------------------------------
   public static void main (String[] args)
   {
      for (Season time : Season.values())
         System.out.println (time + "\t" + time.getSpan());
   }
}

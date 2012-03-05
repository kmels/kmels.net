//********************************************************************
//  Season.java       Author: Lewis/Loftus
//
//  Enumerates the values for Season.
//********************************************************************

public enum Season
{
   winter ("December through February"),
   spring ("March through May"),
   summer ("June through August"),
   fall ("September through November");

   private String span;

   //-----------------------------------------------------------------
   //  Constructor: Sets up each value with an associated string.
   //-----------------------------------------------------------------
   Season (String months)
   {
      span = months;
   }

   //-----------------------------------------------------------------
   //  Returns the span message for this value.
   //-----------------------------------------------------------------
   public String getSpan()
   {
      return span;
   }
}

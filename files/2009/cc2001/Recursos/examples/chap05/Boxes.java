//********************************************************************
//  Boxes.java       Author: Lewis/Loftus
//
//  Demonstrates the use of loops to draw.
//********************************************************************

import javax.swing.JFrame;

public class Boxes
{
   //-----------------------------------------------------------------
   //  Creates the main frame of the program.
   //-----------------------------------------------------------------
   public static void main (String[] args)
   {
      JFrame frame = new JFrame ("Boxes");
      frame.setDefaultCloseOperation (JFrame.EXIT_ON_CLOSE);

      BoxesPanel panel = new BoxesPanel();

      frame.getContentPane().add(panel);
      frame.pack();
      frame.setVisible(true);
   }
}

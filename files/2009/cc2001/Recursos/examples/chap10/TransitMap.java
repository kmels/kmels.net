//********************************************************************
//  TransitMap.java       Authors: Lewis/Loftus
//
//  Demonstrates the use a scroll pane.
//********************************************************************

import java.awt.*;
import javax.swing.*;

public class TransitMap
{
   //-----------------------------------------------------------------
   //  Presents a frame containing a scroll pane used to view a large
   //  map of the Philadelphia subway system.
   //-----------------------------------------------------------------
   public static void main (String[] args)
   {
      // SEPTA = SouthEast Pennsylvania Transit Authority
      JFrame frame = new JFrame ("SEPTA Transit Map");

      frame.setDefaultCloseOperation (JFrame.EXIT_ON_CLOSE);

      ImageIcon image = new ImageIcon ("septa.jpg");
      JLabel imageLabel = new JLabel (image);

      JScrollPane sp = new JScrollPane (imageLabel);
      sp.setPreferredSize (new Dimension (450, 400));

      frame.getContentPane().add (sp);
      frame.pack();
      frame.setVisible(true);
   }
}

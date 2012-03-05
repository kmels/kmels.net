//********************************************************************
//  PickImage.java       Authors: Lewis/Loftus
//
//  Demonstrates the use a split pane and a list.
//********************************************************************

import java.awt.*;
import javax.swing.*;

public class PickImage
{
   //-----------------------------------------------------------------
   //  Creates and displays a frame containing a split pane. The
   //  user selects an image name from the list to be displayed.
   //-----------------------------------------------------------------
   public static void main (String[] args)
   {
      JFrame frame = new JFrame ("Pick Image");
      frame.setDefaultCloseOperation (JFrame.EXIT_ON_CLOSE);

      JLabel imageLabel = new JLabel();
      JPanel imagePanel = new JPanel();
      imagePanel.add (imageLabel);
      imagePanel.setBackground (Color.white);

      ListPanel imageList = new ListPanel (imageLabel);

      JSplitPane sp = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT,
                                     imageList, imagePanel);

      sp.setOneTouchExpandable (true);

      frame.getContentPane().add (sp);
      frame.pack();
      frame.setVisible(true);
   }
}

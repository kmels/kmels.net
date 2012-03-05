//********************************************************************
//  LeftRightPanel.java       Authors: Lewis/Loftus
//
//  Demonstrates the use of one listener for multiple buttons.
//********************************************************************

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class LeftRightPanel extends JPanel
{
   private JButton left, right;
   private JLabel label;
   private JPanel buttonPanel;

   //-----------------------------------------------------------------
   //  Constructor: Sets up the GUI.
   //-----------------------------------------------------------------
   public LeftRightPanel ()
   {
      left = new JButton ("Left");
      right = new JButton ("Right");

      ButtonListener listener = new ButtonListener();
      left.addActionListener (listener);
      right.addActionListener (listener);

      label = new JLabel ("Push a button");

      buttonPanel = new JPanel();
      buttonPanel.setPreferredSize (new Dimension(200, 40));
      buttonPanel.setBackground (Color.blue);
      buttonPanel.add (left);
      buttonPanel.add (right);

      setPreferredSize (new Dimension(200, 80));
      setBackground (Color.cyan);
      add (label);
      add (buttonPanel);
   }

   //*****************************************************************
   //  Represents a listener for both buttons.
   //*****************************************************************
   private class ButtonListener implements ActionListener
   {
      //--------------------------------------------------------------
      //  Determines which button was pressed and sets the label
      //  text accordingly.
      //--------------------------------------------------------------
      public void actionPerformed (ActionEvent event)
      {
         if (event.getSource() == left)
            label.setText("Left");
         else
            label.setText("Right");
      }
   }
}

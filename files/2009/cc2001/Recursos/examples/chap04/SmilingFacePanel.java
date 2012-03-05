//********************************************************************
//  SmilingFacePanel.java       Author: Lewis/Loftus
//
//  Demonstrates the use of a separate panel class.
//********************************************************************

import javax.swing.JPanel;
import java.awt.*;

public class SmilingFacePanel extends JPanel
{
   private final int BASEX = 120, BASEY = 60; // base point for head

   //-----------------------------------------------------------------
   //  Constructor: Sets up the main characteristics of this panel.
   //-----------------------------------------------------------------
   public SmilingFacePanel ()
   {
      setBackground (Color.blue);
      setPreferredSize (new Dimension(320, 200));
      setFont (new Font("Arial", Font.BOLD, 16));
   }

   //-----------------------------------------------------------------
   //  Draws a face.
   //-----------------------------------------------------------------
   public void paintComponent (Graphics page)
   {
      super.paintComponent (page);

      page.setColor (Color.yellow);
      page.fillOval (BASEX, BASEY, 80, 80);  // head
      page.fillOval (BASEX-5, BASEY+20, 90, 40);  // ears

      page.setColor (Color.black);
      page.drawOval (BASEX+20, BASEY+30, 15, 7);  // eyes
      page.drawOval (BASEX+45, BASEY+30, 15, 7);

      page.fillOval (BASEX+25, BASEY+31, 5, 5);   // pupils
      page.fillOval (BASEX+50, BASEY+31, 5, 5);

      page.drawArc (BASEX+20, BASEY+25, 15, 7, 0, 180);  // eyebrows
      page.drawArc (BASEX+45, BASEY+25, 15, 7, 0, 180);

      page.drawArc (BASEX+35, BASEY+40, 15, 10, 180, 180);  // nose
      page.drawArc (BASEX+20, BASEY+50, 40, 15, 180, 180);  // mouth

      page.setColor (Color.white);
      page.drawString ("Always remember that you are unique!",
                       BASEX-105, BASEY-15);
      page.drawString ("Just like everyone else.", BASEX-45, BASEY+105);
   }
}

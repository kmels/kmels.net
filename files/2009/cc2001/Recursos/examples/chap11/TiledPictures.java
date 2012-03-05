//********************************************************************
//  TiledPictures.java       Author: Lewis/Loftus
//
//  Demonstrates the use of recursion.
//********************************************************************

import java.awt.*;
import javax.swing.JApplet;

public class TiledPictures extends JApplet
{
   private final int APPLET_WIDTH = 320;
   private final int APPLET_HEIGHT = 320;
   private final int MIN = 20;  // smallest picture size

   private Image world, everest, goat;

   //-----------------------------------------------------------------
   //  Loads the images.
   //-----------------------------------------------------------------
   public void init()
   {
      world = getImage (getDocumentBase(), "world.gif");
      everest = getImage (getDocumentBase(), "everest.gif");
      goat = getImage (getDocumentBase(), "goat.gif");

      setSize (APPLET_WIDTH, APPLET_HEIGHT);
   }

   //-----------------------------------------------------------------
   //  Draws the three images, then calls itself recursively.
   //-----------------------------------------------------------------
   public void drawPictures (int size, Graphics page)
   {
      page.drawImage (everest, 0, size/2, size/2, size/2, this);
      page.drawImage (goat, size/2, 0, size/2, size/2, this);
      page.drawImage (world, size/2, size/2, size/2, size/2, this);

      if (size > MIN)
         drawPictures (size/2, page);
   }

   //-----------------------------------------------------------------
   //  Performs the initial call to the drawPictures method.
   //-----------------------------------------------------------------
   public void paint (Graphics page)
   {
      drawPictures (APPLET_WIDTH, page);
   }
}

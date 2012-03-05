/******************************************
Universidad del Valle de Guatemala
Ecuaciones Diferenciales
Proyecto No.1: Animación de un sistema
 * masa-resorte con amirtiguamiento
Autores:
 * Martín Guzmán
 * Carlos López
Última fecha de modificación: 06 de noviembre de 2009
Descripción:
*******************************************/

import java.applet.Applet;
import java.awt.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JApplet;
import java.awt.event.*;    // para el MouseListener
import java.util.Timer;
import javax.swing.*;

public class Oscilator extends JApplet implements Runnable // implements MouseListener, MouseMotionListener//, ActionListener
{
   private final int APPLET_WIDTH = 1000;
   private final int APPLET_HEIGHT = 600;
   private final int Tam_inicial_resorte = 174;
   private final int retardo = 50;
   private final int y_grafica_inicial=300;
   private final int x_grafica_inicial=500;

   private Image dbImage;
   private Graphics dbg;
   //private Timer timer_animacion;
   
   // *** Variables de imágenes *********************
   private Image Gancho_abajo, Gancho_arriba, Masa, Techo, Resorte, limpiar_parte, eje_x, eje_y;
   private boolean pintado=true;
   private boolean uno= true;
   private int cant=0;
   // ***********************************************
   
   // *** Para los elementos de swing **************
   private JSlider Slider_masa;
   private JSlider Slider_amortiguamiento;
   private JSlider Slider_pos_inicial;
   private JSlider Slider_resorte;
   private JSlider Slider_vel_inicial;
   private JLabel txt_label_amortiguamiento;
   private JLabel txt_label_const_resorte;
   private JLabel txt_label_masa;
   private JLabel txt_label_pos_inicial;
   private JLabel txt_label_vel_inicial;
   private JLabel Boton_animate;
   private JLabel Boton_stop_animate;
   
   // ***********************************************

   // *** Variables par ala animación ***************
   // Define your thread.
   private Thread clockThread;
   // This variable will remain true for as long
   // we want the thread to run.
   private boolean running = false;
   private SistemaLibreAmortiguado sistema;
   private float m,k,b,y_0,v_0;
   private float tiempo;
   private float x_grafica, y_grafica;
   private boolean visualizacion;
   // ***********************************************

   // *** Variables para posición de pintado ********
   private int Largo_Resorte = Tam_inicial_resorte;
   // ***********************************************

   // *** nombres de las imágenes *******************
   private String URL_Animar1="Recursos/Animar1.png";
   private String URL_Animar2="Recursos/Animar2.png";
   private String URL_Stop1="Recursos/Stop1.png";
   private String URL_Stop2="Recursos/Stop2.png";
   private String URL_GanchoAbajo="Recursos/Gancho_abajo_1.png";
   private String URL_GanchoArriba="Recursos/Gancho_arriba_1.png";
   private String URL_Techo="Recursos/techo.png";
   private String URL_Masa="Recursos/masa2.png";
   private String URL_Resorte="Recursos/resorte_1.png";
   // ***********************************************

   //-----------------------------------------------------------------
   //  Método para inicializar las imágenes.
   //-----------------------------------------------------------------
   public void init()
   {       
       //;=================================================================
       pintado=true;
       Gancho_abajo = getImage (getDocumentBase(), URL_GanchoAbajo);
       Gancho_arriba = getImage (getDocumentBase(), URL_GanchoArriba);
       Masa = getImage (getDocumentBase(), URL_Masa);
       Techo = getImage (getDocumentBase(), URL_Techo);
       Resorte = getImage (getDocumentBase(), URL_Resorte);
       limpiar_parte = getImage(getDocumentBase(), "Recursos/cuadrito_limpiar.png");
       eje_x =  getImage(getDocumentBase(), "Recursos/flecha_derecha.png");
       eje_y =  getImage(getDocumentBase(), "Recursos/flecha_arriba.png");
       
       ColocarSwings();
        try {
            this.tiempo = 0;
            this.pintado = true;
            this.x_grafica=x_grafica_inicial;
            this.m = this.Slider_masa.getValue();
            this.b = this.Slider_amortiguamiento.getValue();
            this.k = this.Slider_resorte.getValue();
            this.y_0 = this.Slider_pos_inicial.getValue();
            this.v_0 = this.Slider_vel_inicial.getValue();

            sistema = new SistemaLibreAmortiguado((float) m, (float) b, (float) k, (float) y_0, (float) v_0);
        } catch (Exception ex) {
            Logger.getLogger(Oscilator.class.getName()).log(Level.SEVERE, null, ex);
        }
       
       this.setSize (APPLET_WIDTH, APPLET_HEIGHT);
       //repaint();
   }


    public void update(Graphics g) {
        // Inicializa el buffer
        if (dbImage == null) {
            dbImage = createImage(this.getSize().width, this.getSize().height);
            dbg = dbImage.getGraphics();
        }

        //borra la pantalla del fondo
        dbg.setColor(getBackground());
        dbg.fillRect(0, 0, this.getSize().width, this.getSize().height);

        //dibuja los elementos en el fondo
        dbg.setColor(getForeground());
        paint(dbg);

        //dibuja la imagen en la pantalla
        g.drawImage(dbImage, 0, 0, this);
    }

   //-----------------------------------------------------------------
   //  Dibuja las imágenes.
   //-----------------------------------------------------------------
   public void drawPictures (Graphics page)
   {
       
       this.Boton_animate.repaint();
       this.Boton_stop_animate.repaint();
       this.Slider_masa.repaint();
       this.Slider_amortiguamiento.repaint();
       this.Slider_pos_inicial.repaint();
       this.Slider_resorte.repaint();
       this.Slider_vel_inicial.repaint();
       this.txt_label_amortiguamiento.repaint();
       this.txt_label_const_resorte.repaint();
       this.txt_label_masa.repaint();
       this.txt_label_pos_inicial.repaint();
       this.txt_label_vel_inicial.repaint();

       
       if (pintado == true || cant<10){
           //page.drawImage(limpiar_parte, 250+80, 15, 45, 93, this);//borra el área del gancho de arriba
           page.drawImage(limpiar_parte, 150+2, 2, 800, 45, this);//borra el área del techo
           page.drawImage(limpiar_parte, x_grafica_inicial, 49, 410, 500,this);//borra el área de la grafica

           page.drawImage (Gancho_arriba, 250+76, 15, 45, 93, this);
           page.drawImage (Techo, 150+2, 2, 800, 45, this);
           page.drawImage(limpiar_parte, x_grafica_inicial-50, 49, 550, 15,this);//borra el área de la grafica
           //page.drawString(sistema.getFuncion(), x_grafica_inicial-50, 59);

           // dibujar ejes
           page.drawImage(limpiar_parte, x_grafica_inicial-12, 70, 30, 400, this);
           page.drawImage(limpiar_parte, x_grafica_inicial-30, y_grafica_inicial-14, 510, 30, this);
           page.drawImage (eje_y, x_grafica_inicial-12, 70, 30, 400, this);
           page.drawImage (eje_x, x_grafica_inicial-30, y_grafica_inicial-14, 510, 30, this);
           pintado = false;
           cant++;

       }
       if(uno == true){
           page.drawString("hola", 0, 0);
           
       }
       //page.drawImage(limpiar_parte, 250+65, 108, 68, (108+450),this);//borra el área de la masa

       page.drawImage (Resorte, 250+65, 108, 68, Largo_Resorte, this);
       page.drawImage (Gancho_abajo, 250+65, (108+Largo_Resorte), 68, 73, this);
       page.drawImage (Masa, 250+65, (108+Largo_Resorte+73), 68, 200, this);

       if(x_grafica>=900){
           //page.drawString("hola", 10, 10);
           x_grafica=x_grafica_inicial;
           page.drawImage(limpiar_parte, x_grafica_inicial, 70, 410, 500,this);//borra el área de la grafica
           page.drawImage(limpiar_parte, x_grafica_inicial-50, 49, 550, 15,this);//borra el área de la grafica
           
           // dibujar ejes
           page.drawImage(limpiar_parte, x_grafica_inicial-12, 70, 30, 400, this);
           page.drawImage(limpiar_parte, x_grafica_inicial-30, y_grafica_inicial-14, 510, 30, this);
           //page.drawImage (eje_y, x_grafica_inicial-16, 70, 30, 400, this);
           page.drawImage (eje_x, x_grafica_inicial-30, y_grafica_inicial-14, 510, 30, this);
           page.drawString("t",x_grafica_inicial-30+460, y_grafica_inicial-14+32);
       }

       page.drawLine((int)x_grafica, (int)y_grafica, (int)x_grafica+1, (int)y_grafica+1);
       page.drawLine((int)x_grafica, (int)y_grafica+1, (int)x_grafica+1, (int)y_grafica);
       //page.drawString("pintado"+pintado, 200, 200);
       //page.drawString("pos2", x_cursor, y_cursor);
       page.drawString(sistema.getFuncion(), x_grafica_inicial-50, 59);
       page.drawString("y(t)", x_grafica_inicial-12+32, 90);
           page.drawString("t",x_grafica_inicial-30+460, y_grafica_inicial-14+32);
   }

   //-----------------------------------------------------------------
   //  Performs the initial call to the drawPictures method.
   //-----------------------------------------------------------------
   public void paint (Graphics page){
       drawPictures (page);
   }

    private void EmpezarAnimacion() throws Exception {
        //repaint();
        this.tiempo = 0;
        this.pintado = true;
        this.x_grafica=x_grafica_inicial;
        this.m = this.Slider_masa.getValue();
        this.b = this.Slider_amortiguamiento.getValue();
        this.k = this.Slider_resorte.getValue();
        this.y_0 = this.Slider_pos_inicial.getValue();
        this.v_0 = this.Slider_vel_inicial.getValue();

        this.sistema = new SistemaLibreAmortiguado((float)m,(float)b,(float)k,(float)y_0,(float)v_0);
        uno=false;
        // Create the thread.
        clockThread= new Thread(this);
        // and let it start running
        clockThread.start();
        running = true;
    }

    //-----------------------------------------------------------------
    //  Método para inicializar todos los Sliders
    //-----------------------------------------------------------------
    public void InicializarSliders(){
        //*************************************
        Slider_masa = new JSlider();
        Slider_masa.setBackground(new java.awt.Color(254, 254, 254));
        Slider_masa.setMaximum(10);
        Slider_masa.setMinimum(1);
        Slider_masa.setMinorTickSpacing(1);
        Slider_masa.setPaintLabels(true);
        Slider_masa.setPaintTicks(true);
        Slider_masa.setValue(5);
        Slider_masa.addChangeListener(new javax.swing.event.ChangeListener() {
           public void stateChanged(javax.swing.event.ChangeEvent evt) {
               SliderListener(evt);
           }
       });
        //*************************************
        //*************************************
        Slider_amortiguamiento = new JSlider();
        Slider_amortiguamiento.setBackground(new java.awt.Color(254, 254, 254));
        Slider_amortiguamiento.setMaximum(6);
        Slider_amortiguamiento.setMinimum(0);
        Slider_amortiguamiento.setMinorTickSpacing(1);
        Slider_amortiguamiento.setPaintLabels(true);
        Slider_amortiguamiento.setPaintTicks(true);
        Slider_amortiguamiento.setValue(3);
        Slider_amortiguamiento.addChangeListener(new javax.swing.event.ChangeListener() {
           public void stateChanged(javax.swing.event.ChangeEvent evt) {
               SliderListener(evt);
           }
       });
        //*************************************
        //*************************************
        Slider_pos_inicial = new JSlider();
        Slider_pos_inicial.setBackground(new java.awt.Color(254, 254, 254));
        Slider_pos_inicial.setMaximum(4);
        Slider_pos_inicial.setMinimum(-4);
        Slider_pos_inicial.setMinorTickSpacing(1);
        Slider_pos_inicial.setPaintLabels(true);
        Slider_pos_inicial.setPaintTicks(true);
        Slider_pos_inicial.setValue(0);
        Slider_pos_inicial.addChangeListener(new javax.swing.event.ChangeListener() {
           public void stateChanged(javax.swing.event.ChangeEvent evt) {
               SliderListener(evt);
           }
       });
        //*************************************
        //*************************************
        Slider_resorte = new JSlider();
        Slider_resorte.setBackground(new java.awt.Color(254, 254, 254));
        Slider_resorte.setMaximum(10);
        Slider_resorte.setMinimum(1);
        Slider_resorte.setMinorTickSpacing(1);
        Slider_resorte.setPaintLabels(true);
        Slider_resorte.setPaintTicks(true);
        Slider_resorte.setValue(5);
        Slider_resorte.addChangeListener(new javax.swing.event.ChangeListener() {
           public void stateChanged(javax.swing.event.ChangeEvent evt) {
               SliderListener(evt);
           }
       });
        //*************************************
        //*************************************
        Slider_vel_inicial = new JSlider();
        Slider_vel_inicial.setBackground(new java.awt.Color(254, 254, 254));
        Slider_vel_inicial.setMaximum(4);
        Slider_vel_inicial.setMinimum(-4);
        Slider_vel_inicial.setMinorTickSpacing(1);
        Slider_vel_inicial.setPaintLabels(true);
        Slider_vel_inicial.setPaintTicks(true);
        Slider_vel_inicial.setValue(0);
        Slider_vel_inicial.addChangeListener(new javax.swing.event.ChangeListener() {
           public void stateChanged(javax.swing.event.ChangeEvent evt) {
               SliderListener(evt);
           }
       });
        //*************************************
    }

    //-----------------------------------------------------------------
    //  Método para colocar todas las cosas importadas de Swing
    //-----------------------------------------------------------------
    public void ColocarSwings(){
               // Tell the applet not to use a layout manager.
       setLayout(null);
       //*************************************
       Boton_animate = new JLabel();

       Boton_animate.setBackground(new java.awt.Color(254, 254, 254));

       Boton_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Animar1.png"))); // NOI18N
       Boton_animate.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                try {
                    Boton_animateMouseClicked(evt);
                } catch (Exception ex) {
                    Logger.getLogger(Oscilator.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                Boton_animateMouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                Boton_animateMouseExited(evt);
            }
        });
       //*************************************
       //*************************************
       Boton_stop_animate = new JLabel();
       Boton_stop_animate.setBackground(new java.awt.Color(254, 254, 254));
       Boton_stop_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Stop1.png"))); // NOI18N
       Boton_stop_animate.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                Boton_stop_animateMouseClicked(evt);
            }
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                Boton_stop_animateMouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                Boton_stop_animateMouseExited(evt);
            }
        });
        //*************************************
        //*************************************
        InicializarSliders(); //inicializar todos los Sliders
        //*************************************
        txt_label_masa = new JLabel("m="+Slider_masa.getValue()+" kg");
        txt_label_amortiguamiento = new JLabel("b="+Slider_amortiguamiento.getValue()+" kg/s");
        txt_label_const_resorte = new JLabel("k="+Slider_resorte.getValue()+" N/m");
        txt_label_pos_inicial = new JLabel("y(0)="+Slider_pos_inicial.getValue()+" m");
        txt_label_vel_inicial = new JLabel("y'(0)="+Slider_vel_inicial.getValue()+" m/s");
        //*************************************

       // *** calculo de los Bounds ********************************************
       Boton_animate.setBounds(5,52, 137, 92);
       Boton_stop_animate.setBounds(142,52, 99, 92);

       Slider_masa.setBounds(20,-50+189+35,130,30);
       Slider_amortiguamiento.setBounds(20,-50+224+40+35,130,30);
       Slider_resorte.setBounds(20,-50+224+50+35+40+35,130,30);
       Slider_pos_inicial.setBounds(20,-50+224+40+35+40+35+40+35,130,30);
       Slider_vel_inicial.setBounds(20,-50+224+40+35+40+35+40+35+40+35,130,30);

       txt_label_masa.setBounds(15,-50+189,100,30); //234=92*2+5
       txt_label_amortiguamiento.setBounds(15,-50+224+40,100,30);
       txt_label_const_resorte.setBounds(15,-50+224+40+35+40,100,30);
       txt_label_pos_inicial.setBounds(15,-50+224+40+35+40+35+40,100,30);
       txt_label_vel_inicial.setBounds(15,-50+224+40+35+40+35+40+35+40,100,30);
       // **********************************************************************
       Boton_stop_animate.setEnabled(false);
       // *** agregar al applet ************************************************
       add(Boton_animate);
       add(Boton_stop_animate);

       add(Slider_masa);
       add(Slider_amortiguamiento);
       add(Slider_pos_inicial);
       add(Slider_vel_inicial);
       add(Slider_resorte);
       add(txt_label_masa);
       add(txt_label_amortiguamiento);
       add(txt_label_const_resorte);
       add(txt_label_pos_inicial);
       add(txt_label_vel_inicial);
       
       // **********************************************************************
    }



    private void Boton_animateMouseClicked(java.awt.event.MouseEvent evt) throws Exception {
        if (Boton_animate.isEnabled()){
            // Cuando presiona el botón de animar
            //System.out.println("Mouse Clicked! :P");
            Boton_stop_animate.setEnabled(true);
            Boton_animate.setEnabled(false);
            Boton_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Animar1.png")));
            this.visualizacion=false;
            EmpezarAnimacion();
        }
    }
    private void Boton_animateMouseEntered(java.awt.event.MouseEvent evt) {
        if (Boton_animate.isEnabled()){
            // Cuando entra al botón de animar
            //cambia el color (cambia la imagen)
            Boton_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Animar2.png")));
        }
    }
    private void Boton_animateMouseExited(java.awt.event.MouseEvent evt) {
        if (Boton_animate.isEnabled()){
            // Cuando sale al botón de animar
            //cambia el color (cambia la imagen)
            Boton_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Animar1.png")));
        }
    }
    private void Boton_stop_animateMouseClicked(java.awt.event.MouseEvent evt) {
        if (Boton_stop_animate.isEnabled()){
            // Cuando presiona el botón de parar la animación
            Boton_stop_animate.setEnabled(false);
            Boton_animate.setEnabled(true);
            Boton_stop_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Stop1.png")));

            running = false;
            //TODO llamar a método para parar la "graficación"
        }
    }
    private void Boton_stop_animateMouseEntered(java.awt.event.MouseEvent evt) {
        if (Boton_stop_animate.isEnabled()){
            // Cuando entra al botón de parar animación
            //cambia el color (cambia la imagen)
            Boton_stop_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Stop2.png")));
        }
    }
    private void Boton_stop_animateMouseExited(java.awt.event.MouseEvent evt) {
        if (Boton_stop_animate.isEnabled()){
            // Cuando sale al botón de parar animación
            //cambia el color (cambia la imagen)
            Boton_stop_animate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Recursos/Stop1.png")));
        }
    }
    private void SliderListener(javax.swing.event.ChangeEvent evt) {
        // Actualizar las etiquetas
        txt_label_amortiguamiento.setText("b="+Slider_amortiguamiento.getValue()+" kg/s");
        txt_label_const_resorte.setText("k="+Slider_resorte.getValue()+" N/m");
        txt_label_pos_inicial.setText("y(0)="+Slider_pos_inicial.getValue()+" m");
        txt_label_vel_inicial.setText("y'(0)="+Slider_vel_inicial.getValue()+" m/s");
        txt_label_masa.setText("m="+Slider_masa.getValue()+" kg");
        this.visualizacion=true;
        // *** colocar la masa en la posición inicial para visualización *******
        try {
            EmpezarAnimacion();
            //System.out.println("HOla a todos! :P");
        } catch (Exception ex) {
            Logger.getLogger(Oscilator.class.getName()).log(Level.SEVERE, null, ex);
        }
        // *********************************************************************
        //System.out.println("HOla a todos! :P");
    }

    // Very important. You do not want your thread to keep running when
    // the applet is deactivated (eg. user left page)
    public void destroy() {
            // will cause thread to stop looping
            running = false;
            // destroy it.
            clockThread = null;
    }

    // The method that will be called when you have a thread.
    // You always need this when you implement Runnable (use a thread)
    public void run() {
        // loop until told to stop
        while (running) {

            this.Largo_Resorte=this.Tam_inicial_resorte + (int)(30*this.sistema.y(tiempo));
            //para que no se pase para arriba...
            if (Largo_Resorte <=2){
                Largo_Resorte = 2;
            }
            y_grafica=y_grafica_inicial+(int)(30*this.sistema.y(tiempo));
            x_grafica+=2;

            tiempo+=0.1;
            //Now the reason for threads
            try {
                    // Wait 500milliseconds before continuing
                    clockThread.sleep(retardo);
            }
            catch (InterruptedException e) {
                    System.out.println(e);
            }
            // he has wait and will now restart his actions.
            repaint();
            if (this.visualizacion){
                running = false;
                visualizacion=false;
            }
        }
    }

}
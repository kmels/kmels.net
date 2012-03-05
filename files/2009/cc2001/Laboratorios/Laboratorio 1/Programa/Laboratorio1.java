import javax.swing.JTabbedPane;
import javax.swing.event.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.event.ActionListener;
import java.util.ArrayList; 
import javax.swing.event.ChangeListener;
import javax.swing.event.ChangeEvent;
import javax.swing.*;
import java.awt.event.*;

/**
 * Esta es la clase Laboratorio que a su vez es la clase drive
 * 
 * @author Carlos Eduardo L—pez Camey y Jeffry Ezequiel Turcios Aparicio 
 * @version 1.0
 */
public class Laboratorio1 extends JPanel
{
    int quepregunta;
    private Curso curso;
    public static JTabbedPane PanelMaestro;
    JPanel PaneldeProfesor;
    JPanel PaneldeAlumno;
    JPanel PaneldeInicializacion;
    JPanel PaneldeRegistroAlumno;
    JPanel PaneldeIdentificacion;
    JPanel PaneldePregunta;
    JPanel PaneldeIdentificacionProfesor;
    JPanel PaneldePreferencias;
    
    ArrayList<Error> errores;
    JTextField Init_nombreCurso_Input;
    JTextField Init_nombreProfesor_Input;
    JTextField Init_usernameProfesor_Input;
    JPasswordField Init_password1Profesor_Input;
    JPasswordField Init_password2Profesor_Input;
    
    //Login
    JTextField Login_Username_Input;
    JPasswordField Login_Password_Input;
    
    //Login Profesor
    JTextField LoginProfesor_Username_Input;
    JPasswordField LoginProfesor_Password_Input;    
    
    //Register
    JTextField Registro_Nombre_Input;
    JTextField Registro_Username_Input;
    JPasswordField Registro_Password1_Input;
    JPasswordField Registro_Password2_Input;
    JTextField Registro_Ano_Input;
    JComboBox Registro_Mes_Input;
    JTextField Registro_Dia_Input;
    JTextField Registro_nombreMama_Input;
    JTextField Registro_colegioEgresado_Input;
    
    //panel de pregunta
    JButton Pregunta_CerrarSesion_Boton;
    JButton Pregunta_Responder_Boton;
    ArrayList<JRadioButton> Respuestas;
    
    //preferencias
    JButton Preferencias_Exportar_Boton;
    /**
     * Constructor para los objetos de clase Laboratorio1
     */
    //Curso curso;
    
    public Laboratorio1()
    {
         //sin manejador de layouts
        setLayout(null);
        //crear panel de tabs
        PanelMaestro = new JTabbedPane();
        //establecer tama–o del panel de tabs
        PanelMaestro.setBounds(0,0,800,580);

        //crear tab 1 (panel de alumno) y agregarlo al panel maestro
        PaneldeAlumno = new JPanel();
        PaneldeAlumno.setLayout(new BorderLayout());
        PanelMaestro.addTab("<html><b>Alumno</b>", PaneldeAlumno);
        
        PaneldeProfesor = new JPanel();
        PanelMaestro.addTab("<html><b>Profesor</b>", PaneldeProfesor);
        
       
        //fondo del panel de tabs
        //Poner que tab ense–ar y mostrar el panel de tabs
        PanelMaestro.setSelectedIndex(1); //1 es el de profesor
        add(PanelMaestro);
        
        AgregarPaneldeInicializarSistema(PaneldeProfesor, BorderLayout.CENTER);
        //AgregarBotondePreferencias(PaneldeProfesor, BorderLayout.EAST);
        //AgregarNuevoPaneldeInformacionDelCurso(PaneldeAlumno, BorderLayout.NORTH);
    }

    /**
     * Metodo Principal
     * 
     */
    public static void main(String[] args) {
        JFrame marco = new JFrame("Laboratorio 1 - Automatizando la toma de lista de asistencia");
        marco.addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent e) {
                        System.exit(0);
                }
        });
        marco.getContentPane().add(new Laboratorio1(),BorderLayout.CENTER);

        marco.setSize(800, 600);
        marco.setVisible(true);
        try {
            UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
        } 
        catch (Exception e) {
        }
        
        //Centrar el marco respecto a la pantalla
        Dimension TamanodelaPantalla = Toolkit.getDefaultToolkit().getScreenSize();
        Dimension tamanodelmarco = marco.getSize();
        marco.setLocation(TamanodelaPantalla.width/2 - tamanodelmarco.width/2, TamanodelaPantalla.height/2 - tamanodelmarco.height/2);
    }
    
    /**
     * Metodo para agregar el panel de registro de alumnos
     * 
     * @param PanelPapa quien va a ser el contenedor de este panel
     * @posicion Posicion del BorderLayout
     */
    private void AgregarNuevoPaneldeRegistro(JPanel PanelPapa, String posicion){
        //crear panel de registro del alumno y agregarlo al panel del alumno
        PaneldeRegistroAlumno = new JPanel();
        PaneldeRegistroAlumno.setLayout(new GridLayout(0,1));
        PaneldeRegistroAlumno.setBorder(BorderFactory.createTitledBorder("Panel de registro"));
        PanelPapa.add(PaneldeRegistroAlumno, posicion);
        
        //crear el contenido del panel de registro del alumno y agregarlo
        //texto
        JLabel TextodeInfoPaneldeRegistroAlumno = new JLabel("<html><font color=\"#000000\">Proceda a registrarse si no lo ha hecho");
        TextodeInfoPaneldeRegistroAlumno.setFont(new Font("Calibri", Font.PLAIN,14));
        TextodeInfoPaneldeRegistroAlumno.setVerticalAlignment(JLabel.NORTH);
        PaneldeRegistroAlumno.add(TextodeInfoPaneldeRegistroAlumno);
        
        //Inputs y sus labels
        JLabel Registro_Nombre_Label = new JLabel("<html><font color=\"#000000\">Nombre Completo");
        Registro_Nombre_Label.setFont(new Font("Calibri", Font.PLAIN,14));              
        Registro_Nombre_Input = new JTextField("");
        JLabel Registro_Username_Label = new JLabel("<html><font color=\"#000000\">Nombre de Usuario");
        Registro_Username_Label.setFont(new Font("Calibri", Font.PLAIN,14));        
        Registro_Username_Input = new JTextField("");
        JLabel Registro_Password1_Label = new JLabel("Contrase–a");
        Registro_Password1_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        Registro_Password1_Input = new JPasswordField(10);
        JLabel Registro_Password2_Label = new JLabel("Compruebe su contrase–a");
        Registro_Password2_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        Registro_Password2_Input = new JPasswordField(10);
        JLabel Registro_Ano_Label = new JLabel("<html><font color=\"#000000\">A–o de Nacimiento");
        Registro_Ano_Label.setFont(new Font("Calibri", Font.PLAIN,14));              
        Registro_Ano_Input = new JTextField("");
        JLabel Registro_Mes_Label = new JLabel("<html><font color=\"#000000\">Mes de Nacimiento");
        Registro_Mes_Label.setFont(new Font("Calibri", Font.PLAIN,14));              
        String[] Meses = { "Enero", "Febrero", "Marzo", "Abril", "Mayo","Junio","Julio","Agosto","Septiembre","Noviembre","Diciembre" };
        Registro_Mes_Input = new JComboBox(Meses);
        JLabel Registro_Dia_Label = new JLabel("<html><font color=\"#000000\">Dia de Nacimiento");
        Registro_Dia_Label.setFont(new Font("Calibri", Font.PLAIN,14));              
        Registro_Dia_Input = new JTextField("");
        JLabel Registro_nombreMama_Label = new JLabel("<html><font color=\"#000000\">Nombre de su mam‡");
        Registro_nombreMama_Label.setFont(new Font("Calibri", Font.PLAIN,14));              
        Registro_nombreMama_Input = new JTextField("");
        JLabel Registro_colegioEgresado_Label = new JLabel("<html><font color=\"#000000\">Colegio Egresado");
        Registro_colegioEgresado_Label.setFont(new Font("Calibri", Font.PLAIN,14));              
        Registro_colegioEgresado_Input = new JTextField("");     
        JButton Registro_Boton = new JButton("Registrarse");

        
        
        PaneldeRegistroAlumno.add(Registro_Nombre_Label);
        PaneldeRegistroAlumno.add(Registro_Nombre_Input);
        PaneldeRegistroAlumno.add(Registro_Username_Label);
        PaneldeRegistroAlumno.add(Registro_Username_Input);
        PaneldeRegistroAlumno.add(Registro_Password1_Label);
        PaneldeRegistroAlumno.add(Registro_Password1_Input);
        PaneldeRegistroAlumno.add(Registro_Password2_Label);
        PaneldeRegistroAlumno.add(Registro_Password2_Input);
        PaneldeRegistroAlumno.add(Registro_Ano_Label);
        PaneldeRegistroAlumno.add(Registro_Ano_Input);
        PaneldeRegistroAlumno.add(Registro_Mes_Label);
        PaneldeRegistroAlumno.add(Registro_Mes_Input);
        PaneldeRegistroAlumno.add(Registro_Dia_Label);
        PaneldeRegistroAlumno.add(Registro_Dia_Input);
        PaneldeRegistroAlumno.add(Registro_nombreMama_Label);
        PaneldeRegistroAlumno.add(Registro_nombreMama_Input);
        PaneldeRegistroAlumno.add(Registro_colegioEgresado_Label);
        PaneldeRegistroAlumno.add(Registro_colegioEgresado_Input);
        PaneldeRegistroAlumno.add(Registro_Boton);
        
        //crear funcionabilidad para iniciar el curso
        Registro_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
            public void actionPerformed(ActionEvent e){ 
                Registro_ValidarForm();
             }    
        });
    }
    
    /**
     * Metodo para agregar el panel de identificacion
     * 
     * @param PanelPapa quien va a ser el contenedor de este panel
     * @posicion Posicion del BorderLayout
     */
    private void AgregarNuevoPaneldeIdentificacion(JPanel PanelPapa, String posicion){
        PaneldeIdentificacion = new JPanel();
        PaneldeIdentificacion.setLayout(new GridLayout(0,1));
        PaneldeIdentificacion.setBorder(BorderFactory.createTitledBorder("Panel de Identificaci—n"));
        PanelPapa.add(PaneldeIdentificacion, posicion);
        
        JLabel TextodeInfo = new JLabel("<html><font color=\"#000000\">Proceda a identificarse con su nombre de usuario y contrase–a respectiva");
        TextodeInfo.setFont(new Font("Calibri", Font.PLAIN,14));
        TextodeInfo.setVerticalAlignment(JLabel.NORTH);
        PaneldeIdentificacion.add(TextodeInfo);
        
        JLabel Login_Username_Label = new JLabel("<html><font color=\"#000000\">Nombre de Usuario");
        Login_Username_Label.setFont(new Font("Calibri", Font.PLAIN,14));        
        Login_Username_Input = new JTextField("");
        JLabel Login_Password_Label = new JLabel("Contrase–a");
        Login_Password_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        Login_Password_Input = new JPasswordField(10);

        JButton Login_Boton = new JButton("Iniciar sesi—n");
        
        PaneldeIdentificacion.add(Login_Username_Label);
        PaneldeIdentificacion.add(Login_Username_Input);
        PaneldeIdentificacion.add(Login_Password_Label);
        PaneldeIdentificacion.add(Login_Password_Input);
        PaneldeIdentificacion.add(Login_Boton);
        
        //crear funcionabilidad para iniciar el curso
        Login_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
            public void actionPerformed(ActionEvent e){ 
                Login_ValidarForm();
             }    
        });
    }
    
    /**
     * Metodo para agregar el panel de identificacion del profesor
     * 
     * @param PanelPapa quien va a ser el contenedor de este panel
     * @posicion Posicion del BorderLayout
     */
    private void AgregarNuevoPaneldeIdentificacionProfesor(JPanel PanelPapa, String posicion){
        PaneldeIdentificacionProfesor = new JPanel();
        PaneldeIdentificacionProfesor.setLayout(new GridLayout(0,1));
        PaneldeIdentificacionProfesor.setBorder(BorderFactory.createTitledBorder("Panel de Identificaci—n del Profesor"));
        PanelPapa.add(PaneldeIdentificacionProfesor, posicion);
        
        JLabel TextodeInfo = new JLabel("<html><font color=\"#000000\">Proceda a identificarse con su nombre de usuario y contrase–a respectiva");
        TextodeInfo.setFont(new Font("Calibri", Font.PLAIN,14));
        TextodeInfo.setVerticalAlignment(JLabel.NORTH);
        PaneldeIdentificacionProfesor.add(TextodeInfo);
        
        JLabel LoginProfesor_Username_Label = new JLabel("<html><font color=\"#000000\">Nombre de Usuario");
        LoginProfesor_Username_Label.setFont(new Font("Calibri", Font.PLAIN,14));        
        LoginProfesor_Username_Input = new JTextField("");
        JLabel LoginProfesor_Password_Label = new JLabel("Contrase–a");
        LoginProfesor_Password_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        LoginProfesor_Password_Input = new JPasswordField(10);

        JButton LoginProfesor_Boton = new JButton("Iniciar sesi—n");
        
        PaneldeIdentificacionProfesor.add(LoginProfesor_Username_Label);
        PaneldeIdentificacionProfesor.add(LoginProfesor_Username_Input);
        PaneldeIdentificacionProfesor.add(LoginProfesor_Password_Label);
        PaneldeIdentificacionProfesor.add(LoginProfesor_Password_Input);
        PaneldeIdentificacionProfesor.add(LoginProfesor_Boton);
        
        //crear funcionabilidad para iniciar el curso
        LoginProfesor_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
            public void actionPerformed(ActionEvent e){ 
                LoginProfesor_ValidarForm();
             }    
        });
    }
    
    /**
     * Metodo para agregar el panel de informacion del curso
     * 
     * @param PanelPapa quien va a ser el contenedor de este panel
     * @posicion Posicion del BorderLayout
     */
    private void AgregarNuevoPaneldeInformacionDelCurso(JPanel PanelPapa, String posicion){
        //crear panel de informacion
        JPanel PaneldeInformacion = new JPanel();
        PaneldeInformacion.setLayout(new BorderLayout());
        PaneldeInformacion.setBorder(BorderFactory.createTitledBorder("Panel de Informaci—n del Curso"));
        
        JLabel Texto = new JLabel("Este es el curso X del profesor Y");
        Texto.setFont(new Font("Calibri", Font.PLAIN,22));
        Texto.setVerticalAlignment(JLabel.NORTH);

        PaneldeInformacion.add(Texto); 
        PanelPapa.add(PaneldeInformacion);
    }
    

    /**
     * Metodo para agregar el panel de preferencias del curso
     * 
     * @param PanelPapa quien va a ser el contenedor de este panel
     * @posicion Posicion del BorderLayout
     */
    private void AgregarPaneldePreferencias(JPanel PanelPapa, String posicion){
        PaneldePreferencias = new JPanel(new GridLayout(0,1));
        PaneldeInicializacion.setBorder(BorderFactory.createTitledBorder("Panel de Preferencias del curso"));
        Preferencias_Exportar_Boton = new JButton("Exportar lista de Asistencia a Archivo de Excel");
        PaneldePreferencias.add(Preferencias_Exportar_Boton);
        Preferencias_Exportar_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
                public void actionPerformed(ActionEvent e){ 
                    ExportarListaAExcel();
                }    
        });
        
        JTable tabla1 = new JTable(curso.getLista(),curso.getEncabezado());
        PaneldePreferencias.add(tabla1);
 
        Pregunta_CerrarSesion_Boton = new JButton("Cerrar Sesi—n");
            Pregunta_CerrarSesion_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
                public void actionPerformed(ActionEvent e){ 
                    Usuario_CerrarSesion();
                }    
        });
        
        PanelPapa.add(PaneldePreferencias);
    }
    
    /**
     * Metodo para agregar el boton de preferencias
     * 
     * @param PanelPapa quien va a ser el contenedor de este panel
     * @posicion Posicion del BorderLayout
     */
    private void AgregarBotondePreferencias(JPanel PanelPapa, String posicion){
        JButton Ir_a_Preferencias = new JButton ("Ir Preferencias");
        Ir_a_Preferencias.setFont(new Font("Calibri", Font.PLAIN,14));
        PanelPapa.add(Ir_a_Preferencias, posicion); 
    }
    
    /**
     * Metodo para agregar el panel de inicializaci—n del sistema
     * 
     * @param PanelPapa quien va a ser el contenedor de este panel
     * @posicion Posicion del BorderLayout
     */
    private void AgregarPaneldeInicializarSistema(JPanel PanelPapa, String posicion){
        PaneldeInicializacion = new JPanel();
        PaneldeInicializacion.setLayout(new GridLayout(0,1));
        PaneldeInicializacion.setBorder(BorderFactory.createTitledBorder("Panel de Inicializaci—n del Sistema"));
        PanelPapa.add(PaneldeInicializacion, posicion);
        
        JLabel TextodeInfo = new JLabel("<html><font color=\"#000000\">Proceda a inicializar el curso ingresando los datos pedidos");
        TextodeInfo.setFont(new Font("Calibri", Font.PLAIN,14));
        TextodeInfo.setVerticalAlignment(JLabel.NORTH);
        PaneldeInicializacion.add(TextodeInfo);
        
        JLabel Init_nombreCurso_Label = new JLabel("<html><font color=\"#000000\">Nombre del Curso");
        Init_nombreCurso_Label.setFont(new Font("Calibri", Font.PLAIN,14));        
        Init_nombreCurso_Input = new JTextField("");
        JLabel Init_nombreProfesor_Label = new JLabel("Nombre Completo del Catedr‡tico");
        Init_nombreProfesor_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        Init_nombreProfesor_Input = new JTextField("");
        JLabel Init_usernameProfesor_Label = new JLabel("Nombre de usuario del Catedr‡tico");
        Init_usernameProfesor_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        Init_usernameProfesor_Input = new JTextField("");
        JLabel Init_password1Profesor_Label = new JLabel("Contrase–a del Catedr‡tico");
        Init_password1Profesor_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        Init_password1Profesor_Input = new JPasswordField(10);
        JLabel Init_password2Profesor_Label = new JLabel("Compruebe la contrase–a");
        Init_password2Profesor_Label.setFont(new Font("Calibri", Font.PLAIN,14));
        Init_password2Profesor_Input = new JPasswordField(10);        
        JButton Init_Boton = new JButton("Inicializar el Curso");
                
        PaneldeInicializacion.add(Init_nombreCurso_Label);
        PaneldeInicializacion.add(Init_nombreCurso_Input);
        PaneldeInicializacion.add(Init_nombreProfesor_Label);
        PaneldeInicializacion.add(Init_nombreProfesor_Input);
        PaneldeInicializacion.add(Init_usernameProfesor_Label);
        PaneldeInicializacion.add(Init_usernameProfesor_Input);
        PaneldeInicializacion.add(Init_password1Profesor_Label);
        PaneldeInicializacion.add(Init_password1Profesor_Input);
        PaneldeInicializacion.add(Init_password2Profesor_Label);
        PaneldeInicializacion.add(Init_password2Profesor_Input);
        PaneldeInicializacion.add(Init_Boton);
        
        
        
        //crear funcionabilidad para iniciar el curso
        Init_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
            public void actionPerformed(ActionEvent e){ 
                Init_ValidarForm();
             }    
        });
       
    }
    
    /**
     * MŽtodo para validar el formulario de Inicializaci—n
     * 
     */
    public void Init_ValidarForm(){
        errores = new ArrayList<Error>();
        
        if (Init_nombreCurso_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese el nombre del curso"));
        } 
		
        if (Init_nombreProfesor_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese el nombre completo del catedr‡tico"));
        }
        
        if (Init_usernameProfesor_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese el nombre de usuario del catedr‡tico"));
        }
        
        if (Init_password1Profesor_Input.getText().compareTo(Init_password2Profesor_Input.getText())!=0) {
           errores.add(new Error("Las contrase–as que usted ingreso no coinciden una con la otra"));    
        }
        
        if (Init_password1Profesor_Input.getText().length()<4){
           errores.add(new Error("Por su seguridad, ingrese una contrase–a de al menos, 5 (cinco) caracteres de largo"));    
        }
        
        MostrarErrores(errores);

        if (!MostrarErrores(errores)){
            this.curso = new Curso(Init_nombreCurso_Input.getText(),Init_nombreProfesor_Input.getText(),Init_usernameProfesor_Input.getText(),Init_password1Profesor_Input.getText());
            JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Se inici— el curso con Žxito");
		      PaneldeProfesor.remove(PaneldeInicializacion);
		      PanelMaestro.setSelectedIndex(0); //0 es el de profesor
		      AgregarNuevoPaneldeRegistro(PaneldeAlumno, BorderLayout.CENTER);
		      AgregarNuevoPaneldeIdentificacion(PaneldeAlumno, BorderLayout.SOUTH);
		      AgregarNuevoPaneldeIdentificacionProfesor(PaneldeProfesor, BorderLayout.CENTER);
		  }
    }

    /**
     * MŽtodo para validar el formulario de Registro
     * 
     */
    public void Registro_ValidarForm(){
        errores = new ArrayList<Error>();
        
        if (Registro_Nombre_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese su nombre Completo"));
        } 

        if (Registro_Username_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese su usuario"));
        }
        
        if (Registro_Password1_Input.getText().compareTo(Registro_Password2_Input.getText())!=0) {
           errores.add(new Error("Las contrase–as que usted ingreso no coinciden una con la otra"));    
        }
        
        if (Registro_Password1_Input.getText().length()<4){
           errores.add(new Error("Por su seguridad, ingrese una contrase–a de al menos, 5 (cinco) caracteres de largo"));    
        }
        
        //info del usuario
        if (Registro_Ano_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese el a–o en el que naci—"));
        }
        
        if (Registro_Dia_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese el dia en el que naci—"));
        }
        
        if (Registro_nombreMama_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese el nombre de su mam‡"));
        }
        
        if (Registro_colegioEgresado_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese el colegio del cu‡l usted ingreso"));
        }
        
        if (!MostrarErrores(errores)){
            JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Usted se ha registrado "+Registro_Nombre_Input.getText());
            String Mes  = (String)(Registro_Mes_Input.getItemAt(Registro_Mes_Input.getSelectedIndex()));
            curso.RegistrarUsuario(Registro_Nombre_Input.getText(),Registro_Username_Input.getText(),Registro_Password1_Input.getText(),Registro_Ano_Input.getText(),Mes,Registro_Dia_Input.getText(),Registro_nombreMama_Input.getText(),Registro_colegioEgresado_Input.getText());
            //limpiar formulario de registro
            Registro_Nombre_Input.setText("");
            Registro_Username_Input.setText("");
            Registro_Password1_Input.setText("");
            Registro_Password2_Input.setText("");
            Registro_Dia_Input.setText("");
            Registro_Ano_Input.setText("");
            Registro_Mes_Input.setSelectedIndex(0);
            Registro_nombreMama_Input.setText("");
            Registro_colegioEgresado_Input.setText("");
		  }
    }

    /**
     * MŽtodo para validar el formulario de Identificaci—n
     * 
     */
    public void Login_ValidarForm(){
        errores = new ArrayList<Error>();
        
        if (Login_Username_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese su nombre de usuario"));
        } 

        if (Login_Password_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese su contrase–a"));
        }
        
        if (!curso.Login(Login_Username_Input.getText(),Login_Password_Input.getText())){
            errores.add(new Error("No hay nadie con ese usuario y esa contrase–a"));
        }
        
        if (!MostrarErrores(errores)){
            //mostrar el log (si se logro loggear)
            
            JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Usted se ha logeado con Žxito "+curso.getNombreDelUsuarioActual());
            //limpiar formulario de login
            PaneldeAlumno.remove(PaneldeRegistroAlumno);
            PaneldeAlumno.remove(PaneldeIdentificacion);
            Login_Username_Input.setText("");
            Login_Password_Input.setText("");
            AgregarPaneldePregunta(PaneldeAlumno, BorderLayout.CENTER);
		  }
    }
    
    /**
     * MŽtodo para validar el formulario de Identificaci—n del Profesor
     * 
     */
    public void LoginProfesor_ValidarForm(){
        errores = new ArrayList<Error>();
        
        if (LoginProfesor_Username_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese su nombre de usuario"));
        } 

        if (LoginProfesor_Password_Input.getText().compareTo("")==0){
           errores.add(new Error("Ingrese su contrase–a"));
        }
        
        if (!curso.LoginProfesor(LoginProfesor_Username_Input.getText(),LoginProfesor_Password_Input.getText())){
            errores.add(new Error("No hay ningun profesor con ese usuario y esa contrase–a"));
            MostrarErrores(curso.getListadeLog());
        }
        
        if (!MostrarErrores(errores)){
            JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Usted se ha logeado con Žxito Profesor "+curso.getNombreDelUsuarioActual());
            //limpiar formulario de login
            LoginProfesor_Username_Input.setText("");
            LoginProfesor_Password_Input.setText("");
            PaneldeProfesor.remove(PaneldeIdentificacionProfesor);
            AgregarPaneldePreferencias(PaneldeProfesor, BorderLayout.CENTER);
		  }
    }
    


    /**
     * MŽtodo para exportar la lista de asistencia a Excel
     * 
     */
    public void ExportarListaAExcel(){
        curso.ExportarExcel();
    }
    
    /**
     * MŽtodo para cerrar la cesi—n del usuario
     * 
     */
    public void Usuario_CerrarSesion(){
        JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Se cerro la sesi—n de "+curso.getNombreDelUsuarioActual());
        curso.CerrarSesiondelUsuarioActual();
            
        //agregar panel de registro y de login
        PaneldeAlumno.remove(PaneldePregunta);
        AgregarNuevoPaneldeRegistro(PaneldeAlumno, BorderLayout.CENTER);
        AgregarNuevoPaneldeIdentificacion(PaneldeAlumno, BorderLayout.SOUTH);
    }
    
     /**
     * Metodo para mostrar los errores
     * 
     * @param errores Vector que contiene los errores de tipo Error (ver clase error)
     * @return true si hay errores, false si no los hay
     */
    private boolean MostrarErrores(ArrayList<Error> errores){
        //si hay algun error en el formulario
		if (errores.size()>0){
		    String mensajedeError = "<html><b>Se produjeron los siguientes errores: </b><br><br>";
		    for (int i=0;i<(errores.size());i++){
		      //crear mensaje
		      mensajedeError = mensajedeError + errores.get(i).getErrorMsg()+"<br>";
		     }
		     
		     JOptionPane.showMessageDialog(PanelMaestro, mensajedeError);
		     return true;
		  } else{
		      return false;
		  }
    }
    
    /**
     * Metodo para agregar el panel de pregunta
     * 
     * @param donde El Panel contenedor que contendr‡ al panel de pregunta
     * @param posicion en que posicion (ver clase BorderLayout)
     */
    private void AgregarPaneldePregunta(JPanel donde, String posicion){
            PaneldePregunta = new JPanel(new GridLayout(0,1));
            PaneldePregunta.setBorder(BorderFactory.createTitledBorder("Porfavor responda a la siguiente pregunta para a–adirse a la lista de asistencia"));
            //calcular que tipo de pregunta es la que va a sacar
            quepregunta = (int)Math.random()*5;
            
            JLabel Pregunta_Label = new JLabel(curso.getPregunta(quepregunta));
            PaneldePregunta.add(Pregunta_Label);
            Pregunta_Label.setFont(new Font("Calibri", Font.PLAIN,14));
            
            Respuestas = new ArrayList<JRadioButton>();
            for (int i=0;i<=4;i++){
                Respuestas.add(new JRadioButton(curso.getRespuestaAlAzar(quepregunta)));
                PaneldePregunta.add(Respuestas.get(i));
            }
            
            Pregunta_CerrarSesion_Boton = new JButton("Cerrar Sesi—n");
            Pregunta_CerrarSesion_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
                public void actionPerformed(ActionEvent e){ 
                    Usuario_CerrarSesion();
                }    
            });
            
            Pregunta_Responder_Boton = new JButton("A–adirse a la lista de asistencia");
            Pregunta_Responder_Boton.addActionListener(new ActionListener(){ //asignar un ActionListener
                public void actionPerformed(ActionEvent e){ 
                    Pregunta_Responder();
                }    
            });
            
            PaneldePregunta.add(Pregunta_Responder_Boton);
            PaneldePregunta.add(Pregunta_CerrarSesion_Boton);
            donde.add(PaneldePregunta, BorderLayout.CENTER);
    }
    
 /**
     * Regresa la respuesta que esta en el radio button
     * 
     * @return la respuesta en el radio button
     */
    public void TratarDeMarcarComoAsistido(){
        boolean hayclickeado = false;
        int cuantosclickeados = 0;
        int seleccionado = 0;
        
        for (int i=0; i<=4; i++){
            if (Respuestas.get(i).isSelected()){
                cuantosclickeados++;
                hayclickeado=true;
                seleccionado = i;
            }
        }
        
        if (!hayclickeado){
            JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Tiene que seleccionar al menos una respuesta");
        } else{
            if (cuantosclickeados>1){
                JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Solo puede seleccionar una respuesta");    
            }   else {
                      if (curso.esLaRespuestaCorrecta(Respuestas.get(seleccionado).getText(),quepregunta)){
                          JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Usted acaba de marcarse como asistido");
                      }
                      else {
                          JOptionPane.showMessageDialog(PanelMaestro, "<html>"+"Respuesta incorrecta");
                      }
                }
          }
    }
    
    /**
     * MŽtodo para a–adir el usuario a la lista, dependiendo si respondi— bien o no
     * 
     */
    public void Pregunta_Responder(){
       TratarDeMarcarComoAsistido();
    }
        
    
}

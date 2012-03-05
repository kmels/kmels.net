
/**
 * Clase Usuario.
 * 
 * @author Carlos Eduardo Lopez Camey y Jeffry Ezequiel Turcios Aparicio
 * @version 1.0
 */
public class Usuario
{
    // instance variables - replace the example below with your own
    private String username;
    private String password;
    private boolean logged;
    private boolean admin;
    private String anodeNacimiento;
    private String diadeNacimiento;
    private String mesdeNacimiento;
    private String nombreMama;
    private String colegioEgresado;
    private String Nombre;
    private boolean asistio;
    private boolean bloqueado;

    /**
     * Constructor de la clase Usuario
     * 
     * @param nombre el nombre del usuario
     * @param username el nombre de usuario del usuario
     * @param password la contrase–a del usuario
     */
    
    public Usuario(String nombre, String username, String password)
    {
        this.logged = false;
        this.admin = false;
        this.Nombre = nombre;
        this.username = username;
        this.password = password;
        this.asistio = false;
        this.bloqueado= false;
    }
    
     /**
     * Metodo para marcar como admin al Usuario
     * 
     */
    public void setAsAdmin(){
        admin = true;
    }
    
    /**
     * Metodo para intentar logear al usuario, si el nombre de usuario coincide con su password, se loggea
     * 
     * @param username el nombre de usuario
     * @param password el password del usuario
     * @return true, si el intento de iniciar sesi—n fue exitoso (los datos coincidieron), si no, devuelve false.
     */
    public boolean Login(String username, String password)
    {
         if ((this.password.compareTo(password)==0) && (this.username.compareTo(username)==0)){
                logged=true;
         } else {
                logged=false;
         }
         
         return logged;
    }
    
    /**
     * Metodo para obtener una respuesta 
     *
     * @param cual indicar‡ que respuesta es la que quiere del usuario
     * 1 ser’a anodeNacimiento
     * 2 ser’a diadeNacimiento
     * 3 seria mesdeNacimiento
     * 4 seria nombreMama
     * 5 seria colegioEgresado
     * 
     */
    public String getRespuesta(Integer cual)
    {
        switch (cual){
            case 1: //devolvera el ano de nacimiento
                return anodeNacimiento;
            case 2:
                return diadeNacimiento;
            case 3:
                return mesdeNacimiento;
            case 4:
                return nombreMama;
            default:
                return colegioEgresado;
        }
    }
       
    /**
     * Metodo para asignar el nombre de usuario al Usuario
     * 
     * @param username el nombre de usuario 
     * @return 
     */
    public void setUsername(String username)
    {
        this.username=username;
    }
 
     /**
     * Metodo para asignar el password al Usuario
     * 
     * @param password el password que se le quiere asignar al usuario
     * @return 
     */
    public void setPassword(String password)
    {
        this.password=password;
    }
    
     /**
     * Metodo para saber si el usuario esta logeado
     * 
     * @param  
     * @return true si el usuario esta logeado (ha iniciado sesion), false de lo contrario.
     */
    public boolean estaLogeado ()
    {
        return logged;
    }
    
    /**
     * Metodo para cerrar la sesi—n del usuario
     * 
     */
    public void CerrarSesion()
    {
        this.logged = false;
    }
    
     /**
     * Metodo para saber si el usuario es administrador
     * 
     * @param  
     * @return true si el usuario actual es administrador del curso de lo contrario, devuelve false.
     */
    public boolean esAdmin ()
    {
        return admin;
    }
    
     /**
     * Metodo para saber el nombre de usuario
     * 
     * @param  
     * @return el nombre de usuario
     */
    public String getUsername(){
        return username;
    }
    
    /**
     * Metodo para saber el nombre del usuario
     * 
     * @param  
     * @return el nombre del usuario
     */
    public String getNombre(){
        return this.Nombre;
    }
    
    /**
     * Metodo para establecer el nombre del usuario
     * 
     * @param  nombre el Nombre del usuario
     * @return
     */
    public void setNombre(String nombre){
        this.Nombre = nombre;
    }
    
     /**
     * Metodo para asignar el ano en el que nacio el usuario
     * 
     * @param  ano el ano en el que nacio el usuario
     */
    public void setAnodeNacimiento(String ano){
        this.anodeNacimiento = ano;
    }
    
     /**
     * Metodo para asignar el mes en el que nacio el usuario
     * 
     * @param  mes el mes en el que nacio el usuario
     */
    public void setMesdeNacimiento(String mes){
        this.mesdeNacimiento = mes;
    }
    
     /**
     * Metodo para asignar el dia en el que nacio el usuario
     * 
     * @param  dia el dia en el que nacio el usuario
     */
    public void setDiadeNacimiento(String dia){
        this.diadeNacimiento = dia;
    }
    
    /**
     * Metodo para asignar el nombre de la mama del usuario
     * 
     * @param  nombreMama el nombre de la mama del usuario
     */
    public void setNombreMama(String nombreMama){
        this.nombreMama = nombreMama;
    }
    
    /**
     * Metodo para asignar el colegio del que egreso el usuario
     * 
     * @param  colegio el colegio del que egreso el usuario
     */
    public void setColegioEgresado(String colegio){
        this.colegioEgresado = colegio;
    }
    
    /**
     * Metodo para devolver la contrase–a de un usuario
     * 
     * @return la contrase–a del usuario
     */
    public String getPassword(){
        return this.password;
    }
    
    /**
     * MŽtodo para marcar como asistido
     * 
     */ 
    public void YaAsistencia()
	{
		this.asistio = true;
	}
	
	/**
     * MŽtodo para devolver si ya asistio
     * 
     * @return true si ya asistio
     */ 
	public String getAsistencia()
	{
		if (this.asistio)
			return("Si");
		return("NO");
	}
	
	/**
     * MŽtodo para marcar como asistido
     * 
     */ 
	public void setBloqueado(boolean b)
	{
		bloqueado = b;
	}
}

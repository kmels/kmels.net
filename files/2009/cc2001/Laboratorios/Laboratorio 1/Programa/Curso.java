/**
 * Clase Curso.
 * 
 * @author Carlos Eduardo Lopez Camey y Jeffry Ezequiel Turcios Aparicio
 * @version 1.0
 */
 
import java.util.*; 
import java.util.ArrayList;
import javax.swing.*;
import java.io.*;

public class Curso
{
    private ArrayList<Usuario> usuarios = new ArrayList<Usuario>();
    public String nombreCurso;
    private String nombreProfesor;
    
    public int indiceActual;
    public boolean alguienLogeado = false;
    ArrayList<Error> log;
    
    /**
    * Metodo para registrar en el sistema a una persona nueva
    *
    * @param username el nombre de usuario
    * @param password el password del usuario
    * @param nombre el nombre del Profesor quien es el administrador de tareas
    * @return 
    */
    
    public Curso (String nombreCurso, String nombreProfesor, String usernameProfesor, String passwordProfesor)
    {
        this.nombreCurso = nombreCurso;
        
        usuarios.add(new Usuario(nombreProfesor,usernameProfesor,passwordProfesor));
        usuarios.get(0).setAsAdmin();
        log = new ArrayList<Error>();
        log.add(new Error("se creo un curso nuevo"));
    }
    
    public void RegistrarUsuario(String nombre,String username, String password, String ano, String mes, String dia, String mama, String colegio)
    {
        usuarios.add(new Usuario(nombre, username,password));
        usuarios.get(usuarios.size() - 1).setAnodeNacimiento(ano);
        usuarios.get(usuarios.size() - 1).setMesdeNacimiento(mes);
        usuarios.get(usuarios.size() - 1).setDiadeNacimiento(dia);
        usuarios.get(usuarios.size() - 1).setNombreMama(mama);
        usuarios.get(usuarios.size() - 1).setColegioEgresado(colegio);
    }
        
    /**
    * Metodo para revisar si alguien mas esta legeado
    *
    * @param  pass desc 
    * @return 
    */
    
    public void setPreferences()
    {
        
    }
    
    /**
    * Metodo para revisar si alguien mas esta logeado
    *
    * @return true si alguien esta logeado
    */
    public boolean HayAlguienLogueado()
    {
        for(int i=0; i <= usuarios.size(); i++)
            if (usuarios.get(i).estaLogeado())
                return true;
        
        return false;
    }
    
    /**
    * Metodo para logear a un usuario
    *
    * @param username nombre de usuairo
    * @param password contrase–a del usuario
    * @return true si consiguio logearse
    */
    public boolean Login(String username, String password)
    {
        boolean halogeadoAAlguien = false;
        
        int numuser=0;
        while ((!halogeadoAAlguien) && (numuser< usuarios.size())){
            if ((usuarios.get(numuser).getUsername().compareTo(username)==0) && (usuarios.get(numuser).getPassword().compareTo(password)==0)){
                //encontro a alguien
                this.indiceActual=numuser;
                log.add(new Error("<html>Usuario actual es: "+Integer.toString(indiceActual)));
                halogeadoAAlguien=true;
                log.add(new Error("<html>Si coincidio<br>"));
                usuarios.get(numuser).Login(username,password);
                return true;
            }
            else
            {
               log.add(new Error("<html>No coincidio el usuario "+Integer.toString(numuser)+" username "+usuarios.get(numuser).getUsername()+" con "+username+" y tampoco el pass "+usuarios.get(numuser).getPassword()+" con "+password+"<br>"));              
               halogeadoAAlguien=false;
            }
            numuser++;
        }
        
        log.add(new Error("<html>devolvio lo del final"+"<br>"));              
        return halogeadoAAlguien;
    }
    
    
    /**
    * Metodo para logear a un usuario
    *
    * @param username nombre de usuairo
    * @param password contrase–a del usuario
    * @return true si consiguio logearse
    */
    public boolean LoginProfesor(String username, String password)
    {
        if ((usuarios.get(0).getUsername().compareTo(username)==0) && (usuarios.get(0).getPassword().compareTo(password)==0)){
                this.indiceActual=0;

                log.add(new Error("<html>Si coincidio<br>"));
                usuarios.get(0).Login(username,password);
                if (!usuarios.get(0).Login(username,password)){
                    int numuser=0;
                    log.add(new Error("<html>No coincidio el usuario "+Integer.toString(numuser)+" username "+usuarios.get(numuser).getUsername()+" con "+username+" y tampoco el pass "+usuarios.get(numuser).getPassword()+" con "+password+"<br>"));              
                }
                
                return true;
         }else {
             int numuser=0;
             log.add(new Error("<html>No coincidio el usuario "+Integer.toString(numuser)+" username "+usuarios.get(numuser).getUsername()+" con "+username+" y tampoco el pass "+usuarios.get(numuser).getPassword()+" con "+password+"<br>"));              
             return false;
         }
    }
    
     /**
     * Metodo para cerrar la sesion del usuario actual
     * 
     */
    public void CerrarSesiondelUsuarioActual()
    {
        usuarios.get(indiceActual).CerrarSesion();
    }
    
    public void RevisarPregunta()
    {        
    }

     /**
     * Metodo para sacar una pregunta
     * 
     * @param quepregunta Que pregunta
     * @return la pregunta
     */
    public String getPregunta(int quepregunta)
    {
        switch (quepregunta)
        {
            case 1: return ("En que ano naciste?");
            
            case 2: return ("En que dia naciste?");
            
            case 3: return ("En que mes naciste?");
            
            case 4: return ("Cual es el nombre de tu mama?");
            
            default: return ("De que colegio egresaste?");
        }
    }
    
     /**
     * Metodo para sacar una respuesta
     * 
     * @param querespuesta Que respuesta
     * @return la respuesta
     */
    public String getRespuesta(int querespuesta)
    {
        return usuarios.get(indiceActual).getRespuesta(querespuesta);
    }
    
     /**
     * Metodo para sacar una respuesta al azar de cualquier otro usuario
     * 
     * @param querespuesta Que respuesta
     * @return la respuesta
     */
    public String getRespuestaAlAzar(int querespuesta)
    {
        int usuariorandom = (int)(Math.random()*usuarios.size())+1;
        return usuarios.get(usuariorandom-1).getRespuesta(querespuesta);
    }
    
    /**
     * Metodo para saber el nombre del usuario actual
     * 
     * @return el nombre del usuario actual
     */
    public String getNombreDelUsuarioActual(){
            return usuarios.get(indiceActual).getNombre();
    }
    

   /**
     * Metodo para saber cuantos usuarios existen en el curso
     * 
     * @return el numero de usuarios suscritos en el curso
     */
    public String getCuantosUsers(){
        return Integer.toString(usuarios.size());
    }

   /**
     * Metodo para saber lo que esta pasando dentro de la clase curso
     * 
     * @return el log del objeto curso
     */
    public ArrayList<Error> getListadeLog(){
        return this.log;
    }

   /**
     * Metodo para saber si la respuesta esta bien
     * 
     * @return true, si la respuesta concuerda con la del usuario actual, false si no
     */
    public boolean esLaRespuestaCorrecta(String respuesta, int querespuesta)
	{
		if (respuesta.equals(getRespuesta(querespuesta))){
		    usuarios.get(indiceActual).YaAsistencia();
		    return true;
		  }
		else 
		  return false;
	}
	
   /**
     * Metodo que regresa la tabla de alumnos
     * 
     */
	public JTable getTabla()
	{
		JTable tabla = new JTable(getLista(),getEncabezado());
		return (tabla);
	}
	
   /**
     * Metodo que devuelve la lista de alumnos
     * 
     */
	public String[][] getLista()
	{
		String[][] lista = new String[usuarios.size()][2];
		
		for (int i= 1; i <= (usuarios.size()-1);i++)
			for(int j=0; j < 2; j++)
			{
				switch (j)
				{
					case 1: lista[i][j] = usuarios.get(i).getNombre();
					case 2: lista[i][j] = usuarios.get(i).getAsistencia();
				}
			}
		return (lista);
	}
	
   /**
     * Metodo que exporta la tabla a excel
     * 
     */
	public void ExportarExcel()
	{
		try {                
			ExcelExporter exp = new ExcelExporter(); 
			exp.exportTable(getTabla(), new File("Lista.xls"));
		} catch (IOException ex) {
			System.out.println(ex.getMessage());
			ex.printStackTrace();
		}
	}
	
   /**
     * Metodo que titula la tabla
     * 
     */
	public String[] getEncabezado()
	{
		String[] encabezado = {"Nombre del Alumno","Asistencia"};
		return (encabezado);
	}
	
   /**
     * Metodo que desbloquea a un usuario
     * 
     */
	public void Desbloquear(String username)
	{
		for(int i=0; i <= (usuarios.size()-1); i++)
			if(username.equals(usuarios.get(i).getUsername()))
				usuarios.get(i).setBloqueado(false);
	}
	
   /**
     * Metodo que desbloquea a un usuario
     * 
     */
	public void Bloquear(String username)
	{
		for(int i=0; i <= (usuarios.size()-1); i++)
			if(username.equals(usuarios.get(i).getUsername()))
				usuarios.get(i).setBloqueado(true);
	}
}
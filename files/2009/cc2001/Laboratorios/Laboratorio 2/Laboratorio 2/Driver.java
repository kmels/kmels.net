
/**
 * Esta es la clase driver
 * 
 * @author Carlos Lopez Camey & Jeffry Turcios
 * @version 01.02.2009
 */

import java.util.*;

public class Driver
{
    Matriz[] Matrices;
    
    public static void main (String args[]) {
        Matrices = new Matriz['A']['Z'];
        EscribirMenu();
    }
    
    public void EscribirMenu(){
        System.out.println("******************** MENU ******************** ");
        System.out.println("Que quiere hacer? (Ingrese el numero que corresponda) ");
        System.out.println("1. Ingresar Matriz");
        System.out.println("2. Operar Matrices (En postfix)");
        System.out.println("3. Borrar Matriz");
        System.out.println("******************** MENU ******************** ");
    }
    
    
}
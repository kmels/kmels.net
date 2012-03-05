
/**
 * Esta clase va a ser de errores
 * 
 * @author Carlos Eduardo Lopez Camey y Jeffry Ezequiel Turcios
 * @version 1.0
 */
public class Error
{
    private String errorMessage;

    /**
     * Constructor
     */
    public Error(String errorMessage)
    {
        // inicializar el mensaje de error
        this.errorMessage = errorMessage;
    }

    /**
     * Este metodo devuelve el mensaje de error
     * 
     * @return El mensaje del error
     */
    public String getErrorMsg()
    {
        return errorMessage;
    }
}

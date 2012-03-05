import java.util.Properties;

/**
 * 
 */

/**
 * @author kmels
 *
 */
public class SistemaLibreAmortiguado {
	private Properties propiedades;
	private float omega;
	private float lambda;
	public float c1;
	public float c2;
	
	public float masa;
	public float constanteDeAmortiguamiento;
	public float constanteDelResorte;
	public float posicionInicial;
	public float velocidadInicial;

        private String funcion="";
	
	
	
	public SistemaLibreAmortiguado(float masaEnKg, float constanteDeAmortiguamientoEnKgPorSeg, float constanteDelResorteEnNewtonPorMetro, float posicionInicial, float velocidadInicial ) throws Exception{
		if (constanteDeAmortiguamientoEnKgPorSeg < 0) 
			throw new Exception ("constante de amortiguamiento es negativa");
		
		this.propiedades = new Properties();
		this.masa = masaEnKg;
		this.constanteDeAmortiguamiento = constanteDeAmortiguamientoEnKgPorSeg;
		this.constanteDelResorte = constanteDelResorteEnNewtonPorMetro;
		this.posicionInicial = posicionInicial;
		this.velocidadInicial = velocidadInicial;
		
		this.lambda =  constanteDeAmortiguamiento/(2*masaEnKg);
		this.omega = (float) Math.sqrt(this.constanteDelResorte/this.masa);
		
		if ((lambda*lambda-omega*omega)>0){
			this.propiedades.setProperty("tipo", "Sobre-amortiguado");

                        Float m1 = -lambda + (float) Math.sqrt(lambda*lambda-omega*omega);
			Float m2 = -lambda - (float) Math.sqrt(lambda*lambda-omega*omega);
                        this.c2 = (this.velocidadInicial-this.posicionInicial*m1)/(m2-m1);
			this.c1 = this.posicionInicial - this.c2;

                        //this.funcion="y(t) = "+c1+"*e^("+((-constanteDeAmortiguamiento+Math.sqrt(constanteDeAmortiguamiento*constanteDeAmortiguamiento-4*masa*constanteDelResorte))/(2*masa))+"t)"+""+c2+"*e^("+((-constanteDeAmortiguamiento-Math.sqrt(constanteDeAmortiguamiento*constanteDeAmortiguamiento-4*masa*constanteDelResorte))/(2*masa))+"t)";
                        this.funcion="y(t) = "+c1+"e^("+(m1)+"t)+"+c2+"e^("+(m2)+")t";

		} else if ((lambda*lambda-omega*omega)==0){
			this.propiedades.setProperty("tipo", "Criticamente amortiguado");

                        float m1 = -lambda + (float) Math.sqrt(lambda*lambda-omega*omega);
			this.c2 = this.velocidadInicial - this.posicionInicial*m1;
			this.c1 = this.posicionInicial;

                        //this.funcion = "y(t) = "+c1+"e^("+(-constanteDeAmortiguamiento/(2*masa))+"t)"+c2+"t*e^("+(-constanteDeAmortiguamiento/(2*masa))+"t)";
                        this.funcion = "y(t) = e^("+(-this.lambda)+"t)*("+c1+"+"+c2+"*t)";
		} else{
			this.propiedades.setProperty("tipo", "Sub-amortiguado");

                        float alpha = (float) Math.sqrt(this.omega*this.omega-this.lambda*this.lambda);
			float beta = (float) Math.sqrt(this.omega*this.omega-this.lambda*this.lambda);

			this.c1 = this.posicionInicial;
			this.c2 = (this.velocidadInicial + this.lambda*this.posicionInicial)/beta;

                        Float temp = (float)((Math.sqrt(4*masa*constanteDelResorte-constanteDeAmortiguamiento*constanteDeAmortiguamiento))/(2*masa));
                        String teemp1;
                        try{
                            teemp1 = temp.toString().substring(0, 6);
                        }catch(Exception exp){
                            teemp1 = temp.toString();
                        }
                        this.funcion = "y(t) = e^("+(-constanteDeAmortiguamiento/(2*masa))+"t)*["+(c1+"cos("+teemp1+"t)")+"+"+(c2+"sin("+teemp1+"t)")+"]";
		}
	}
	
	public float y(float t){
		if (this.propiedades.getProperty("tipo").compareTo("Sobre-amortiguado")==0){
			float m1 = -lambda + (float) Math.sqrt(lambda*lambda-omega*omega);
			float m2 = -lambda - (float) Math.sqrt(lambda*lambda-omega*omega);
			
			this.c2 = (this.velocidadInicial-this.posicionInicial*m1)/(m2-m1);
			this.c1 = this.posicionInicial - this.c2;

                        return (float) (c1*Math.exp(m1*t)+c2*Math.exp(m2*t));
		} else if (this.propiedades.getProperty("tipo").compareTo("Criticamente amortiguado")==0){
			float m1 = -lambda + (float) Math.sqrt(lambda*lambda-omega*omega);
			this.c2 = this.velocidadInicial - this.posicionInicial*m1;
			this.c1 = this.posicionInicial;
			
			return (float) (Math.exp(-this.lambda*t)*(this.c1+this.c2*t));
		} else{
			float alpha = (float) Math.sqrt(this.omega*this.omega-this.lambda*this.lambda);
			float beta = (float) Math.sqrt(this.omega*this.omega-this.lambda*this.lambda);
			
			this.c1 = this.posicionInicial;
			this.c2 = (this.velocidadInicial + this.lambda*this.posicionInicial)/beta;
			
			
			return (float) (Math.exp(-this.lambda*t)*(this.c1*Math.cos(alpha*t)+this.c2*Math.sin(beta*t)));
		} 
	}
	
	public boolean esSobreAmortiguado(){
		return this.propiedades.getProperty("tipo").compareTo("Sobre-amortiguado")==0;
	}
	
	public boolean esCriticamenteAmortiguado(){
		return this.propiedades.getProperty("tipo").compareTo("Criticamente amortiguado")==0;
	}
	
	public boolean esSubAmortiguado(){
		return this.propiedades.getProperty("tipo").compareTo("Sub-amortiguado")==0;
	}
	
	public String getTipoDeMovimiento(){
		return this.propiedades.getProperty("tipo");
	}

    /**
     * @return the funcion
     */
    public String getFuncion() {
        return funcion;
    }
}

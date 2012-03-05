public class UsoGenerador
{
  public static void main (String[] args)
  {
      //Generator secuencia = new ConstantGenerator(5);
      Generator secuencia = new PrimeGenerator();

      for (int i=0; i<5; i++)
      {
         System.out.print(secuencia.get()+" ");
         secuencia.next();
      }
   
      System.out.println();
  }
   
}
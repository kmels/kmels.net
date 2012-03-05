public class ConstantGenerator extends AbstractGenerator
{
   public ConstantGenerator(int c)
   // pre: c is the value to be generated.
   // post: constructs a generator that returns a constant value
   {
        set(c);
   }


   public int next()
   // post: returns the constant value
   {
        return get();
   }
}
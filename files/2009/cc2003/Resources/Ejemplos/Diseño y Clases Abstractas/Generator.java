public interface Generator
{
   public void reset();
   // post: the generator is reset to the beginning of the sequence;
   // the current value can be immediately retrieved with get.

   public int next();
   // post: returns true iff more elements are to be generated.
   
   public int get();
   // post: returns the current value of the generator.
}
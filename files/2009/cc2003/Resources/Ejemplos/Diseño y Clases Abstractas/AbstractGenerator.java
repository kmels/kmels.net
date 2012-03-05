abstract public class AbstractGenerator
     implements Generator
{
    protected int current; // the last value saved

    public AbstractGenerator(int initial)
    // post: initialize the current value to initial
    {
        current = initial;
    }


    public AbstractGenerator()
    // post: initialize the current value to zero
    {
         this(0);
    }


    protected int set(Integer next)
    // post: sets the current value to next, and extends the sequence
    {
        int result = current;
        current = next;
        return result;
    }


    public int get()
    // post: returns the current value of the sequence
    {
        return current;
    }

    abstract public int next();
    
    
    public void reset()
    // post: resets the Generator (by default, does nothing)
    {
    }
}
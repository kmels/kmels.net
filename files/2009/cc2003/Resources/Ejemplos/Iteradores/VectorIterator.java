import java.util.Vector;

class VectorIterator <E> extends AbstractIterator <E>
{
    
    protected Vector<E> theVector; // el vector asociado
    protected int current;      // el elemento que se esta visitando

    
    public VectorIterator(Vector<E> v)
    {
	theVector = v;
	reset();
    }

   
    public void reset()
    {
	current = 0;
    }

    
    public boolean hasNext()
    {
	return current < theVector.size();
    }

   
    public E get()
    {
	return theVector.get(current);
    }
    
    
    public E next()
    {
	return theVector.get(current++);
    }

    
}  


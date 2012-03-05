import java.util.Enumeration;
import java.util.Iterator;


public abstract class AbstractIterator <E> 
 implements Enumeration<E>, Iterator<E>
{

   public AbstractIterator()
   {
   }

   public abstract void reset();
   // pre: iterator may be initialized or even amid-traversal
   // post: reset iterator to the beginning of the structure

   public abstract boolean hasNext();
   // post: true iff the iterator has more elements to visit

   public abstract E get();
   // pre: there are more elements to be considered; hasNext()
   // post: returns current value; ie. value next() will return

   public abstract E next();
   // pre: hasNext()
   // post: returns current value, and then increments iterator

   final public boolean hasMoreElements()
   // post: returns true iff there are more elements
   {
        return hasNext();
   }

   final public E nextElement()
   // pre: hasNext()
   // post: returns the current value and "increments" the iterator
   {
      return next();
   }

   public void remove()
   // pre: hasNext() is true and get() has not been called
   // post: the value has been removed from the structure
   {

   }
   
}
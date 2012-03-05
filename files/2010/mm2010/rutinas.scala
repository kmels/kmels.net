import math.abs

def NR(tolerancia:Double,seed:Double,f: Double => Double,f_ : Double => Double):Double = {
  val next:Double = seed-f(seed)/f_(seed)
  println(next)
  if (abs(next-seed)<tolerancia)
    next
  else
    NR(tolerancia,next,f,f_)
}

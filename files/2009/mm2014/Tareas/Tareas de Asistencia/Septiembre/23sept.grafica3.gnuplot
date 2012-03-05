set terminal table; set output "23sept.grafica3.table"; set format "%.5f"
set samples 25; plot [x=--10:10] -4*exp(-0.1*x)*sin(0.25*x)

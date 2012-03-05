set terminal table; set output "23sept.grafica2.table"; set format "%.5f"
set samples 25; plot [x=-1.5:9] -x*exp(-x/2)

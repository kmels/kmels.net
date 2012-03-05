set terminal table; set output "23sept.grafica1.table"; set format "%.5f"
set samples 25; plot [x=-1:7.5] 0.667*(exp(-2*x) - exp(-x/2))

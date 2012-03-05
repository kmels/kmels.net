set terminal table; set output "23sept.x.table"; set format "%.5f"
set samples 25; plot [x=-1:10] -x*exp(-x/2)

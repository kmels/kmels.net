

Grupo = SymmetricGroup(7);


def verificar(G,H):
    return G.order() == H[len(H)-1].order()

for n in range(1,20):
    G = SymmetricGroup(n)
    print verificar(G,G.normal_subgroups())

from sage.all import ∗
def str2vec(M, m): Vm= VectorSpace(GF(2), m)# Espacio vectorial Vm.
L=[cforcinM]# L=map(ord,L)# Representa L = map( Integer , L)# el mensaje M (ASCII) L = [k.str(base=2) for k in L] # como una L=[k.zfill(7)forkinL]# cadena L = reduce(lambda a,b: a+b, L) # de bits.
r = len(L) %m# L=L+(m−r)∗”0”# L=[L[m∗k:m∗(k+1)]\
    for k in range(len(L) / m)] # Representa la cadena L = map(list ,L)# de bits como una lista L = map(Vm,L)# de vectores en Vm. return L

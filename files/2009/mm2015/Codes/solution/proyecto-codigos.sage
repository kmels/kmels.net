import sagetex
sagetex.openout('proyecto-codigos')
sagetex.blockbegin()
try:
 sage: n = round(random()*10)
 sage: n
 9.0
 sage: G = SymmetricGroup(9)
 sage: G.order()
 362880
except:
 sagetex.goboom(149)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: H = G.normal_subgroups()
 sage: H
 [Permutation Group with generators [()],
  Permutation Group with generators [(2,3)(4,5), (2,4,3), (2,4,6,5,3), (2,5,3)(4,7,6), (2,8,7,4,5,6,3), (2,9,8,5,6,4,3), (1,3,2)],
  Permutation Group with generators [(1,2), (1,2,3,4,5,6,7,8,9)]]
except:
 sagetex.goboom(161)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: [subgrupo.order() for subgrupo in H]
 [1, 181440, 362880]
except:
 sagetex.goboom(168)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: G.order() == H[2].order()
 True
except:
 sagetex.goboom(175)
sagetex.blockend()
sagetex.blockbegin()
try:
 Grupo = SymmetricGroup(7);
 
 
 def verificar(G,H):
     return G.order() == H[len(H)-1].order()
 
 for n in range(1,20):
     G = SymmetricGroup(n)
     print verificar(G,G.normal_subgroups())
except:
 sagetex.goboom(190)
sagetex.blockend()
sagetex.blockbegin()
try:
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
 True
except:
 sagetex.goboom(213)
sagetex.blockend()
sagetex.blockbegin()
try:
 M = "Superfragilisticoespiralidoso"
except:
 sagetex.goboom(227)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: C = HammingCode(3,GF(2))
 sage: G = C.gen_mat()
 sage: H = C.check_mat()
 sage: Mv = str2vec(M,4)
 sage: Mv = [c*G for c in Mv]
 sage: Mv = [c + error_canal(7,1) for c in Mv]
 sage: Mv = [C.decode(c) for c in Mv]
 sage: Mv = [G.solve_left(c).list() for c in Mv]
 sage: Mhat = vec2str(Mv)
 sage: print M, '->', Mhat
 Superfragilisticoespiralidoso -> Superfragilisticoespiralidoso
 sage: print M==Mhat
 True
except:
 sagetex.goboom(245)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: C = HammingCode(3,GF(2))
 sage: G = C.gen_mat()
 sage: H = C.check_mat()
 sage: Mv = str2vec(M,4)
 sage: Mv = [c*G for c in Mv]
 sage: Mv = [c + error_canal(7,1) for c in Mv]
 sage: Mv = [C.decode(c) for c in Mv]
 sage: Mv = [G.solve_left(c).list() for c in Mv]
 sage: Mhat = vec2str(Mv)
 sage: print M==Mhat
 False
except:
 sagetex.goboom(263)
sagetex.blockend()
sagetex.endofdoc()

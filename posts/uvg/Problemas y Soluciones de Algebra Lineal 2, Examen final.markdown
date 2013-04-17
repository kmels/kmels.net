---
title: Solución de mi exámen final (Algebra lineal 2)
author: Carlos Lopez
date: November 24, 2011
lang: es
tags: algebra-lineal, uvg
---

1. Problemas de calentamiento:

     a. Supóngase que $D$ denota un operador derivación. Demuestre que $D^n$ es una transformación lineal y también que $p(D)$ es una transformación lineal si $p(D)$ es un polinomio en $D$ con coeficientes constantes.


          * $D^n$ es T.L, considerando que es la repetición de aplicar el operador lineal $D$ a un vector:

            $D^n (\alpha x + \beta y) = \underbrace{D \circ D \circ \dots D}_\text{n veces} (\alpha x + \beta y)$
                 
            $= \underbrace{D \circ D \circ \dots D}_\text{n-1 veces} \Big( \alpha D(x) + \beta D(y)) \Big)$

            $\dots$

            $= D \Big( \alpha \big ( \underbrace{D \circ D \dots D}_\text{n-1 veces} (x) \big)  + \beta \big ( \underbrace{D \circ D \dots D}_\text{n-1 veces} (y) \big) \Big)$

            $= \alpha \Big( \underbrace{D \circ D \circ \dots D}_\text{n veces} (x) \Big) + \beta \Big( \underbrace{D \circ D \circ \dots D}_\text{n veces} (y) \Big)$

          * Lema 1: La suma de transformaciones lineales es una transformación lineal

            Sean $T,U$ transformaciones lineales, entonces:
            
            $(T+U)(\alpha x y) = T(\alpha x + \beta y) + U(\alpha x + \beta y)$

            $= \alpha T(x) + \beta T(y) + \alpha U(x) + \beta U(y)$

            $= \alpha \Big(T(x) + U(x) \Big) + \beta \Big( T(x) + U(y) \Big)$

            $= \alpha \Big( (T+U) (x) \Big) + \beta \Big( (T+U) (y)) \blacksquare$.                      
                
          * Lema 2: Las transformaciones lineales son asociativas con respecto a la composición de funciones

            Ver inciso 4.b para la demostración.

          * $p(D)$ es T.L

            Sea $p(x) = \alpha_1 x^n + \dots + \alpha_n x^0$. Entonces $p(D) = \alpha_1 D^n + \dots + \alpha_n D^0$. Por el Lema 1, Lema 2 y dado que $D^n$ es T.L, $p(D)$ es una T.L.

     b.  Pruebe que, si una matriz $A$ satisface el polinomio $x^2 + x + 1=0$, entonces A es invertible.

          * Demostración:

            $A^2 + A + I = 0$
 
            $\implies A^2 + A = -I$

            $\implies A(A + I) = -I$

            $\implies det(A(A+I)) = det(-I)$

            $\implies det(A)\cdot det(A+I) = det(-I)$ 

            $\implies det(A) \neq 0$, ya que $det(-I) \neq 0$

	    Es decir, $A$ es **no singular** o **invertible** $\blacksquare$.

     c. Sea $A$ una matriz diagonal $nxn$ sobre el campo $F$, es decir, una matriz para la cual $a_{ij}=0$ cuando $i$ es diferente de $j$. Sea $f$ el polinomio sobre $F$ definido por $f = (x-a_{11}) \dots (x-a_{nn})$. ¿Cuál es la matriz $f(A)$?


          $f(A)$ es la matriz cuya determinante y traza son polinomios cuyas raíces son eigenvalores de $A$.

2. Sean $A$ y $B$ operadores lineales sobre un espacio vectorial complejo $E$ de dimensión finita:

     a.  Pruebe que existe al menos un eigenvalor de $A$ entre las raíces de un polinomio cualquiera anulado por $A$.

          * Demostración:

            Sea $p$ el polinomio anulado por $A$, es decir $p(A) = 0$. Además, si $\lambda$ una raíz de $p$, es decir $p(\lambda) = 0$, $p(x) = (x - \lambda) q(x)$ y $q(x) \neq 0$, entonces:
	    
            $\(A - \lambda I) q(A) = 0$
	    
            $\implies A q(A) - \lambda I q(A) = 0$
	    
            $\implies A q(A) = \lambda q(A)$

            O bien, $\lambda$ es un eigenvalor de $A$ y $q(A)$ es su eigenvector relacionado $\blacksquare$.

     b. Demuestre que el espectro de todo operador sobre $E$ es no vacío.

          * Si $T$ es un operador sobre $E$, el polinomio característico de $TE$ tiene soluciones, pues es sobre los complejos.

     c. Pruebe que el espectro de un operador $A$ coincide con el conjunto de raíces del polinomio mínimo.

     d. Suponga que $p$ es un polinomio. Sabemos que si $\lambda$ es un eigenvalor de $A$, entonces $p(\lambda)$ es un eigenvalor de $p(A)$. ¿Qué se puede decir del converso?

          * No se cumple, contraejemplo:

              Sea $A = 2I = \left[\begin{array} 2 & 0 \\ 0 & 2 \end{array}\right]$ y $p(x) = x^2$. Entonces

              $p(A) = A^2 = AA = 4I$, y el espectro de $p(A)$, $e_{p(A)} = \{4\}$

              Notemos que $p(-2) = (-2)(-2) = 4$ es un eigenvalor de $p(A)$, pero $-2$ no es eigenvalor de $A \blacksquare$.

     e. ¿Tienen siempre $AB$ y $BA$ el mismo espectro? 

3. Supóngase que $U$ y $V$ son espacios vectoriales y $T$ una transformación lineal del espacio $U$ en el espacio $V$.

     a. En el caso que $U$ y $V$ sean de dimensión finita y que $T$ sea un isomorfismo de espacios vectoriales, debe existir $T^{-1}$. ¿Es $T^{-1}$ una transformación lineal de $V$ en $U$?

     
          * Sí, demostración:

            Sean $v,w \in U$. 

            Sabemos que $T(\alpha_1 v + \beta_1 w) = \alpha_1 T(v) + \beta_2 T(w)$. 

            Denotemos a $V = T(v)$ y $W = T(w)$ como vectores de $V$ y consideremos $R = T^{-1} (\alpha_2 V + \beta_2 W)$

            Como $T$ es un operador líneal, 
	    
            $R = T^{-1}(\alpha_2 T(v) + \beta_2 T(w)) = T^{-1}(T(\alpha_2 v + \beta_2 w))$
	    
            Y dado que $T^{-1}$ es la transformación inversa de $T$,
	    
            $R = \alpha_2 v + \beta_2 w = \alpha_2 T^{-1}(V) + \beta_2 T^{-1}(W)$
	 
	    O bien, $T^{-1}$, también es una transformación líneal $\blacksquare$.

     b. ¿Cómo cambia su respuesta en el caso en que $U$ y $V$ sean de dimensión infinita?

          No cambia, pues mi demostración no considera de que dimensión son los espacios vectoriales.

     c. ¿Qué condiciones deben existir para estudiar la continuidad de $T$?

        * El dominio $V$ y el codominio $W$ de $T$ tienen que ser iguales y tienen que ser espacios topológicos.

            * Un espacio vectorial es topológico sobre un campo topológico $K$ si la adición de vectores $V x V \rightarrow V$ y la multiplicación de un vector por un escalar $K x X \rightarrow X$ son funciones continuas.

                * Una función $f: X \rightarrow Y$ es continua si para cada conjunto $V \subseteq Y$, el inverso de la imágen $f^{-1}(V) = \{ x \in X | f(x) \in V\}$ es un subconjunto de $X$.

                
4. Sea $F$ un campo. Un **álgebra lineal sobre el campo $F$** es un espacio vectorial $A$ sobre $F$ con otra operación, llamada multiplicación de vectores, que asocia a cada par de vectores $\alpha$, $\beta$ de $A$ un vector $\alpha \beta$ en $A$ llamado el producto de $\alpha$ y $\beta$, de tal modo que:

     - La multiplicación es asociativa
     - La multiplicación es distributiva con respecto a la adición $\alpha (\beta + \gamma) = \alpha \beta + \alpha \gamma$, y $(\alpha + \beta) \gamma = \alpha \gamma + \beta \gamma$
     - Para todo escalar $c$ de $F$, $c(\alpha \beta) = \alpha (c \beta) = (c \alpha) \beta$
     
     a. Demuestre que el conjunto de matrices de $nxn$ sobre un campo, con las operaciones usuales, es un álgebra líneal.
         
         Sean $A,B$ matrices y $\alpha$ un escalar del campo $F$, entonces se cumple:

         * Asociatividad

            $A(BC)_{ij} = \sum_k A_{ik} (BC)_{kj}$

            $= \sum_k A_{ik} (\sum_l B_{kl}C_{lj})$

            $= \sum_k \sum_l A_{ik} B_{kl}C_{lj}$

            $= \sum_l (\sum_k A_{ik} B_{kl}) C_{lj}$

            $= \sum_l (AB)_{il} C_{lj}$

            $= (AB)C_{ij}$
            

         * Distributividad de la multiplicación con respecto a la adición
         
            $A(B+C)_{ij} = \sum_k A_{ik}(B+C)_{kj}$

            $= \sum_k A_{ik} (B_{kj} + C_{kj})$

            $= \sum_k A_{ik}B_{kj} + A_{ik}C_{kj}$

            $AB + AC$

         * Para todo escalar $\alpha$ de $F$, $\alpha (AB) = A (\alpha B) = (\alpha A) B$

            Denotemos a $M = \alpha (AB)$, entonces:

            $M_{ij} = \alpha (AB)_{ij}$

            $= \alpha (\sum_k A_{ik}B_{kj})$

            $= \sum_k A_{ik} (\alpha B_{kj})$

            $= A(\alpha B)$

            $= \sum_k A_{ik} (\alpha B_{kj})$

            $= \sum_k (\alpha A_{ik}) B_{kj}$

            $= (\alpha A) B$

         Por lo tanto, el conjunto de matrices $nxn$ sobre un campo, con las operaciones usuales, es un álgebra líneal $\blacksquare$.

     b. Demuestre que el espacio de todas las transformaciones líneales sobre un espacio vectorial, con la composición como producto, es un álgebra líneal.

        Sean $T,R,S$ transformaciones lineales y $\alpha$ un escalar del campo $F$.

        * Asociatividad

            $\Big(T \circ (R \circ S)\Big)\Big(x\Big) = T \circ \Big((R \circ S)(x)\Big)$
            
            $=T \circ \Big(R\big(S(x)\big)\Big)$

            $=T\Big(R\big(S(x)\big)\Big)$

            $=\big(T \circ R\big)\big(S(x)\big)$

            $=\Big((T \circ R)\circ S \Big)\Big(x\Big)$

        * Distributividad de la multiplicación con respecto a la adición

            $\Big(T \circ (R + S)\Big)\Big( x \Big) = T \Big((R + S)(x)\Big)$

            $=T \Big(R(x) + S(x)\Big)$

            $=T\Big(R(x) + S(x)\Big)$, $T$ es una T.L.

            $=(T \circ R) (x) + (T \circ S)(x)$

            $=(T \circ R + T \circ S) (x)$

        * Para todo escalar $\alpha$ de $F$, $\alpha (T \circ R) = T \circ (\alpha R) = (\alpha T) \circ R$

            $\alpha \Big((T \circ R)(x)\Big)$

            $=\alpha T \Big(R(x)\Big)$

            $=\Big((\alpha T) \circ R\Big)\Big(x\Big)$
            
            $=\alpha T\Big(R(x)\Big)$

            $=T\Big(\alpha\big(R(x)\big)\Big)$

            $=\Big(T \circ (\alpha R)\Big)\Big(x\Big)$

        Por lo tanto, el conjunto de transformaciones lineales sobre un espacio vectorial es un álgebra líneal con la operación composición como producto $\blacksquare$.
                
5. Una transformación líneal $A$ es **nilpotente** si existe un entero positivo $q$ tal que $A^q = 0$. El menor entero que cumple esta propiedad se denomina **índice de nilpotencia**.
   
     a. ¿Existe una transformación nilpotente de índice 3 sobre un espacio vectorial de dimensión 2?
     
     b. Pruebe que una transformación líneal nilpotente sobre un espacio vectorial finito-dimensional tiene traza cero.

     c. Demuestre que si $A$ y $B$ son transformaciones lineales (sobre el mismo espacio vectorial finito-dimensional) y si $C = AB - BA$, entonces $I-C$ no es nilpotente.


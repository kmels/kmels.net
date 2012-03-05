import sagetex
sagetex.openout('proyecto-rsa')
sagetex.blockbegin()
try:
 sage: factor(18)
 2 * 3^2
 sage: factor(27)
 3^3
except:
 sagetex.goboom(145)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: gcd(18,27)
 9
except:
 sagetex.goboom(152)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: factor(11)
 11
 sage: factor(17)
 17
except:
 sagetex.goboom(161)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: gcd(11,17)
 1
except:
 sagetex.goboom(167)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: factor(32)
 2^5
 sage: factor(45)
 3^2 * 5
except:
 sagetex.goboom(177)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: gcd(32,45)
 1
except:
 sagetex.goboom(183)
sagetex.blockend()
sagetex.blockbegin()
try:
 #find primes
 p1set = False;  p2set = False
 reversedPrimes = list(reversed(list(primes(80)))) #len(str(2^80)) is large enough
 i = 0
 while not p2set:
     prime = reversedPrimes[i]
     pnumber = 2**prime -1
 
     if is_prime(pnumber):
         if p1set:
             p2 = pnumber
             print 'retorno'
             p2set = True
         else:
             p1 = pnumber
             p1set = True
     i+=1
except:
 sagetex.goboom(215)
sagetex.blockend()
sagetex.blockbegin()
try:
 euler_phi(n)
except:
 sagetex.goboom(221)
sagetex.blockend()
sagetex.blockbegin()
try:
 def get_e(phi):
     e = 2
     while gcd(e,phi)!=1:
         e +=1
     return e
except:
 sagetex.goboom(231)
sagetex.blockend()
sagetex.blockbegin()
try:
 def get_d(e,phi):
     return inverse_mod(e,phi)
except:
 sagetex.goboom(246)
sagetex.blockend()
sagetex.blockbegin()
try:
 def get_rsa_number_encryption(m,publicKey):
     e = publicKey[1]
     n = publicKey[0]
     return power_mod(m,e,n)
except:
 sagetex.goboom(264)
sagetex.blockend()
sagetex.blockbegin()
try:
 def get_rsa_number_decryption(c,privateKey):
     n = privateKey[0]*privateKey[1]
     d = privateKey[2]
     return power_mod(c,d,n)
except:
 sagetex.goboom(273)
sagetex.blockend()
sagetex.blockbegin()
try:
 def message_to_ascii_representation(message):
     ascii_rep = ""
     for character_index in range(0,len(message)):
         character = message[character_index]
         ascii_rep += str(ord(character))
 
     return int(ascii_rep)
except:
 sagetex.goboom(294)
sagetex.blockend()
sagetex.blockbegin()
try:
 def ascii_representation_to_message(ascii_rep):
     ascii_rep = str(ascii_rep)
     mssg = ""
     for hasta in range(0,len(ascii_rep),2):
         ord = int(ascii_rep[hasta:hasta+2])
         mssg += chr(ord)
     return mssg
except:
 sagetex.goboom(309)
sagetex.blockend()
sagetex.blockbegin()
try:
 sage: private_key
 (2305843009213693951, 2147483647, 4077920125612805357425763753)
 sage: desencriptado = get_rsa_number_decryption(4175976697833683195181896730,private_key)
 sage: desencriptado
 80856772736765
 sage: ascii_representation_to_message(desencriptado)
 'PUCHICA'
except:
 sagetex.goboom(330)
sagetex.blockend()
sagetex.endofdoc()

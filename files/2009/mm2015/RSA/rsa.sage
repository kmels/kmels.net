# Finding large primes:
# http://math.usask.ca/encryption/lessons/lesson09/page1.html

#p1 = 13842607235828485645766393;
#p2 = 618970019642690137449562111;

#find primes
p1set = False
p2set = False
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

print "p1: ", p1
print "p2: ", p2

n=p1*p2;
phi = euler_phi(n)

def get_e(phi):
    e = 2
    while gcd(e,phi)!=1:
        e +=1 
    return e

e = get_e(phi)
print "e: ",e

#Algoritmo de euclides extendido: calcula el gcd extendido
def get_d(e,phi):
    return inverse_mod(e,phi)
    d = 1
    while d*e % phi != 1:
        d +=1 
    return d

d = get_d(e,phi)
print "d: ", d
public_key = (n,e)
print "public key: ", public_key

def get_rsa_number_encryption(m,publicKey):
    e = publicKey[1]
    n = publicKey[0]
    return power_mod(m,e,n)
    return m**e % n

private_key = (p1,p2,d)

def get_rsa_number_decryption(c,privateKey):
    n = privateKey[0]*privateKey[1]
    d = privateKey[2]
    return power_mod(c,d,n)

def message_to_ascii_representation(message):
    ascii_rep = ""
    for character_index in range(0,len(message)):
        character = message[character_index]
        ascii_rep += str(ord(character))
    
        return int(ascii_rep)

def encrypt_message_rsa(message,publicKey):
    m = message_to_ascii_representation(message)
    c = get_rsa_number_encryption(m,publicKey) #encrypt the encoded message

    return c
    #show the user something cool i.e. not a number
    #asciirep_of_the_encrypted_message = ascii_representation_to_message(c)
    #asciirep = message_to_ascii_representation(message) 
    #asciirep_encrypted = get_rsa_number_encryption(asciirep,publicKey)
    return ascii_representation_to_message(asciirep_encrypted)
    
def ascii_representation_to_message(ascii_rep):
    ascii_rep = str(ascii_rep)
    mssg = ""
    for hasta in range(0,len(ascii_rep),2):
        ord = int(ascii_rep[hasta:hasta+2])
        mssg += chr(ord)
    return mssg

def decrypt_message_rsa(encryptedMessage,privateKey):
    c = message_to_ascii_representation(encryptedMessage)
    print "paso 1"
    m = get_rsa_number_decryption(c,privateKey)
    print "m es ", m
    print "paso 2"
    return ascii_representation_to_message(m)

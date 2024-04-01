#!/bin/bash

# Extended Rövarspråket [1] encryption/decryption algorithm.
# Also implemented recursive variants RövN where the algorithm is 
# applied N times. To get acceptable encryption also of numbers even
# they are treated as "consonants" in the original logic.
#
# For natural reasons the ciphertext lends itself well to compression, which
# is why the tool implements the RövN+GZIP variant.
#
# In the application domain of young detectives we recommend using 
# the Röv24+GZIP for a good security/performance/space/memory tradeoff.
# 
# Prerequisites: GNU sed as `gsed`, gzip
#
# * [1] https://en.wikipedia.org/wiki/R%C3%B6varspr%C3%A5ket

röv1_encrypt () {
  gsed -E 's/([BCDFGHJKLMNPQRSTVXZbcdfghjklmnpqrstvxz02468])/\1o\1/g'
}

röv1_decrypt () {
  # GNU Sed
  gsed -E 's/([BCDFGHJKLMNPQRSTVXZbcdfghjklmnpqrstvxz02468])o\1/\1/g'
}

rövN_encrypt () {
  N="$1"

  N_SUB="$(( $N - 1 ))"
  if [[ "$N_SUB" == "0" ]]; then 
    röv1_encrypt
  else 
    röv1_encrypt | rövN_encrypt $N_SUB
  fi
} 

rövN_decrypt () {
  N="$1"

  N_SUB="$(( $N - 1 ))"
  if [[ "$N_SUB" == "0" ]]; then 
    röv1_decrypt
  else 
    röv1_decrypt | rövN_decrypt $N_SUB
  fi
  
} 

N="1"
mode=""
zip="false"

usage() {
  echo "Usage: rov.sh [-e|--encrypt] [-d|--decrypt] [-n|--num-passes NUM_PASSES=1] [-z|--gzip]"
  echo
  echo "Reads from stdin and outputs to stdout. "
}

while [ $# -gt 0 ] 
do 
  case "$1" in 
    -d|--decrypt) mode="decrypt" ;; 
    -e|--encrypt) mode="encrypt" ;;
    -n|--num-passes) N="$2"; shift ;; 
    -z|--gzip) zip="true"; shift ;; 
    -h) usage ; exit 0 ;;
    *) echo "Unknown option: $1" ; usage ; exit 1;; 
  esac
  shift 
done

if [[ "$mode" == "" ]]; then
 usage; exit 1; 
fi

if [[ "$zip" == "true" ]]; then
  if [[ "$mode" == "encrypt" ]]; then 
    rövN_encrypt $N | gzip
  else
    gzip -d | rövN_decrypt $N
  fi 
else 
  if [[ "$mode" == "encrypt" ]]; then 
    rövN_encrypt $N
  else
    rövN_decrypt $N
  fi 
fi
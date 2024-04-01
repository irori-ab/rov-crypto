# Röv-crypto

*A crypto algorithm for the requirements of today*

## Background

An extended [Rövarspråket](https://en.wikipedia.org/wiki/R%C3%B6varspr%C3%A5ket) encryption/decryption algorithm. To get acceptable encryption also of numbers even they are treated as "consonants" in the original logic. Also implemented are recursive variants RövN where the algorithm is applied in N passes.

## Examples

```bash
# encoding
$ echo rövarspråket | ./rov.sh -e -n 1
rorövovarorsospoproråkoketot

# decoding
$ echo rorövovarorsospoproråkoketot | ./rov.sh -d -n 1
rövarspråket

# many passes
$ time echo  $(echo röv | ./rov.sh -e -n 24 | ./rov.sh -d -n 24)
röv

real	1m19.311s
user	1m18.907s
sys	0m0.654s

# gzip payload compression
rov-crypto $ echo röv | ./rov.sh -e -n 16 | wc -c
  262145
rov-crypto $ echo röv | ./rov.sh -e -n 16 -z  | wc -c
     300
```


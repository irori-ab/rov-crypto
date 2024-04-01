# Röv-crypto

*A crypto algorithm for the requirements of today*

## Background

An extended [Rövarspråket](https://en.wikipedia.org/wiki/R%C3%B6varspr%C3%A5ket) encryption/decryption algorithm. To get acceptable encryption also of numbers, even digitsgit st are treated as "consonants" in the original logic. Also implemented are recursive variants Röv-N (`-n N`) where the algorithm is applied in N passes.

For natural reasons the ciphertext lends itself well to compression, which
is why the tool implements the Röv-N+GZIP variant (`-z`).

## Pre-requisites

* GNU sed as `gsed`
  * Should be default in Debian based Linuxes (Ubuntu, ...): `export ROV_GSED=sed` 
  * MacOS: `brew search gnu-sed`
* `gzip` (if using compression option)

## Examples

```bash
# usage
$ ./rov.sh -h
Usage: rov.sh [-e|--encrypt] [-d|--decrypt] [-n|--num-passes NUM_PASSES=1] [-z|--gzip]

Reads from stdin and outputs to stdout.

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


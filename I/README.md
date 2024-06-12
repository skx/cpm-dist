# I: Instruction Tester

The I-drive contains the [Z80 Instruction Exerciser](https://mdfs.net/Software/Z80/Exerciser/),
as distributed from the author.

Expected output would look something like this:

```
A>zexall
Z80all instruction exerciser
<adc,sbc> hl,<bc,de,hl,sp>....  OK
add hl,<bc,de,hl,sp>..........  OK
add ix,<bc,de,ix,sp>..........  OK
add iy,<bc,de,iy,sp>..........  OK
aluop a,nn....................  OK
aluop a,<b,c,d,e,h,l,(hl),a>..  OK
aluop a,<ixh,ixl,iyh,iyl>.....  OK
aluop a,(<ix,iy>+1)...........  OK
...
```

Additionally there is a small program to identify the CPU and confirm the R-register can be used as a source of randomness:

* `RNDTST.ASM`
  * Source code.
* `RNDTST.COM`
  * Binary.

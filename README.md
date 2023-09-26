# mips
Pour la calculatrice:

- $t0 pour le res
- $t1 pour l'adresse du string
- $t2 le cpt pour savoir si string fini
- $t3 l'adresse de la fin de la stack
- $t4-$t7 pour load des bits et effectuer calculs depuis la stack
1) fonction qui demande et stock le string dans la memoire, garde l'adresse en $t1
2) fonction qui lit bit a bit et si
    - si "p" alors print le res
    - si op alors appelle fonction de calcul correspondante
    - si n alors le transformer en int et le stocker dans la pile
2bis) calcul jusqu'a la "fin" de la pile en fonction de op

Plus tard: changer le 2) en rajoutant les espaces pour avoir en dessus de 9

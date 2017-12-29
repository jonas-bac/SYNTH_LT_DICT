# SYNTH_LT_DICT
Sintetinių lietuvių kalbos naujadarų žodynas

---------------
failai:
Naujadarus generuojantis R script'as: **zodyno_sintezatorius.R**
input: lietuvių kalbos žodynas **lt-LT.dic.RData**

metodas:
Sintezėje naudojami empiriniai raidžių ir dviraidžių slinkties dažniai (state transition matrix) bei Markov chain modelis. Modelis mokomas tik lietuviškais daiktavardžiais (be tarptautinių/farmacinių terninų).

pavyzdys:
Žodis **OBUOLYS** išskaidomas į dvi aibes: 1) **OB**, **UO**, **LY**, **S**; 2) **O**, **BU**, **OL**, **YS**. Analogiškai išskaidomi ir kiti (~40k) žodžių. Apskaičiuojama empirinė tikimybė, kad dviraidį **OB** seks **UO** ir tt. 




element_k(X, L, K) :- L = [X | _], K = 1.
element_k(X, L, K) :- L = [_ | T], element_k(X, T, Y), K is Y + 1.

make :- consult('../dictionnaire/mot.pl'), consult('../dictionnaire/terminaison.pl'), consult('../dictionnaire/conjugaison.pl').



ph(arbre_phrase(GN, SV)) --> gn(Personne1, GN), suite_verbale(Personne2, SV), {concordance(Personne1, Personne2)}.

ph(arbre_phrase(syntagme_nominal(GN1, liaison(et), GN2), SV)) --> gn(3, GN1), [et], gn(3, GN2), suite_verbale(6, SV).

ph(arbre_phrase(syntagme_nominal(GN1, liaison(ou), GN2), SV)) --> gn(3, GN1), [ou], gn(3, GN2), suite_verbale(3, SV).

suite_verbale(Personne, syntagme_verbale(GV)) --> gv(Personne, GV).
suite_verbale(Personne, syntagme_verbale(GV, GN)) --> gv(Personne, GV), gn(_, GN).
suite_verbale(Personne, syntagme_verbale(GV, C, PH)) --> gv(Personne, GV), coordination(C), ph(PH).
suite_verbale(Personne, syntagme_verbale(GV, GA)) --> gv(Personne, GV), adverbe(GA).
suite_verbale(Personne, syntagme_verbale(GV, GA, GN)) --> gv(Personne, GV), adverbe(GA), gn(_, GN).
suite_verbale(Personne, syntagme_verbale(GV, GA, C, PH)) --> gv(Personne, GV), adverbe(GA), coordination(C), ph(PH).
suite_verbale(Personne, syntagme_verbale(GV, GA)) --> gv(Personne, GV), suite_adverbe(GA).
suite_verbale(Personne, syntagme_verbale(GV, GA, GN)) --> gv(Personne, GV), suite_adverbe(GA), gn(_, GN).
suite_verbale(Personne, syntagme_verbale(GV, GA, C, PH)) --> gv(Personne, GV), suite_adverbe(GA), coordination(C), ph(PH).

gn(Personne, syntagme_nominal(article(Article), SN)) --> [Article], suite_nominale_adjectif(Personne, SN), {analyse(Article, _, article, _, Personne)}.

suite_nominale(Personne, nom(Nom)) --> [Nom], {analyse(Nom, _, nom, _, Personne)}.
suite_nominale(Personne, syntagme_nominal(nom(Nom), SN)) --> [Nom], suite_nominale_nom(Personne, SN),  {analyse(Nom, _, nom, _, Personne)}.

suite_nominale_nom(Personne, adjectif(Adjectif)) --> [Adjectif], {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_nom(Personne, SNA) --> suite_adjectif(Personne, SNA).
suite_nominale_nom(Personne, R) --> relative(Personne, R).
suite_nominale_nom(Personne, syntagme_nominal(adjectif(Adjectif), R)) --> [Adjectif], relative(Personne, R), {analyse(Adjectif, _, adjectif, _, Personne)}.

suite_nominale_adjectif(Personne, SN) --> suite_nominale(Personne, SN).
suite_nominale_adjectif(Personne, syntagme_nominal(adjectif(Adjectif), SN)) --> [Adjectif], suite_nominale(Personne, SN), {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_adjectif(Personne, syntagme_nominal(adjectif(Adjectif1), adjectif(Adjectif2), SN)) --> [Adjectif1], [Adjectif2], suite_nominale(Personne, SN), {analyse(Adjectif1, _, adjectif, _, Personne), analyse(Adjectif2, _, adjectif, _, Personne)}.
suite_nominale_adjectif(Personne, syntagme_nominal(SNA, SN)) --> suite_adjectif(Personne, SNA), suite_nominale(Personne, SN).

suite_adjectif(Personne, syntagme_adjectival(adjectif(Adjectif1), coordination(et), adjectif(Adjectif2))) --> [Adjectif1], [et], [Adjectif2], {analyse(Adjectif1, _, adjectif, _, Personne), analyse(Adjectif2, _, adjectif, _, Personne)}.
suite_adjectif(Personne, syntagme_adjectival(adjectif(Adjectif), SNA)) --> [Adjectif], suite_adjectif(Personne, SNA), {analyse(Adjectif, _, adjectif, _, Personne)}.

suite_adverbe(syntagme_adverbiale(arbre_adverbe(Adverbe1), coordination(et), arbre_adverbe(Adverbe2))) --> [Adverbe1], [et], [Adverbe2], {analyse(Adverbe1, _, adjectif, _, 5), analyse(Adverbe2, _, adjectif, _, 5)}.
suite_adverbe(syntagme_adverbiale(arbre_adverbe(Adverbe), SA)) --> [Adverbe], suite_adverbe(SA), {analyse(Adverbe, _, adjectif, _, 5)}.


relative(Personne, relative(relatif(Relative), SV)) --> [Relative], suite_verbale(Personne_verbale, SV), {analyse(Relative, _, relative, _, _), concordance(Personne, Personne_verbale)}.

coordination(arbre_coordination(Coordination)) --> [Coordination], {analyse(Coordination, _, coordination, _, _)}.

gv(Personne, verbe(Verbe)) --> [Verbe], {analyse(Verbe, _, verbe, _, Personne)}.

adverbe(arbre_adverbe(Adverbe)) --> [Adverbe], {analyse(Adverbe, _, adjectif, _, 5)}.

analyse(Mot, MotCanonique, Categorie, Groupe, Personne) :-
  name(Mot,LMot),
  append(Racine, Terminaison,LMot),
	mot(MotCanonique, Categorie, Conjugaison, Racine, NumRacine),
	conjugaison(Conjugaison, Groupe, NomTerminaison, Liste),
	element_k(NumRacine, Liste, Personne),
	terminaison(NomTerminaison, Terminaison, Personne),
	append(Racine, Terminaison, L),
	name(Mot, L).

concordance(1, 3).
concordance(3, 3).
concordance(2, 6).
concordance(4, 6).

element_k(X, L, K) :- L = [X | _], K = 1.
element_k(X, L, K) :- L = [_ | T], element_k(X, T, Y), K is Y + 1.

make :- consult('../dictionnaire/mot.pl'), consult('../dictionnaire/terminaison.pl'), consult('../dictionnaire/conjugaison.pl').



ph --> gn(Personne1, Sujet), suite_verbale(Personne2), {concordance(Personne1, Personne2)}.

suite_verbale(Personne) --> gv(Personne).
suite_verbale(Personne) --> gv(Personne), gn(_).
suite_verbale(Personne) --> gv(Personne), coordination, ph.

gn(Personne, Sujet) --> [Article], suite_nominale_adjectif(Personne, Sujet), {analyse(Article, _, article, _, Personne)}.

suite_nominale(Personne, Nom) --> [Nom], {analyse(Nom, _, nom, _, Personne)}.
suite_nominale(Personne, Nom) --> [Nom], suite_nominale_nom(Personne),  {analyse(Nom, _, nom, _, Personne)}.

suite_nominale_nom(Personne) --> [Adjectif], {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_nom(Personne) --> relative(Personne).
suite_nominale_nom(Personne) --> [Adjectif], relative(Personne), {analyse(Adjectif, _, adjectif, _, Personne)}.

suite_nominale_adjectif(Personne, Sujet) --> suite_nominale(Personne, Sujet).
suite_nominale_adjectif(Personne) --> [Adjectif], suite_nominale(Personne, Sujet), {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_adjectif(Personne) --> [Adjectif1], [Adjectif2], suite_nominale(Personne, Sujet), {analyse(Adjectif1, _, adjectif, _, Personne), analyse(Adjectif2, _, adjectif, _, Personne)}.

relative(Personne) --> [Relative], suite_verbale(Personne_verbale), {analyse(Relative, _, relative, _, _), concordance(Personne, Personne_verbale)}.

coordination --> [Coordination], {analyse(Coordination, _, coordination, _, _)}.

gv(Personne) --> [Verbe], {analyse(Verbe, _, verbe, _, Personne)}.

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
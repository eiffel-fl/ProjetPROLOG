element_k(X, L, K) :- L = [X | T], K = 1.
element_k(X, L, K) :- L = [H | T], element_k(X, T, Y), K is Y + 1.

make :- consult('mot.pl'), consult('terminaison.pl'), consult('conjugaison.pl').


ph --> gn(Personne1), gv(Personne2), coordination, ph, {concordance(Personne1, Personne2)}.

ph --> gn(Personne1), gv(Personne2), {concordance(Personne1, Personne2)}.

ph --> gn(Personne1), gv(Personne2), gn(_), {concordance(Personne1, Personne2)}.

gn(Personne) --> [Article], [Nom], {analyse(Article, _, article, _, Personne), analyse(Nom, _, nom, _, Personne)}.

gn(Personne) --> [Article], [Nom],  [Adjectif], {analyse(Article, _, article, _, Personne), analyse(Nom, _, nom, _, Personne), analyse(Adjectif, _, adjectif, _, Personne)}.

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

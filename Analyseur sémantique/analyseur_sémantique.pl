element_k(X, L, K) :- L = [X | _], K = 1.
element_k(X, L, K) :- L = [_ | T], element_k(X, T, Y), K is Y + 1.

make :- consult('../dictionnaire/mot.pl'), consult('../dictionnaire/terminaison.pl'), consult('../dictionnaire/conjugaison.pl'), consult('../dictionnaire/ontologie.pl').



ph --> gn(Personne1, Sujet), suite_verbale(Personne2, Verbe, Complément), {concordance(Personne1, Personne2), evaluer(Verbe, Sujet, Complément)}.

evaluer(Verbe, Sujet, Complément) :- nonvar(Complément), Z =.. [Verbe, Sujet, Complément], call(Z).

evaluer(Verbe, Sujet, Complément) :- var(Complément), Z =.. [Verbe, Sujet], call(Z).

suite_verbale(Personne, Verbe, _) --> gv(Personne, Verbe).
suite_verbale(Personne, Verbe, Complément) --> gv(Personne, Verbe), gn(_, Complément).
suite_verbale(Personne, Verbe, _) --> gv(Personne, Verbe), coordination, ph.

gn(Personne, Sujet) --> [Article], suite_nominale_adjectif(Personne, Sujet), {analyse(Article, _, article, _, Personne)}.

suite_nominale(Personne, NomC) --> [Nom], {analyse(Nom, NomC, nom, _, Personne)}.
suite_nominale(Personne, NomC) --> [Nom], suite_nominale_nom(Personne, Verbe),  {analyse(Nom, NomC, nom, _, Personne), Z =.. [Verbe, Nom, _], call(Z)}.

suite_nominale_nom(Personne, _) --> [Adjectif], {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_nom(Personne, Verbe) --> relative(Personne, Verbe).
suite_nominale_nom(Personne, Verbe) --> [Adjectif], relative(Personne, Verbe), {analyse(Adjectif, _, adjectif, _, Personne)}.

suite_nominale_adjectif(Personne, Sujet) --> suite_nominale(Personne, Sujet).
suite_nominale_adjectif(Personne, Sujet) --> [Adjectif], suite_nominale(Personne, Sujet), {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_adjectif(Personne, Sujet) --> [Adjectif1], [Adjectif2], suite_nominale(Personne, Sujet), {analyse(Adjectif1, _, adjectif, _, Personne), analyse(Adjectif2, _, adjectif, _, Personne)}.

relative(Personne, Verbe) --> [Relative], suite_verbale(Personne_verbale, Verbe, _), {analyse(Relative, _, relative, _, _), concordance(Personne, Personne_verbale)}.

coordination --> [Coordination], {analyse(Coordination, _, coordination, _, _)}.

gv(Personne, VerbeC) --> [Verbe], {analyse(Verbe, VerbeC, verbe, _, Personne)}.

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
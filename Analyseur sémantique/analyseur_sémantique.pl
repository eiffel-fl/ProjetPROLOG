element_k(X, L, K) :- L = [X | _], K = 1.
element_k(X, L, K) :- L = [_ | T], element_k(X, T, Y), K is Y + 1.

make :- consult('../dictionnaire/mot.pl'), consult('../dictionnaire/terminaison.pl'), consult('../dictionnaire/conjugaison.pl'), consult('../dictionnaire/ontologie.pl').



ph(arbre_sem(Arbre)) --> gn(Personne1, Sujet, Article, Arbre_gn), suite_verbale(Personne2, _, _, Arbre_suite_verbale, Sujet), {concordance(Personne1, Personne2), Arbre =.. [Article, Sujet, AND], AND = &(Arbre_gn, Arbre_suite_verbale)}.

evaluer(Verbe, Sujet, Complément, Verb) :- nonvar(Complément), Verb =.. [Verbe, Sujet, Complément], call(Verb).

evaluer(Verbe, Sujet, Complément, Verb) :- var(Complément), Verb =.. [Verbe, Sujet], call(Verb).

suite_verbale(Personne, Verbe, _, Arbre_suite_verbale, Sujet) --> gv(Personne, Verbe), {evaluer(Verbe, Sujet, _, Arbre_suite_verbale)}.
suite_verbale(Personne, Verbe, Complément, Arbre_suite_verbale, Sujet) --> gv(Personne, Verbe), gn(_, Complément, _, Arbre_gn), {evaluer(Verbe, Sujet, Complément, Arbuste_suite_verbale), Arbre_suite_verbale =.. [&, Arbuste_suite_verbale, Arbre_gn]}.
suite_verbale(Personne, Verbe, _, Arbre_suite_verbale, _) --> gv(Personne, Verbe), coordination(Arbre_coordination), ph(arbre_sem(Arbre_ph)), {Arbre_suite_verbale =.. [&, Arbre_coordination, arbre_sem(Arbre_ph)]}.

gn(Personne, Sujet, Article, Arbre_gn) --> [Article], suite_nominale_adjectif(Personne, Sujet, Arbre_gn), {analyse(Article, _, article, _, Personne)}.

suite_nominale(Personne, Sujet, Arbre_gn, _) --> [Nom], {analyse(Nom, Sujet, nom, _, Personne), Arbre_gn =.. [Sujet, Nom]}.
suite_nominale(Personne, Sujet, Arbre_gn, Verbe) --> [Nom], suite_nominale_nom(Personne, Verbe, Arbre_suite_nominale, Sujet),  {analyse(Nom, Sujet, nom, _, Personne), Arbre_gn =.. [&, Arbuste_gn, Arbre_suite_nominale], Arbuste_gn =.. [Sujet, Sujet]}.

suite_nominale_nom(Personne, _, _, _) --> [Adjectif], {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_nom(Personne, Verbe, Arbre_suite_nominale, Sujet) --> relative(Personne, Verbe, Arbre_suite_nominale, Sujet).
suite_nominale_nom(Personne, Verbe, Arbre_suite_nominale, Sujet) --> [Adjectif], relative(Personne, Verbe, Arbre_suite_nominale, Sujet), {analyse(Adjectif, _, adjectif, _, Personne)}.

suite_nominale_adjectif(Personne, Sujet, Arbre_gn) --> suite_nominale(Personne, Sujet, Arbre_gn, _).
suite_nominale_adjectif(Personne, Sujet, Arbre_gn) --> [Adjectif], suite_nominale(Personne, Sujet, Arbre_gn, _), {analyse(Adjectif, _, adjectif, _, Personne)}.
suite_nominale_adjectif(Personne, Sujet, Arbre_gn) --> [Adjectif1], [Adjectif2], suite_nominale(Personne, Sujet, Arbre_gn, _), {analyse(Adjectif1, _, adjectif, _, Personne), analyse(Adjectif2, _, adjectif, _, Personne)}.

relative(Personne, Verbe, Arbre_suite_nominale, Sujet) --> [Relative], suite_verbale(Personne_verbale, Verbe, _, Arbre_suite_verbale, Sujet), {analyse(Relative, _, relative, _, _), concordance(Personne, Personne_verbale), Arbre_suite_nominale =.. [&, Arbuste_relative, Arbre_suite_verbale], Arbuste_relative =.. [Relative, Relative]}.

coordination(Arbre_coordination) --> [Coordination], {analyse(Coordination, _, coordination, _, _), Arbre_coordination =.. [Coordination, Coordination]}.

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
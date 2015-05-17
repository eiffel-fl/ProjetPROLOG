/*TO DO:
* Traduire le dictionnaire PERL en dictionnaire PROLOG
*
*/

element_k(X, L, K) :- L = [X | _], K = 1.
element_k(X, L, K) :- L = [_ | T], element_k(X, T, Y), K is Y + 1.

make :- consult('../dictionnaire/mot.pl'), consult('../dictionnaire/terminaison.pl'), consult('../dictionnaire/conjugaison.pl').

analyse(Mot, MotCanonique, Categorie, Groupe, Personne) :-
  name(Mot,LMot),
  append(Racine, Terminaison,LMot),
	mot(MotCanonique, Categorie, Conjugaison, Racine, NumRacine),
	conjugaison(Conjugaison, Groupe, NomTerminaison, Liste),
	element_k(NumRacine, Liste, Personne),
	terminaison(NomTerminaison, Terminaison, Personne),
	append(Racine, Terminaison, L),
	name(Mot, L).

genere(Mot, MotCanonique, Categorie, Groupe, Personne) :-
	mot(MotCanonique, Categorie, Conjugaison, Racine, NumRacine),
	conjugaison(Conjugaison, Groupe, NomTerminaison, Liste),
	element_k(NumRacine, Liste, Personne),
	terminaison(NomTerminaison, Terminaison, Personne),
	append(Racine, Terminaison, L),
	name(Mot, L).

affiche_personne(_, X, 1) :- X \== verbe, write(', masculin singulier'), nl.
affiche_personne(_, X, 2) :- X \== verbe, write(', masuclin pluriel'), nl.
affiche_personne(_, X, 3) :- X \== verbe, write(', féminin singulier'), nl.
affiche_personne(_, X, 4) :- X \== verbe, write(', féminin pluriel'), nl.
affiche_personne(_, X, 5) :- X \== verbe, write(', adverbe'), nl.

affiche_personne(X, verbe, 1) :- X \== pt, write(', première personne du singulier ').
affiche_personne(X, verbe, 2) :- X \== pt, write(', deuxième personne du singulier ').
affiche_personne(X, verbe, 3) :- X \== pt, write(', troisième personne du singulier ').
affiche_personne(X, verbe, 4) :- X \== pt, write(', première personne du pluriel ').
affiche_personne(X, verbe, 5) :- X \== pt, write(', deuxième personne du pluriel ').
affiche_personne(X, verbe, 6) :- X \== pt, write(', troisième personne du pluriel ').

affiche_personne(pt, verbe, 1) :- write(', masculin singulier du participe passé').
affiche_personne(pt, verbe, 2) :- write(', féminin singulier du participe passé').
affiche_personne(pt, verbe, 3) :- write(', masculin pluriel du participe passé').
affiche_personne(pt, verbe, 4) :- write(', féminin pluriel du participe passé').
affiche_personne(pt, verbe, 5) :- write(', du participe présent').
affiche_personne(pt, verbe, 6) :- write(', de l\'infinitif').

affiche_groupe(ip) :- write('du présent de l\'indicatif'), nl.
affiche_groupe(ii) :- write('de l\'imparfait de l\'indicatif'), nl.
affiche_groupe(ps) :- write('du passé simple de l\'indicatif'), nl.
affiche_groupe(if) :- write('du futur de l\'indicatif'), nl.
affiche_groupe(cd) :- write('du présent du conditionnel'), nl.
affiche_groupe(sp) :- write('du présent du subjonctif'), nl.
affiche_groupe(si) :- write('de l\'imparfait du subjonctif'), nl.
affiche_groupe(imp) :- write('du présent de l\'impératif'), nl.
affiche_groupe(pt) :- nl.

affiche_analyse(Mot) :-
	analyse(Mot, MotCanonique, Categorie, Groupe, Personne),
	write(Mot),
	write(' --> '),
	write(Categorie),
	write(' '),
	write(MotCanonique),
	affiche_personne(Groupe, Categorie, Personne),
	affiche_groupe(Groupe).

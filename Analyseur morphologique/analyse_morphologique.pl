/*TO DO:
* Traduire le dictionnaire PERL en dictionnaire PROLOG
*
*/

element_k(X, L, K) :- L = [X | T], K = 1.
element_k(X, L, K) :- L = [H | T], element_k(X, T, Y), K is Y + 1.

make :- consult('mot.pl'), consult('terminaison.pl'), consult('conjugaison.pl').

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

affiche_personne(_, X, 1) :- X \== verbe, write(', masculin singulier').
affiche_personne(_, X, 2) :- X \== verbe, write(', masuclin pluriel').
affiche_personne(_, X, 3) :- X \== verbe, write(', féminin singulier').
affiche_personne(_, X, 4) :- X \== verbe, write(', féminin pluriel').

affiche_personne(X, verbe, 1) :- X \== pi, write(', première personne du singulier ').
affiche_personne(X, verbe, 2) :- X \== pi, write(', deuxième personne du singulier ').
affiche_personne(X, verbe, 3) :- X \== pi, write(', troisième personne du singulier ').
affiche_personne(X, verbe, 4) :- X \== pi, write(', première personne du pluriel ').
affiche_personne(X, verbe, 5) :- X \== pi, write(', deuxième personne du pluriel ').
affiche_personne(X, verbe, 6) :- X \== pi, write(', troisième personne du pluriel ').

affiche_personne(pi, verbe, 1) :- write(', masculin singulier du participe passé').
affiche_personne(pi, verbe, 2) :- write(', féminin singulier du participe passé').
affiche_personne(pi, verbe, 3) :- write(', masculin pluriel du participe passé').
affiche_personne(pi, verbe, 4) :- write(', féminin pluriel du participe passé').
affiche_personne(pi, verbe, 5) :- write(', du participe présent').
affiche_personne(pi, verbe, 6) :- write(', de l\'infinitif').

affiche_groupe(ip) :- write('du présent de l\'indicatif'), nl.
affiche_groupe(ii) :- write('de l\'imparfait de l\'indicatif'), nl.
affiche_groupe(ps) :- write('du passé simple de l\'indicatif'), nl.
affiche_groupe(if) :- write('du futur de l\'indicatif'), nl.
affiche_groupe(cd) :- write('du présent du conditionnel'), nl.
affiche_groupe(sp) :- write('du présent du subjonctif'), nl.
affiche_groupe(si) :- write('de l\'imparfait du subjonctif'), nl.
affiche_groupe(imp) :- write('du présent de l\'impératif'), nl.
affiche_groupe(pi) :- nl.

affiche_analyse(Mot) :-
	analyse(Mot, MotCanonique, Categorie, Groupe, Personne),
	write(Mot),
	write(' --> '),
	write(Categorie),
	write(' '),
	write(MotCanonique),
	affiche_personne(Groupe, Categorie, Personne),
	affiche_groupe(Groupe).
se_mouvoir(X) :- animé(X).
se_mouvoir(balle).

animal(chien).
animal(cheval).
animal(hibou).

insecte(pou).
insecte(abeille).

peut_voler(abeille).
peut_voler(hibou).

homme(julien).

animé(X) :- animal(X); homme(X); insecte(X).

carnivore(hibou).

herbivore(cheval).

comestible(pain).
comestible(pou).

rouler(X, _) :- se_mouvoir(X).
marcher(X, _) :- animé(X).
boiter(X, _) :- marcher(X, _).
manger(X, Y) :- herbivore(X), not(animal(Y)), comestible(Y).
manger(X, Y) :- carnivore(X), comestible(Y).
manger(X, _) :- animé(X).
bouffer(X, _) :- manger(X, _).
aimer(X, _) :- animé(X).
voler(X, _) :- peut_voler(X).
bourdonner(X, _) :- peut_voler(X), insecte(X).
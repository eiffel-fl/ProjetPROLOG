se_mouvoir(X) :- animé(X).
se_mouvoir(balle).

oiseau(hibou).
oiseau(corbeau).

mammifère(blaireau).
mammifère(chien).
mammifère(agneau).
mammifère(cheval).
mammifère(X) :- homme(X).

plusgrand(X, Y) :- mammifère(X), insecte(Y).
plusgrand(X, Y) :- oiseau(X), insecte(Y).
plusgrand(_, pain).

insecte(pou).
insecte(abeille).

peut_voler(abeille).
peut_voler(hibou).

homme(julien).

animé(X) :- mammifère(X); homme(X); insecte(X).

carnivore(X) :- homme(X).
carnivore(hibou).
carnivore(corbeau).
carnivore(chien).
carnivore(blaireau).

herbivore(cheval).
herbivore(agneau).

comestible(pain).
comestible(pou).

rouler(X) :- se_mouvoir(X).
marcher(X) :- animé(X).
boiter(X) :- marcher(X).
manger(X, Y) :- herbivore(X), not(mammifère(Y)), comestible(Y).
manger(X, Y) :- carnivore(X), comestible(Y).
manger(X) :- animé(X).
bouffer(X, _) :- manger(X, _).
aimer(X, _) :- animé(X).
voler(X) :- peut_voler(X).
bourdonner(X, _) :- peut_voler(X), insecte(X).
enrager(X) :- mammifère(X).
hurler(X) :- mammifère(X).
pousser(X) :- animé(X).
dormir(X) :- animé(X).
escalader(X) :- animé(X).
grogner(X) :- mammifère(X).
ignorer(X, _) :- mammifère(X).
ignorer(X) :- mammifère(X).
nager(X) :- mammifère(X).
porter(X, Y) :- animé(X), plusgrand(X, Y).
porter(X) :- animé(X).
poser(X, Y) :- animé(X), plusgrand(X, Y).
/*rouiller*/
ressentir(X) :- mammifère(X).
sursauter(X) :- mammifère(X).
saisir(X, Y) :- animé(X), plusgrand(X, Y).
saisir(X) :- animé(X).
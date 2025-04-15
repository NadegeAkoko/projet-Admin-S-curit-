-- Table des livres
CREATE TABLE livres (
    id SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255) NOT NULL,
    annee INT CHECK (annee >= 1000 AND annee <= EXTRACT(YEAR FROM CURRENT_DATE)),
    genre VARCHAR(100)
);

-- Table des emprunteurs
CREATE TABLE emprunteurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Table des emprunts
CREATE TABLE emprunts (
    id_emprunteur INT REFERENCES emprunteurs(id) ON DELETE CASCADE,
    id_livre INT REFERENCES livres(id) ON DELETE CASCADE,
    date_emprunt DATE NOT NULL,
    date_retour_prevue DATE NOT NULL,
    PRIMARY KEY (id_emprunteur, id_livre)
);


INSERT INTO livres (titre, auteur, annee, genre) VALUES
('Le Petit Prince', 'Antoine de Saint-Exupéry', 1943, 'Philosophique'),
('1984', 'George Orwell', 1949, 'Dystopie'),
('Moby Dick', 'Herman Melville', 1851, 'Aventure'),
('Les Misérables', 'Victor Hugo', 1862, 'Classique'),
('To Kill a Mockingbird', 'Harper Lee', 1960, 'Drame');


INSERT INTO emprunteurs (nom, email) VALUES
('Alice Dupont', 'alice.dupont@example.com'),
('Bob Martin', 'bob.martin@example.com'),
('Charlie Lefevre', 'charlie.lefevre@example.com');


INSERT INTO emprunts (id_emprunteur, id_livre, date_emprunt, date_retour_prevue) VALUES
(1, 1, '2025-04-01', '2025-04-15'),
(2, 2, '2025-04-05', '2025-04-20'),
(3, 3, '2025-04-07', '2025-04-21'),
(1, 4, '2025-04-10', '2025-04-24');


SELECT l.titre, e.nom
FROM emprunts emp
JOIN livres l ON emp.id_livre = l.id
JOIN emprunteurs e ON emp.id_emprunteur = e.id;


SELECT titre
FROM livres
WHERE id NOT IN (SELECT id_livre FROM emprunts);


SELECT e.nom, l.titre, emp.date_emprunt, emp.date_retour_prevue
FROM emprunts emp
JOIN livres l ON emp.id_livre = l.id
JOIN emprunteurs e ON emp.id_emprunteur = e.id
WHERE emp.date_retour_prevue < CURRENT_DATE;


CREATE VIEW vue_livres_empruntes AS
SELECT l.titre, e.nom, emp.date_emprunt, emp.date_retour_prevue
FROM emprunts emp
JOIN livres l ON emp.id_livre = l.id
JOIN emprunteurs e ON emp.id_emprunteur = e.id;


BEGIN;

INSERT INTO emprunts (id_emprunteur, id_livre, date_emprunt, date_retour_prevue)
VALUES (2, 5, '2025-04-12', '2025-04-26');

COMMIT;


BEGIN;

SAVEPOINT avant_insertion;

-- Première insertion
INSERT INTO emprunts (id_emprunteur, id_livre, date_emprunt, date_retour_prevue)
VALUES (3, 1, '2025-04-13', '2025-04-27');

-- Deuxième insertion
INSERT INTO emprunts (id_emprunteur, id_livre, date_emprunt, date_retour_prevue)
VALUES (2, 3, '2025-04-14', '2025-04-28');

COMMIT;


ROLLBACK;

UPDATE emprunteurs
SET nom = 'NouveauNom'
WHERE email = 'alice.dupont@example.com';

BEGIN;

SAVEPOINT avant_erreur;

-- Provoquer une erreur (par exemple, email dupliqué)
INSERT INTO emprunteurs (nom, email) VALUES ('Alice Dupont', 'alice.dupont@example.com');

-- Rollback à SAVEPOINT
ROLLBACK TO SAVEPOINT avant_erreur;

COMMIT;







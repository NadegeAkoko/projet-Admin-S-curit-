CREATE EXTENSION IF NOT EXISTS pg_stat_statements;


CREATE EXTENSION pg_stat_statements;

SELECT query, total_exec_time, calls, rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 3;


EXPLAIN ANALYZE SELECT * FROM vue_livres_empruntes;

CREATE INDEX idx_emprunteurs_id ON emprunts(id_emprunteur);

EXPLAIN ANALYZE SELECT * FROM emprunts WHERE id_emprunteur = 1;

EXPLAIN ANALYZE SELECT * FROM emprunts WHERE id_emprunteur = 1;

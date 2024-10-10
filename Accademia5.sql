-- 1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome ‘Pegasus’ ?

select WP.nome, WP.inizio, WP.fine
from WP, Progetto
where Progetto.id = WP.progetto and Progetto.nome = 'Pegasus';

-- 2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?

select distinct per.nome, per.cognome, per.posizione
from Persona per, Progetto pro, AttivitaProgetto att
where pro.nome = 'Pegasus' and att.persona = per.id and att.progetto = pro.id
order by per.nome desc;

-- 3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di una attività nel progetto ‘Pegasus’ ?

select per.nome, per.cognome, per.posizione
from Persona per, Progetto pro, AttivitaProgetto att
where pro.nome = 'Pegasus' and att.persona = per.id and att.progetto = pro.id and progetto > 1
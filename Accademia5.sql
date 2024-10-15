create type Strutturato as enum ('Ricercatore', 'Professore Associato', 'Professore Ordinario');
create type LavoroProgetto as enum  ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
create type LavoroNonProgettuale as enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro
Accademico', 'Altro');
create type CausaAssenza as enum ('Chiusura Universitaria', 'Maternita', 'Malattia');
CREATE DOMAIN PostInteger AS INTEGER CHECK (VALUE >= 0);
CREATE DOMAIN StringaM AS VARCHAR(100);
CREATE DOMAIN NumeroOre AS INTEGER CHECK (VALUE >= 0 AND VALUE <= 8);
CREATE DOMAIN Denaro AS REAL CHECK (VALUE >= 0);

CREATE TABLE Persona (
    id PostInteger NOT NULL, 
    nome StringaM NOT NULL, 
    cognome StringaM NOT NULL, 
    posizione Strutturato NOT NULL, 
    stipendio Denaro NOT NULL, 
    PRIMARY KEY (id)
);

CREATE TABLE Progetto (
    id PostInteger NOT NULL, 
    nome StringaM NOT NULL, 
    inizio DATE NOT NULL, 
    fine DATE NOT NULL, 
    budget Denaro NOT NULL, 
    PRIMARY KEY (id), 
    UNIQUE (nome),
    CHECK (inizio < fine)
);

CREATE TABLE WP (
    progetto PostInteger NOT NULL, 
    id PostInteger NOT NULL, 
    nome StringaM NOT NULL, 
    inizio DATE NOT NULL, 
    fine DATE NOT NULL, 
    PRIMARY KEY (progetto, id), 
    UNIQUE (nome), 
    FOREIGN KEY (progetto) REFERENCES Progetto(id),
    CHECK (inizio < fine)
);

CREATE TABLE AttivitaProgetto (
    id PostInteger NOT NULL, 
    persona PostInteger NOT NULL, 
    progetto PostInteger NOT NULL, 
    wp PostInteger NOT NULL, 
    giorno DATE NOT NULL, 
    tipo LavoroProgetto NOT NULL, 
    oreDurata NumeroOre NOT NULL, 
    PRIMARY KEY (progetto, id), 
    FOREIGN KEY (persona) REFERENCES Persona(id), 
    FOREIGN KEY (progetto, wp) REFERENCES WP(progetto, id)
);

CREATE TABLE AttivitaNonProgettuale (
    id PostInteger NOT NULL, 
    persona PostInteger NOT NULL, 
    tipo LavoroNonProgettuale NOT NULL, 
    giorno DATE NOT NULL, 
    oreDurata NumeroOre NOT NULL, 
    PRIMARY KEY (id), 
    FOREIGN KEY (persona) REFERENCES Persona(id)
);

CREATE TABLE Assenza (
    id PostInteger NOT NULL, 
    persona PostInteger NOT NULL, 
    tipo CausaAssenza NOT NULL, 
    giorno DATE NOT NULL, 
    PRIMARY KEY (id), 
    UNIQUE (persona, giorno), 
    FOREIGN KEY (persona) REFERENCES Persona(id)
);


-- Query:
-- 1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome 'Pegasus' ?

select wp.id, wp.nome, wp.inizio, wp.fine
from WP wp, Progetto p
where p.nome = 'Pegasus' and wp.progetto = p.id;

-- 2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?

with nome_progetto as (
    select id
    from Progetto 
    where nome = 'Pegasus'
)
select distinct p.id, p.nome, p.cognome, p.posizione
from Persona p, nome_progetto np, AttivitaProgetto ap
where p.id = ap.persona and np.id = ap.progetto
order by p.cognome desc;

-- 3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di una attività nel progetto ‘Pegasus’ ?

with nome_progetto as (
    select id
    from Progetto 
    where nome = 'Pegasus'
)
select distinct p.id, p.nome, p.cognome, p.posizione
from Persona p, AttivitaProgetto ap, nome_progetto np
where p.id = ap.persona and ap.progetto = np.id 
and (select COUNT(*) 
    from AttivitaProgetto ap2 
    where ap2.persona = p.id and ap2.progetto = np.id) > 1;

-- 4. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno fatto almeno una assenza per malattia?

select distinct p.id, p.nome, p.cognome
from Persona p, Assenza a
where p.posizione = 'Professore Ordinario' and a.persona = p.id and a.tipo = 'Malattia' 

-- 5. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno fatto più di una assenza per malattia?

select distinct p.id, p.nome, p.cognome
from Persona p, Assenza a
where p.posizione = 'Professore Ordinario' and a.persona = p.id
and (select count(*)
     from Assenza a2
     where a2.persona = p.id and a2.tipo = 'Malattia') > 1

-- 6. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno un impegno per didattica?

select distinct p.id, p.nome, p.cognome
from Persona p, AttivitaNonProgettuale a
where a.persona = p.id and a.tipo = 'Didattica' and p.posizione = 'Ricercatore'

-- 7. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un impegno per didattica?

select distinct p.id, p.nome, p.cognome
from Persona p, AttivitaNonProgettuale a
where a.persona = p.id and p.posizione = 'Ricercatore'
and (select count(*)
     from  AttivitaNonProgettuale a2
     where a2.persona = p.id and a2.tipo = 'Didattica') > 1

-- 8. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia attività progettuali che attività non progettuali?

select distinct p.id, p.nome, p.cognome
from Persona p, AttivitaProgetto ap, AttivitaNonProgettuale anp
where p.id = ap.persona and p.id = anp.persona and ap.giorno = anp.giorno

-- 9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia attività progettuali che attività non progettuali? Si richiede anche di proiettare il giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di entrambe le attività.



-- 10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono assenti e hanno attività progettuali?
-- 11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il nome del progetto, la causa di assenza e la durata in ore della attività progettuale.
-- 12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?
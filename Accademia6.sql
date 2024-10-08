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


-- Query 
-- 1. Quanti sono gli strutturati di ogni fascia?

select posizione, COUNT(*)
from Persona
GROUP BY posizione;

-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?

select COUNT(*)
from Persona
where (stipendio >= 40000 );

-- 3. Quanti sono i progetti già finiti che superano il budget di 50000?

select COUNT(*) 
from Progetto
where fine < CURRENT_DATE AND budget > 50000;

-- 4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto ‘Pegasus’ ?

select 
    AVG(oreDurata),
    MAX(oreDurata),
    MIN(oreDurata)
from AttivitaProgetto, Progetto as p
where progetto = p.id and p.nome = 'Pegasus';

-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere dedicate al progetto ‘Pegasus’ da ogni singolo docente? (non funziona)

select 
    per.nome
    per.id
    AVG(oreDurata),
    MAX(oreDurata),
    MIN(oreDurata)
from AttivitaProgetto, Progetto as pro, Persona as per
where progetto = pro.id and pro.nome = 'Pegasus';

-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni docente? (non funziona)

select SUM(oreDurata), p.id, p.nome, p.cognome
from AttivitaNonProgettuale, Persona as p
where tipo = 'Didattica'
group by persona;

-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?

select 
    AVG(stipendio),
    MAX(stipendio),
    MIN(stipendio)
from Persona
where posizione = 'Ricercatore';

-- 8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, dei professori associati e dei professori ordinari?

select 
    posizione,
    AVG(stipendio),
    MAX(stipendio),
    MIN(stipendio)
from Persona
where posizione in ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
group by posizione;

-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?

-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?

-- 11. Quali sono i professori associati che hanno lavorato su più di un progetto?
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

select p.posizione, count(*)
from Persona p
where True
group by p.posizione

-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?

select count(*)
from Persona p
where p.stipendio >= 40000

-- 3. Quanti sono i progetti già finiti che superano il budget di 50000?

select count(*)
from Progetto pr
where pr.budget > 50000 and pr.fine < current_date

-- 4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto ‘Pegasus’ ?

select avg(ap.oreDurata), max(ap.oreDurata), min(ap.oreDurata)
from Progetto pr, AttivitaProgetto ap
where pr.nome = 'Pegasus' and ap.progetto = pr.id

-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere dedicate al progetto ‘Pegasus’ da ogni singolo docente? 

select p.id, p.nome, p.cognome, avg(ap.oreDurata), max(ap.oreDurata), min(ap.oreDurata)
from Persona p, AttivitaProgetto ap, Progetto pr
where pr.nome = 'Pegasus' and ap.progetto = pr.id and ap.persona = p.id
group by p.id

-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?

select p.id, p.nome, p.cognome, count(anp.oreDurata)
from Persona p, AttivitaNonProgettuale anp
where anp.persona = p.id and anp.tipo = 'Didattica'
group by p.id

-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?

select avg(p.stipendio), max(p.stipendio), min(p.stipendio)
from Persona p
where p.posizione = 'Ricercatore'

-- 8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, dei professori associati e dei professori ordinari?

select p.posizione, avg(p.stipendio), max(p.stipendio), min(p.stipendio)
from Persona p
where True
group by p.posizione

-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?

select pr.id, pr.nome, sum(ap.oreDurata)
from Persona p, Progetto pr, AttivitaProgetto ap
where p.nome = 'Ginevra' and p.cognome = 'Riva' and ap.progetto = pr.id and p.id = ap.persona
group by pr.id

-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?

select pr.id, pr.nome 
from Persona p, Progetto pr, AttivitaProgetto ap
where pr.id = ap.progetto and ap.persona = p.id
group by pr.id
having count(p.posizione) > 2

-- 11. Quali sono i professori associati che hanno lavorato su più di un progetto?

select p.id, p.nome, p.cognome
from Persona p, Progetto pr, AttivitaProgetto ap
where p.id = ap.persona and ap.progetto = pr.id and p.posizione = 'Professore Associato'
group by p.id
having count(pr.nome) >= 2
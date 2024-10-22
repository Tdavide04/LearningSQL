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


-- 1. Qual è media e deviazione standard degli stipendi per ogni categoria di strutturati?

select p.posizione, avg(p.stipendio), stddev(p.stipendio)
from Persona p
where True
group by p.posizione

-- 2. Quali sono i ricercatori (tutti gli attributi) con uno stipendio superiore alla media della loro categoria?

with categoria_persona as (
    select avg(p.stipendio) as media
    from Persona p
	where p.posizione = 'Ricercatore'
	group by p.posizione
)
select p.*
from Persona p, categoria_persona cp
where p.posizione = 'Ricercatore' and p.stipendio > cp.media

-- 3. Per ogni categoria di strutturati quante sono le persone con uno stipendio che differisce di al massimo una deviazione standard dalla media della loro categoria?

select p.posizione, count(*)
from Persona p
where stipendio >= (select avg(stipendio) - stddev(stipendio) 
                    from Persona p2 
                    where p2.posizione = p.posizione)
and stipendio <=   (select avg(stipendio) + stddev(stipendio) 
                    from Persona p2 
                    where p2.posizione = p.posizione)
group by p.posizione;

-- 4. Chi sono gli strutturati che hanno lavorato almeno 20 ore complessive in attività progettuali? Restituire tutti i loro dati e il numero di ore lavorate.

select p.*, sum(ap.oreDurata)
from Persona p
join AttivitaProgetto ap on p.id = ap.persona
group by p.id
having sum(oreDurata) > 20;

-- 5. Quali sono i progetti la cui durata è superiore alla media delle durate di tutti i progetti? Restituire nome dei progetti e loro durata in giorni.

select nome, (fine - inizio)
from Progetto
where (fine - inizio) > (select avg(fine - inizio) from Progetto);

-- 6. Quali sono i progetti terminati in data odierna che hanno avuto attività di tipo “Dimostrazione”? Restituire nome di ogni progetto e il numero complessivo delle ore dedicate a tali attività nel progetto.

select p.id, p.nome, sum(ap.oreDurata)
from Progetto p
join AttivitaProgetto ap on p.id = ap.progetto
where ap.tipo = 'Dimostrazione'
group by p.id

-- 7. Quali sono i professori ordinari che hanno fatto più assenze per malattia del numero di assenze medio per malattia dei professori associati? Restituire id, nome e cognome del professore e il numero di giorni di assenza per malattia.

select p.*
from Persona p
join Assenza a on p.id = persona
where p.posizione = 'Professore Ordinario' and a.tipo = 'Malattia'
group by p.id
having count(a.tipo = 'Malattia') > (select avg(p.id) from Persona p, Assenza a where p.posizione 'Professore Associato');



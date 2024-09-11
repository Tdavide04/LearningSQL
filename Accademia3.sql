CREATE TYPE Strutturato AS ENUM ('Ricercatore', 'Professore Associato', 'Professore Ordinario');
CREATE TYPE LavoroProgetto AS ENUM ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
CREATE TYPE LavoroNonProgettuale AS ENUM ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');
CREATE TYPE CausaAssenza AS ENUM ('Chiusura Universitaria', 'Maternità', 'Malattia');

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


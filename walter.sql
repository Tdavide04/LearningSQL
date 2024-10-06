create table Nazione (
    nome varchar not null,
    primary key (nome)
);

create table Regione (
    nome varchar not null,
    nazione varchar not null,
    primary key (nome, nazione),
    foreign key (nazione) references Nazione (nome) 
);

create table Citta (
    nome varchar not null,
    regione varchar not null,
    nazione varchar not null,
    primary key (nome, regione, nazione),
    foreign key (regione, nazione) references Regione (nome, nazione) 
);

create table Marca (
    nome varchar not null,
    primary key (nome)
);

create table TipoVeicolo (
    nome varchar not null,
    primary key (nome)
);

create table Modello (
    nome varchar not null,
    marca varchar not null,
    tipo varchar not null,
    primary key (nome, marca),
    foreign key (marca) references Marca (nome),
    foreign key (tipo) references TipoVeicolo (nome)
);

create table Veicolo (
    targa varchar not null,
    immatricolazione integer not null,
    modello varchar not null,
    marca varchar not null,
    cliente varchar not null,
    primary key (targa),
    foreign key (cliente) references Cliente (cf)
    foreign key (modello, marca) references Modello (nome, marca)

);

create table Riparazione (
    riconsegna timestamp,
    codice integer not null,
    inizio timestamp not null,
    officina varchar not null 
    primary key (codice)
    foreign key (officina) references Officina (id)
);

CREATE Domain String100_not_null AS varchar(100) CHECK (value IS NOT NULL);
CREATE DOMAIN Int_gz_not_null AS Integer CHECK (value IS NOT NULL and value > 0);
CREATE TYPE Indirizzo (
    via String100_not_null,
    civico Int_gz_not_null
);

create table Officina (
    nome varchar not null,
    id integer not null,
    indirizzo Indirizzo not null,
    citta varchar not null,
    regione varchar not null,
    nazione varchar not null,
    primary key (id),
    foreign key (citta, regione, nazione) references Citta (nome, regione, nazione)
);

create domain codicefiscale as varchar(16)
    check (value ~ '^[A-Z0-9]{16}$');

create table Persona (
    cf codFis not null,
    nome varchar not null,
    indirizzo Indirizzo not null,
    telefono varchar not null,
    citta varchar not null,
    regione varchar not null,
    nazione varchar not null,
    primary key (cf)
    foreign  key (citta, regione, nazione) references citta(nome, nazione, regione)
);

create table Cliente ( 
    persona varchar not null,
    primary key (persona),
    foreign key (persona) references Persona (cf) 
);

create table Staff (
    persona varchar not null,
    primary key (persona),
    foreign key (persona) references Persona (cf)
);

create table Direttore (
    nascita date not null,
    staff varchar not null,
    primary key (staff),
    foreign key (staff) references Staff (persona)
);

create table Dipendente (
    persona varchar not null,
    lavora date not null,
    primary key (persona),
    foreign key (persona) references Persona (cf)
)
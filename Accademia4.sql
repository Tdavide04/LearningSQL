-- 1. Quali sono i cognomi distinti di tutti gli strutturati?

select distinct cognome
from Persona;

-- 2. Quali sono i Ricercatori (con nome e cognome)?

select nome, cognome
from Persona
where posizione = 'Ricercatore';

-- 3. Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’ ?

select nome, cognome
from Persona
where posizione = 'Professore Associato' and cognome like 'V%';

-- 4. Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la lettera ‘V’ ?

select nome, cognome
from Persona
where persona.posizione in ('Professore Associato', 'Professore Ordinario') and cognome like 'V%';


-- 5. Quali sono i Progetti già terminati alla data odierna?

select *
from Progetto
where fine < CURRENT_DATE;

-- 6. Quali sono i nomi di tutti i Progetti ordinati in ordine crescente di data di inizio?

select nome
from Progetto
order by inizio asc

-- 7. Quali sono i nomi dei WP ordinati in ordine crescente (per nome)?

select nome
from WP
order by nome asc

-- 8. Quali sono (distinte) le cause di assenza di tutti gli strutturati?

select distinct tipo
from Assenza;

-- 9. Quali sono (distinte) le tipologie di attività di progetto di tutti gli strutturati?

select distinct tipo
from AttivitaProgetto;

-- 10. Quali sono i giorni distinti nei quali del personale ha effettuato attività non progettuali di tipo ‘Didattica’ ? Dare il risultato in ordine crescente.

select distinct giorno
from AttivitaNonProgettuale
where tipo = 'Didattica'
order by giorno asc;
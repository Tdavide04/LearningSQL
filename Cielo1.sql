-- 1. Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?

select codice, comp
from volo
where durataminuti > 180

-- 2. Quali sono le compagnie che hanno voli che superano le 3 ore?

select comp
from volo
where durataminuti > 180
group by comp

-- 3. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto con codice ‘CIA’ ?

select codice, comp
from arrpart 
where partenza = 'CIA'

-- 4. Quali sono le compagnie che hanno voli che arrivano all’aeroporto con codice ‘FCO’ ?

select distinct comp
from arrpart 
where arrivo = 'FCO'

-- 5. Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto ‘FCO’ e arrivano all’aeroporto ‘JFK’ ?

select codice, comp
from arrpart 
where partenza = 'FCO' and arrivo = 'JFK'

-- 6. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’ e atterrano all’aeroporto ‘JFK’ ?

select distinct comp
from arrpart 
where partenza = 'FCO' and arrivo = 'JFK'

-- 7. Quali sono i nomi delle compagnie che hanno voli diretti dalla città di ‘Roma’ alla città di ‘New York’ ?

select distinct comp
from arrpart
where (partenza = 'FCO' or partenza = 'CIA') and arrivo = 'JFK'

-- 8. Quali sono gli aeroporti (con codice IATA, nome e luogo) nei quali partono voli della compagnia di nome ‘MagicFly’ ?

select ap.codice, ap.nome, la.citta
from aeroporto ap, arrpart ar, luogoaeroporto la
where la.aeroporto = ar.partenza and ap.codice = la.aeroporto and ar.comp = 'MagicFly'
group by ap.codice, ap.nome, la.citta 

-- 9. Quali sono i voli che partono da un qualunque aeroporto della città di ‘Roma’ e atterrano ad un qualunque aeroporto della città di ‘New York’ ? Restituire: codice del volo, nome della compagnia, e aeroporti di partenza e arrivo.

with ar_roma as (
    select *
    from luogoaeroporto
    where citta = 'Roma'
), ar_NewYork as (
    select *
    from luogoaeroporto
    where citta = 'New York'
)
select ar.codice, ar.comp, ar.partenza, ar.arrivo
from arrpart ar, ar_roma, ar_NewYork
where ar_roma.aeroporto = ar.partenza and ar_NewYork.aeroporto = ar.arrivo

-- 10. Quali sono i possibili piani di volo con esattamente un cambio (utilizzando solo voli della stessa compagnia) da un qualunque aeroporto della città di ‘Roma’ ad un qualunque aeroporto della città di ‘New York’ ? Restituire: nome della compagnia, codici dei voli, e aeroporti di partenza, scalo e arrivo.



-- 11. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’, atterrano all’aeroporto ‘JFK’, e di cui si conosce l’anno di fondazione?

select ar.comp
from arrpart ar, compagnia c
where ar.partenza = 'FCO' and ar.arrivo = 'JFK' and c.nome = ar.comp

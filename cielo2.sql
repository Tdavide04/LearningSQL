-- 1. Quante sono le compagnie che operano (sia in arrivo che in partenza) nei diversi aeroporti?

select a.codice, a.nome, count(distinct ar.comp) 
from arrpart ar, aeroporto a
where a.codice = ar.partenza or a.codice = ar.arrivo
group by a.codice

-- 2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno una durata di almeno 100 minuti?

select count(distinct ar.partenza)
from volo v, arrpart ar
where v.durataminuti >= 100 and ar.partenza = 'HTR' 

-- 3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, per ogni nazione nella quale opera?

select la.nazione, count(distinct la.aeroporto)
from arrpart ar, luogoaeroporto la
where ar.comp = 'Apitalia' and (ar.arrivo = la.aeroporto or ar.partenza = la.aeroporto)
group by la.nazione

-- 4. Qual è la media, il massimo e il minimo della durata dei voli effettuati dalla compagnia ‘MagicFly’ ?

select avg(v.durataminuti), max(v.durataminuti), min(v.durataminuti)
from volo v
where v.comp = 'MagicFly'

-- 5. Qual è l’anno di fondazione della compagnia più vecchia che opera in ognuno degli aeroporti?

select a.codice, a.nome, min(c.annofondaz)
from compagnia c, aeroporto a, arrpart ar
where (ar.arrivo = a.codice or ar.partenza = a.codice) and c.nome = ar.comp
group by a.codice

-- 6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più voli?

select lp.nazione, count(distinct la.nazione)
from arrpart ar
join luogoaeroporto lp on ar.partenza = lp.aeroporto
join luogoaeroporto la on ar.arrivo = la.aeroporto
where lp.nazione <> la.nazione
group by lp.nazione;

-- 7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?

select a.codice, a.nome, avg(v.durataminuti)
from volo v
join arrpart ar on v.codice = ar.codice and v.comp = ar.comp
join aeroporto a on ar.partenza = a.codice
group by a.codice

-- 8. Qual è la durata complessiva dei voli operati da ognuna delle compagnie fondate a partire dal 1950?

select ar.comp, sum(v.durataminuti) 
from arrpart ar
join volo v on ar.codice = v.codice 
join compagnia c on c.nome = ar.comp
where c.annofondaz >= 1950
group by ar.comp

-- 9. Quali sono gli aeroporti nei quali operano esattamente due compagnie?

select a.codice, a.nome
from aeroporto a
join arrpart ar on (a.codice = ar.partenza or a.codice = ar.arrivo)
group by a.codice
having count(distinct ar.comp) = 2

-- 10. Quali sono le città con almeno due aeroporti?

select la.citta
from luogoaeroporto la
group by la.citta
having count(distinct la.aeroporto) >= 2

-- 11. Qual è il nome delle compagnie i cui voli hanno una durata media maggiore di 6 ore?

select c.nome
from compagnia c
join arrpart ar on c.nome = ar.comp
join volo v on v.codice = ar.codice
group by c.nome
having avg(v.durataminuti) > 360

-- 12. Qual è il nome delle compagnie i cui voli hanno tutti una durata maggiore di 100 minuti?

select v.comp
from volo v
group by v.comp
having min(v.durataminuti) > 100
#1 CONSULTA 1. ¿Qué consulta ejecutaría para obtener los ingresos totales para marzo de 2012?
select amount,charged_datetime,sum(amount)
from billing 

where charged_datetime < '2012-04-01' and charged_datetime > '2012-02-28';

#2. ¿Qué consulta ejecutaría para obtener los ingresos totales recaudados del cliente con una identificación de 2
select client_id, sum(amount)
from billing
where client_id = 2; 

#3. ¿Qué consulta ejecutaría para obtener todos los sitios que posee client = 10?
select domain_name, client_id
from sites
where client_id = 10;

#4. ¿Qué consulta ejecutaría para obtener el número total de 
#sitios creados por mes por año para el cliente con una identificación de 1? 
#¿Qué pasa con el cliente = 20?

SELECT 
    clients.client_id,
    count(sites.site_id) as sites_created,
    MONTH(sites.created_datetime) as 'mes',
    YEAR(sites.created_datetime) as 'año'
FROM
    clients
inner join sites
on clients.client_id = sites.client_id
AND clients.client_id = 1
GROUP BY MONTH(sites.created_datetime) , YEAR(sites.created_datetime)
ORDER BY MONTH(sites.created_datetime) ASC;

select 
    clients.client_id,
    COUNT(sites.site_id) as sites_created,
    MONTH(sites.created_datetime) as 'mes',
    YEAR(sites.created_datetime) as 'año'
from
    clients
        inner join
    sites on clients.client_id = sites.client_id
        and clients.client_id = 20
GROUP BY MONTH(sites.created_datetime) , YEAR(sites.created_datetime)
ORDER BY MONTH(sites.created_datetime) ASC;

select domain_name, client_id
from sites;

#5. ¿Qué consulta ejecutaría para obtener el número total de clientes potenciales generados
# para cada uno de los sitios entre el 1 de enero de 2011 y el 15 de febrero de 2011?

SELECT 
    count(leads.leads_id) as "Numero de leads",
    sites.domain_name,
    leads.registered_datetime
FROM
    sites
inner join leads
on sites.site_id = leads.site_id
and leads.registered_datetime >= '2011-01-01'
and leads.registered_datetime <= '2011-02-15'
GROUP BY sites.domain_name;

select sites.domain_name,
		count(leads.leads_id) as "Numero de Leads",
		leads.registered_datetime
from sites
inner join leads
on sites.site_id = leads.site_id
where registered_datetime >= '2011-01-01' and registered_datetime <= '2011-02-15'
group by sites.domain_name;

select leads_id, registered_datetime, domain_name
from leads, sites;


#6. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales
# que hemos generado para cada uno de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011?

select clients.first_name,
		leads.leads_id
  
from clients 
inner join sites
on clients.client_id = sites.client_id

inner join leads
on sites.client_id = leads.leads_id

inner join billing
on sites.client_id = billing.client_id;


#7. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y 
#el número total de clientes potenciales que hemos generado para cada cliente cada mes entre los meses 1 y 6 del año 2011?

select 
concat(clients.first_name, ' ', clients.last_name) as 'Cliente',
count(leads.leads_id) as 'Numero de leads',
month(leads.registered_datetime) as 'mes'

from clients
left join sites 
on clients.client_id = sites.client_id

inner join leads
on sites.site_id = leads.site_id

and leads.registered_datetime >= '2011-01-01'
and leads.registered_datetime < '2011-07-01'

group by clients.client_id , month(leads.registered_datetime)
order by 'numero de leads' desc;


#8. ¿Qué consulta ejecutaría para obtener una lista de nombres de clientes y el número total de clientes potenciales 
#que hemos generado para cada uno de los sitios de nuestros clientes entre el 1 de enero de 2011 y el 31 de diciembre de 2011? 
#Solicite esta consulta por ID de cliente. Presente una segunda consulta que muestre todos los clientes, 
#los nombres del sitio y el número total de clientes potenciales generados en cada sitio en todo momento.

select 
    concat(clients.first_name, ' ',
    clients.last_name) as 'clientes',
    sites.domain_name,
    count(leads.leads_id) as 'Numero de leads',
    leads.registered_datetime as 'fecha_creacion'
from
    clients
	left join sites
    on clients.client_id = sites.client_id
	inner join leads
    on sites.site_id = leads.site_id
    and leads.registered_datetime >= '2011-01-01'
	and leads.registered_datetime <= '2011-12-31'
group by sites.domain_name
order by clients.client_id;

select 
    concat(clients.first_name, ' ', clients.last_name) as 'Clientes',
    sites.domain_name,
    count(leads.leads_id) as 'Numero de leads'
from clients
left join sites
on clients.client_id = sites.client_id
join leads
on sites.site_id = leads.site_id
group by sites.domain_name
order by clients.client_id;


#9. Escriba una sola consulta que recupere los ingresos totales recaudados de cada cliente 
#para cada mes del año. Pídalo por ID de cliente.

select 
    clients.client_id,
    CONCAT(clients.first_name, ' ',
	clients.last_name) as cliente,
    sum(billing.amount) as ingresos,
    MONTH(billing.charged_datetime) as 'month',
    YEAR(billing.charged_datetime) as 'year'
from
    clients
	inner join
    billing on clients.client_id = billing.client_id
group by clients.client_id , 
month(billing.charged_datetime)
order by clients.client_id asc , 
month(billing.charged_datetime) asc , 
year(billing.charged_datetime) asc;


#10. Escriba una sola consulta que recupere todos los sitios que posee cada cliente. 
#Agrupe los resultados para que cada fila muestre un nuevo cliente. 
#Se volverá más claro cuando agregue un nuevo campo llamado 'sitios' que tiene todos los sitios que posee el cliente. 
#(SUGERENCIA: use GROUP_CONCAT)

select 
    clients.client_id,
    concat(clients.first_name, ' ', clients.last_name) as 'Cliente',
    group_concat(' ', sites.domain_name) as 'sitios'
from clients
left join sites
on clients.client_id = sites.client_id
group by clients.client_id;

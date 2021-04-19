USE BluePrint3
GO


--1)-Por cada cliente listar raz�n social, cuit y nombre del tipo de cliente.
Select RazonSocial, CUIT, Nombre from Clientes C inner join TiposCliente T on c.IDTipo = t.ID;

-- 2)- Por cada cliente listar raz�n social, cuit y nombre de la ciudad y nombre del pa�s. S�lo de aquellos clientes que posean ciudad y pa�s
Select RazonSocial, CUIT, p.Nombre as pais, ci.Nombre as ciudad
from Clientes c 
inner join Ciudades ci on c.IDCiudad = ci.ID
inner join Paises p on p.ID = ci.IDPais;

--3)- Por cada cliente listar raz�n social, cuit y nombre de la ciudad y nombre del pa�s. 
--Listar tambi�n los datos de aquellos clientes que no tengan ciudad relacionada.
Select RazonSocial, CUIT, p.Nombre as pais, ci.Nombre as ciudad
from Clientes c 
left join Ciudades ci on c.IDCiudad = ci.ID
left join Paises p on p.ID = ci.IDPais;

--4)-Por cada cliente listar raz�n social, cuit y nombre de la ciudad y nombre del pa�s.
--Listar tambi�n los datos de aquellas ciudades y pa�ses que no tengan clientes relacionados.
Select RazonSocial, CUIT, p.Nombre as pais, ci.Nombre as ciudad
from Clientes c 
right join Ciudades ci on c.IDCiudad = ci.ID
right join Paises p on p.ID = ci.IDPais;

--5)-Listar los nombres de las ciudades que no tengan clientes asociados.
--Listar tambi�n el nombre del pa�s al que pertenece la ciudad 
Select p.nombre as PAIS, c.nombre AS CIUDAD 
from Ciudades c left join Clientes on Clientes.IDCiudad = c.ID
left join Paises p on p.ID= c.IDPais
where Clientes.IDCiudad is null;

--6)-Listar para cada proyecto el nombre del proyecto, el costo, la raz�n social del cliente,
--el nombre del tipo de cliente y el nombre de la ciudad (si la tiene registrada) 
--de aquellos clientes cuyo tipo de cliente sea 'Extranjero' o 'Unicornio'.
Select proy.Nombre,proy.CostoEstimado,c.RazonSocial,ci.Nombre as Ciudad, TiposCliente.Nombre as Tipo
from Proyectos proy inner join Clientes c on proy.IDCliente = c.ID 
inner join Ciudades ci on ci.ID= c.IDCiudad
inner join TiposCliente on TiposCliente.ID = c.IDTipo
where TiposCliente.Nombre= 'Extranjero' or TiposCliente.Nombre = 'Unicornio';

--7)-Listar los nombre de los proyectos de aquellos clientes que sean de los pa�ses 'Argentina' o 'Italia'.
Select proy.Nombre, cli.RazonSocial as Cliente, p.Nombre as Paises
from Proyectos proy left join Clientes cli on proy.IDCliente= cli.ID
left join Ciudades on Ciudades.ID = cli.IDCiudad
left join Paises p on p.ID = Ciudades.IDPais
where p.Nombre = 'Argentina' or  p.Nombre = 'Italia'

--8)-Listar para cada m�dulo el nombre del m�dulo, el costo estimado del m�dulo, el nombre del proyecto,
--la descripci�n del proyecto y el costo estimado del proyecto de todos aquellos proyectos que hayan finalizado
Select mod.Nombre, mod.CostoEstimado, p.Nombre, p.Descripcion, p.CostoEstimado
from Modulos mod left join Proyectos p on mod.IDProyecto=p.ID
where p.FechaFin < getdate()

--9)-Listar los nombres de los m�dulos y el nombre del proyecto de aquellos m�dulos 
--cuyo tiempo estimado de realizaci�n sea de m�s de 100 horas.
Select mod.Nombre,  p.Nombre
from Modulos mod left join Proyectos p on mod.IDProyecto=p.ID
where mod.TiempoEstimado> '100'

--10)-Listar nombres de m�dulos, nombre del proyecto, descripci�n y tiempo estimado de aquellos m�dulos 
--cuya fecha estimada de fin sea mayor a la fecha real de fin y el costo estimado del proyecto sea mayor a cien mil.
Select mod.Nombre as NombreModulo,  p.Nombre as NombreProyecto, mod.Descripcion as Descripcion, mod.TiempoEstimado
from Modulos mod left join Proyectos p on mod.IDProyecto=p.ID
where mod.FechaEstimadaFin > mod.FechaFin and p.CostoEstimado > '100000'

--11)-Listar nombre de proyectos, sin repetir, que registren m�dulos que hayan finalizado antes que el tiempo estimado
Select DISTINCT( p.Nombre) as Nombre from Proyectos p left join Modulos on p.ID= Modulos.IDProyecto
where Modulos.FechaFin <Modulos.FechaEstimadaFin

--12)-Listar nombre de ciudades, sin repetir, que no registren clientes pero s� colaboradores
Select DISTINCT(c.Nombre) as NombreCiudad from Ciudades c 
inner join Colaboradores on Colaboradores.IDCiudad= c.ID  left join Clientes on Clientes.IDCiudad = c.ID
where Clientes.IDCiudad is null and Colaboradores.IDCiudad is not null

--13)-Listar el nombre del proyecto y nombre de m�dulos de aquellos m�dulos que contengan la palabra 'login' en su nombre o descripci�n
Select p.Nombre, m.Nombre from Proyectos p inner join Modulos m on p.ID = m.IDProyecto
where m.Descripcion like '%login%' and m.Nombre like '%login%'

--14)- Listar el nombre del proyecto y el nombre y apellido de todos los colaboradores
--que hayan realizado alg�n tipo de tarea cuyo nombre contenga 'Programaci�n' o 'Testing'.
--Ordenarlo por nombre de proyecto de manera ascendente.
Select p.Nombre, c.Nombre, c.Apellido From Proyectos p 
inner join Modulos m on m.IDProyecto = p.ID
inner join Tareas on Tareas.IDModulo=m.ID
inner join TiposTarea on TiposTarea.ID = Tareas.IDTipo
inner join Colaboraciones on Colaboraciones.IDTarea = Tareas.ID
inner join Colaboradores c  on c.ID = Colaboraciones.IDColaborador
where TiposTarea.Nombre like '%Programaci�n%' or TiposTarea.Nombre like '%Testing%'
order by p.Nombre asc

--15)-Listar nombre y apellido del colaborador, nombre del m�dulo, nombre del tipo de tarea, precio hora de la colaboraci�n 
--y precio hora base de aquellos colaboradores que hayan cobrado su valor hora de colaboraci�n m�s del 50% del valor hora base.
Select Colaboradores.Nombre, Colaboradores.Apellido, Modulos.Nombre, TiposTarea.Nombre, Colaboraciones.PrecioHora,
TiposTarea.PrecioHoraBase
from
Modulos left join Tareas on Modulos.ID = Tareas.IDModulo
left join TiposTarea on TiposTarea.ID = Tareas.IDTipo
left join Colaboraciones on Tareas.ID= Colaboraciones.IDTarea
left join Colaboradores on Colaboradores.ID= Colaboraciones.IDColaborador
where Colaboraciones.PrecioHora > TiposTarea.PrecioHoraBase*1.5

--16)-Listar nombres y apellidos de las tres colaboraciones de colaboradores externos que m�s hayan demorado 
--en realizar alguna tarea cuyo nombre de tipo de tarea contenga 'Testing'.
Select top (3) Colaboradores.Nombre, Colaboradores.Apellido , Colaboraciones.Tiempo
from Colaboradores inner join Colaboraciones on Colaboradores.ID= Colaboraciones.IDColaborador
inner join Tareas on Tareas.ID=Colaboraciones.IDTarea
inner join TiposTarea on TiposTarea.ID=Tareas.IDTipo
where TiposTarea.Nombre like '%Testing%' and Colaboradores.Tipo = 'E'
order by Colaboraciones.Tiempo desc

--17)-Listar apellido, nombre y mail de los colaboradores argentinos que sean internos y cuyo mail no contenga '.com'.
Select Colaboradores.Nombre, Colaboradores.Apellido, Colaboradores.EMail from Colaboradores
inner join Ciudades on Colaboradores.IDCiudad= Ciudades.ID
inner join Paises on Ciudades.IDPais= Paises.ID
where Paises.Nombre ='Argentina' and Colaboradores.Tipo = 'I' and Colaboradores.EMail not like '%.com%'

--18)-Listar nombre del proyecto, nombre del m�dulo y tipo de tarea de aquellas tareas realizadas por colaboradores externos.

Select Proyectos.Nombre as Proyecto, Modulos.Nombre as Modulo, TiposTarea.Nombre from Proyectos
inner join Modulos on Modulos.IDProyecto= Proyectos.ID
inner join Tareas on Modulos.ID= Tareas.IDModulo
inner join TiposTarea on Tareas.IDTipo= TiposTarea.ID
inner join Colaboraciones on Tareas.ID= Colaboraciones.IDTarea
inner join Colaboradores on Colaboraciones.IDColaborador= Colaboradores.ID
Where Colaboradores.Tipo= 'E'

--19)-Listar nombre de proyectos que no hayan registrado tareas.
Select Proyectos.Nombre from Proyectos 
inner join Modulos on Proyectos.ID= Modulos.IDProyecto
inner join Tareas on Modulos.ID= Tareas.IDModulo
Where Tareas.ID is null


--20)-Listar apellidos y nombres, sin repeticiones, de aquellos colaboradores que hayan trabajado en alg�n proyecto que a�n no haya finalizado
Select DISTINCT(Colaboradores.Apellido) ,Colaboradores.Nombre from Colaboradores
inner join Colaboraciones on Colaboraciones.IDColaborador= Colaboradores.ID
inner join Tareas on Colaboraciones.IDTarea= Tareas.ID
inner join Modulos on Modulos.ID= Tareas.IDModulo
inner join Proyectos on Modulos.IDProyecto= Proyectos.ID
where Proyectos.FechaFin is null











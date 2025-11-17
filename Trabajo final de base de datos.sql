/*Creacion del esquema.*/
create schema fabrica_automoviles;
use fabrica_automoviles;

/*Creacion de tablas.*/
create table proveedor(
  id_proveedor int auto_increment primary key,
  nombre varchar(45) not null,
  telefono varchar(45),
  email varchar(45)
);
create table insumo(
id_insumo int auto_increment primary key,
codigo varchar(45) not null,
descripcion varchar(45),
precio int not null
);
create table proveedor_insumo(
    id_proveedor int,
    id_insumo int,
    primary key (id_proveedor, id_insumo),
    foreign key (id_proveedor) references proveedor(id_proveedor),
    foreign key (id_insumo) references insumo(id_insumo)
);
create table modelo(
    id_modelo int auto_increment primary key,
    nombre varchar(45) not null,
    descripcion varchar(45)
);
create table lineamontaje(
    id_linea int auto_increment primary key,
    nombre varchar(45),
    capacidad_mensual int,
    id_modelo int,
    foreign key (id_modelo) references modelo(id_modelo)
);
create table concesionario(
    id_concesionario int auto_increment primary key,
    nombre varchar(50),
    direccion varchar(45),
    telefono varchar(50)
);
create table pedido(
    id_pedido int auto_increment primary key,
    id_concesionario int,
    fecha date,
    estado varchar(45),
    foreign key (id_concesionario) references concesionario(id_concesionario)
);
create table detallepedido(
    id_detalle int auto_increment primary key,
    id_pedido int,
    id_modelo int,
    cantidad int,
    foreign key (id_pedido) references pedido(id_pedido),
    foreign key (id_modelo) references modelo(id_modelo)
);
/*ABM (altas bajas y modificaciones .*/
insert into proveedor (nombre, telefono, email) values ('autopartes delta', '4300-1111', 'deltacar@gmail.com');
insert into proveedor (nombre, telefono, email) values ('metalpar s.a', '4200-2222', 'pampeana@gmail.com');
insert into proveedor (nombre, telefono, email) values ('electro soluciones', '4123-3333', 'electro@gmail.com');
insert into proveedor (nombre, telefono, email) values ('plastix srl', '4999-4444', 'plastix@gmail.com');
insert into proveedor (nombre, telefono, email) values ('pinturas maxcolor', '4777-5555', 'maxcolor@gmail.com');
insert into proveedor (nombre, telefono, email) values ('rodados sur', '4555-6666', 'rodados@hotmail.com');

insert into insumo (codigo, descripcion, precio) values ('BFHJ87','burro de arranque',140000);
insert into insumo (codigo, descripcion, precio) values ('KJDJ27','motor fiat 1.6 16v',1400000);
insert into insumo (codigo, descripcion, precio) values ('OPFJ33','fusibles electronicos',45000);
insert into insumo (codigo, descripcion, precio) values ('ÑLFJ65','llanta aleacion 17',80000);
insert into insumo (codigo, descripcion, precio) values ('SHDJ00','neumatico 225/55',76000);
insert into insumo (codigo, descripcion, precio) values ('DJHJ17','sogas led',15000);

insert into modelo (nombre, descripcion) values ('palio', 'hatchback de 5 puertas');
insert into modelo (nombre, descripcion) values ('polo', 'sedan 4 puertas');
insert into modelo (nombre, descripcion) values ('eco sport', 'suv 5 puertas');

insert into concesionario (nombre, direccion, telefono) values ('Concesionaria Sur', 'Av. Irigoyen 4562', '3794550011');
insert into concesionario (nombre, direccion, telefono) values ('Autos del Sur', 'Mitre 887', '3794882200');
insert into concesionario (nombre, direccion, telefono) values ('CABA Automotores', 'Corrientes 987', '3794553366');

insert into pedido (id_concesionario, fecha) values (1, '2025-11-13');
insert into pedido (id_concesionario, fecha) values (2, '2025-11-14');
insert into pedido (id_concesionario, fecha) values (1, '2025-11-15');

delete from proveedor where nombre = 'autopartes delta';
delete from proveedor where nombre = 'metalpar s.a';
delete from proveedor where id_proveedor = 6; -- rodados sur
update proveedor set telefono = '4300-9999' where nombre = 'autopartes delta';
update proveedor set email = 'metalpar_update@gmail.com' where nombre = 'metalpar s.a';
update proveedor set telefono = '4555-0000' where nombre = 'rodados sur';

delete from insumo where descripcion = 'burro de arranque';
delete from insumo where descripcion = 'llanta aleacion 17';
delete from insumo where descripcion = 'sogas led';
update insumo set descripcion = 'motor fiat 1.4 fire' where descripcion = 'motor fiat 1.6 16v';
update insumo set descripcion = 'bomba de agua' where descripcion = 'fusibles electronicos';
update insumo set descripcion = 'neumatico 210/45' where descripcion = 'neumatico 225/55';
/*--*/
delete from modelo where nombre = 'eco sport';
update modelo set descripcion = 'fiat 1' where nombre = 'palio';
update modelo set nombre = 'bora' where nombre = 'polo';

delete from concesionario where nombre = 'Concesionaria Sur';
delete from concesionario where id_concesionario = 2;
update concesionario set nombre = 'CABA Autos' where nombre = 'CABA Automotores';

delete from pedido where id_pedido = 1;
update pedido set id_concesionario = 1 where id_pedido = 2;
update pedido set fecha = '2025-11-20' where id_pedido = 3;
/*--*/
/*Consultas basicas con SELECT .*/
select * from proveedor;
select * from insumo;
select * from modelo_vehiculo;
select * from concesionario;
select * from pedido;
select * from pedido_detalle;

/*Consultas avanzadas con INNER JOIN .*/
select 
    p.id_pedido,
    p.fecha,
    c.nombre as concesionario
from pedido p
inner join concesionario c
    on p.id_concesionario = c.id_concesionario;
select 
    c.nombre,
    count(p.id_pedido) as total_pedidos
from concesionario c
left join pedido p
    on c.id_concesionario = p.id_concesionario
group by c.nombre;

/*Procedure de las 7 tablas.*/

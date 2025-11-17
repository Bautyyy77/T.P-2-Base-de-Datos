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
delimiter $$
create procedure alta_proveedor(
    in p_nombre varchar(45),
    in p_telefono varchar(45),
    in p_email varchar(45)
)
begin
    insert into proveedor(nombre, telefono, email)
    values (p_nombre, p_telefono, p_email);

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure baja_proveedor(
    in p_id int
)
begin
    delete from proveedor where id_proveedor = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure modificar_proveedor(
    in p_id int,
    in p_nombre varchar(45),
    in p_telefono varchar(45),
    in p_email varchar(45)
)
begin
    update proveedor
    set nombre = p_nombre,
        telefono = p_telefono,
        email = p_email
    where id_proveedor = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure alta_insumo(
    in p_codigo varchar(45),
    in p_descripcion varchar(45),
    in p_precio int
)
begin
    insert into insumo(codigo, descripcion, precio)
    values (p_codigo, p_descripcion, p_precio);

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure baja_insumo(
    in p_id int
)
begin
    delete from insumo where id_insumo = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure modificar_insumo(
    in p_id int,
    in p_codigo varchar(45),
    in p_descripcion varchar(45),
    in p_precio int
)
begin
    update insumo
    set codigo = p_codigo,
        descripcion = p_descripcion,
        precio = p_precio
    where id_insumo = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure alta_concesionario(
    in p_nombre varchar(50),
    in p_direccion varchar(45),
    in p_telefono varchar(50)
)
begin
    insert into concesionario(nombre, direccion, telefono)
    values (p_nombre, p_direccion, p_telefono);

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;
delimiter $$
create procedure baja_concesionario(
    in p_id int
)
begin
    delete from concesionario where id_concesionario = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure modificar_concesionario(
    in p_id int,
    in p_nombre varchar(50),
    in p_direccion varchar(45),
    in p_telefono varchar(50)
)
begin
    update concesionario
    set nombre = p_nombre,
        direccion = p_direccion,
        telefono = p_telefono
    where id_concesionario = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure alta_pedido(
    in p_id_concesionario int,
    in p_fecha date,
    in p_estado varchar(45)
)
begin
    insert into pedido(id_concesionario, fecha, estado)
    values (p_id_concesionario, p_fecha, p_estado);

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure baja_pedido(
    in p_id int
)
begin
    delete from detallepedido where id_pedido = p_id;
    delete from pedido where id_pedido = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure modificar_pedido(
    in p_id int,
    in p_estado varchar(45)
)
begin
    update pedido
    set estado = p_estado
    where id_pedido = p_id;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure alta_detallepedido(
    in p_id_pedido int,
    in p_id_modelo int,
    in p_cantidad int
)
begin
    insert into detallepedido(id_pedido, id_modelo, cantidad)
    values (p_id_pedido, p_id_modelo, p_cantidad);

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;
delimiter $$
create procedure baja_detallepedido(
    in p_id_detalle int
)
begin
    delete from detallepedido where id_detalle = p_id_detalle;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;

delimiter $$
create procedure modificar_detallepedido(
    in p_id_detalle int,
    in p_id_modelo int,
    in p_cantidad int
)
begin
    update detallepedido
    set id_modelo = p_id_modelo,
        cantidad = p_cantidad
    where id_detalle = p_id_detalle;

    select 0 as nresultado, '' as cmensaje;
end$$
delimiter ;
/*Call de los procedures.*/
call alta_proveedor('autopartes delta', '4300-1111', 'delta_mod@gmail.com');
call alta_proveedor('ugarte s.a', '4123-3333', 'metalpar_update@gmail.com');
call alta_proveedor('plastix srl', '4999-4444', 'electro_new@gmail.com');
call baja_proveedor(1);
call baja_proveedor(2);
call baja_proveedor(3);
call modificar_proveedor(1, 'autopartes delta', '4300-1111', 'delta_mod@gmail.com');
call modificar_proveedor(2, 'ugarte s.a', '4123-3333', 'metalpar_update@gmail.com');
call modificar_proveedor(3, 'plastix srl', '4999-4444', 'electro_new@gmail.com');

call alta_insumo('BFHJ87','burro de arranque',140000);
call alta_insumo('KJDJ27','motor fiat 1.6 16v',1400000);
call alta_insumo('OPFJ33','fusibles electronicos',45000);
call baja_insumo(1);
call baja_insumo(2);
call baja_insumo(3);
call modificar_insumo(1,'BFHJ87','burro reforzado',160000);
call modificar_insumo(2,'KJDJ27','motor fiat 1.4 fire',1200000);
call modificar_insumo(3,'OPFJ33','bomba de agua',50000);

call alta_concesionario('san jorge concesionaria', 'Av. Irigoyen 4562', '3794550011');
call alta_concesionario('concesionaria pepe', 'Mitre 887', '3794882200');
call alta_concesionario('concesionaria caraza', 'catamarca 987', '3948934940');
call baja_concesionario(1);
call baja_concesionario(2);
call baja_concesionario(3);
call modificar_concesionario(1,'san jorge concesionaria','Av. Irigoyen 9000','3794001111');
call modificar_concesionario(2,'concesionaria pepe','Mitre 834','3794999999');
call modificar_concesionario(3,'concesionaria caraza','catamarca 987','3948934940');

call alta_pedido(1, '2025-11-13', 'pendiente');
call alta_pedido(2, '2025-11-14', 'pendiente');
call alta_pedido(1, '2025-11-20', 'pendiente');
call baja_pedido(1);
call baja_pedido(2);
call baja_pedido(3);
call modificar_pedido(1, 'entregado');
call modificar_pedido(2, 'en proceso');
call modificar_pedido(3, 'cancelado');

call alta_detallepedido(1, 1, 5);
call alta_detallepedido(1, 2, 3);
call alta_detallepedido(2, 1, 2);
call baja_detallepedido(1);
call baja_detallepedido(2);
call baja_detallepedido(3);
call modificar_detallepedido(1, 2, 10);
call modificar_detallepedido(2, 3, 8);
call modificar_detallepedido(3, 1, 4);

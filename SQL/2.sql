//Create tables 

create table branch( 
branchname 	varchar(15)	primary  key,
branchcity	varchar(20),
assets		real
);

create table account(
accno		int	primary key,
branchname	varchar(15),
balance	    	real,
foreign key(branchname) references branch(branchname) 
);

create table customer(
customername	 varchar(20) primary key,
customerstreet		varchar(20),             
customercity		varchar(20)
);

create table depositor(
customername		varchar(20),
accno			int,
primary key(customername, accno),
foreign key(customername) references customer(customername),
foreign key(accno) references account(accno)
);

create table loan(
loannumber		int		primary key,
branchname		varchar(15),
amount			int,
foreign key(branchname) references branch(branchname)
);

create table borrower(
customername		varchar(20),
loannumber		int,
primary key(customername,loannumber),
foreign key(customername) references customer(customername),
foreign key(loannumber) references loan(loannumber)
);

//add values

insert into branch values('sbi','Brooklyn',2000000.0);
insert into branch values('uco','Horizon',100000.0);
insert into branch values('icici','Dallas',15000.0);
insert into branch values('axis','Frankfurt',250000.0);

insert into account values(101,'sbi', 200000);
insert into account values(102,'sbi',1000);
insert into account values(201,'uco',700);
insert into account values(204,'uco',1111);
insert into account values(301,'icici',400000);
insert into account values(302,'icici',750);
insert into account values(401,'axis',150000);
insert into account values(402,'axis',10000);

insert into customer values("Amy","mgroad","Brooklyn");
insert into customer values("Bob","cvraman road","Dallas");
insert into customer values("Carl","magic cross","Horizon");
insert into customer values("Duke","5th main","Frankfurt");
insert into customer values("El","1st cross","Horizon");
insert into customer values("Fin","8th main","Horizon");
insert into customer values("Gigi","kings road","Horizon");

insert into depositor values("Amy",101);
insert into depositor values("Bob",201);
insert into depositor values("Carl",301);
insert into depositor values("Duke",302);

insert into loan values(1,"sbi",100001);
insert into loan values(2,"icici",100000);
insert into loan values(3,"axis",110005);
insert into loan values(4,"sbi",51000);
insert into loan values(5,"sbi",60000);
insert into loan values(6,"icici",55000);
insert into loan values(7,"uco",75000);

insert into borrower values("Fin",1);
insert into borrower values("Gigi",2);
insert into borrower values("El",3);
insert into borrower values("Amy",4);
insert into borrower values("Bob",6);

//Find the names of all customers who street address includes the substring “Main”.

select customername 
from customer  
where customerstreet like '%main%';

//Find the average balance for each customer who lives in Horizon & has at least 3 account.

select avg(a.balance)  
from customer c,account a,depositor d
where c.customercity = 'Horizon' and d.customername=c.customername and  a.accno = d.accno
group by d.customername
having count(*)>=3 ;

//Find all customers with more than one loan.

select customername, count(*) 
from borrower 
group by customername
having count(*) > 1;

//Find all branches with assets greater than at least one branch in Brooklyn

select branchname 
from branch 
where assets > some ( select assets from branch 
where branchname='sbi');

//Find the names of all branches that have assets greater than at least one branch located in Frankfurt.

select branchname 
from branch where assets >  any (select assets
from branch  
where branchcity = 'Frankfurt');

--  1
--  1	Работа с типами данных Date, NULL значениями, трехзначная логика. 
--Возвращение определенных значений в результатах запроса в зависимости от полученных 
--первоначальных значений результата запроса. Выборка в результатах запроса только 
--определенных колонок.

--  1.1	Выбрать из таблицы Orders заказы, которые были доставлены после 5 мая 1998 
--года (колонка shippedDate) включительно и которые доставлены с shipVia >= 2. 
--Формат указания даты должен быть верным при любых региональных настройках. Этот 
--метод использовать далее для всех заданий. Запрос должен выбирать только колонки 
--orderID, shippedDate и shipVia. 

SELECT ORDERID, to_char(shippedDate, 'yyyy-mm-dd') SHIPPEDDATE, SHIPVIA
    FROM ORDERS
    WHERE SHIPPEDDATE > to_date('1998-05-05', 'yyyy-mm-dd')
    AND SHIPVIA >= 2;

--  1.2	Написать запрос, который выводит только недоставленные заказы из таблицы 
--Orders. В результатах запроса высвечивать для колонки shippedDate вместо значений 
--NULL строку ‘Not Shipped’ – необходимо использовать CASЕ выражение. Запрос должен 
--выбирать только колонки orderID и shippedDate.
SELECT ORDERID, NVL(to_char(SHIPPEDDATE),'Not shipped'), CASE WHEN SHIPPEDDATE IS NULL THEN 'Not shipped' END
    FROM ORDERS
    WHERE SHIPPEDDATE IS NULL;
    
--  1.3	Выбрать из таблици Orders заказы, которые были доставлены после 5 мая 1998 
--года (shippedDate), не включая эту дату, или которые еще не доставлены. Запрос 
--должен выбирать только колонки orderID (переименовать в Order Number) и shippedDate 
--(переименовать в Shipped Date). В результатах запроса  для колонки shippedDate 
--вместо значений NULL выводить строку ‘Not Shipped’ (необходимо использовать функцию 
--NVL), для остальных значений высвечивать дату в формате “ДД.ММ.ГГГГ”.
SELECT ORDERID, NVL(to_char(SHIPPEDDATE,'dd.mm.yyyy'),'Not shipped') AS "Shipped Date"
    FROM ORDERS
    WHERE SHIPPEDDATE > to_date('1998-05-05','yyyy-mm-dd')
    OR SHIPPEDDATE IS NULL;
    
--  2	Использование операторов IN, DISTINCT, ORDER BY, NOT

--  2.1	Выбрать из таблицы Customers всех заказчиков, проживающих в USA или Canada. 
--Запрос сделать с только помощью оператора IN. Запрос должен выбирать колонки с 
--именем пользователя и названием страны. Упорядочить результаты запроса по имени 
--заказчиков и по месту проживания.
SELECT COMPANYNAME || ', ' || CONTACTNAME AS "Customer", COUNTRY
    FROM CUSTOMERS
    WHERE COUNTRY IN ('USA','Canada');

--  2.2	Выбрать из таблицы Customers всех заказчиков, не проживающих в USA и 
--Canada. Запрос сделать с помощью оператора IN. Запрос должен выбирать колонки с 
--именем пользователя и названием страны. Упорядочить результаты запроса по имени 
--заказчиков в порядке убывания.
SELECT COMPANYNAME || ', ' || CONTACTNAME AS "Customer", COUNTRY
    FROM CUSTOMERS
    WHERE COUNTRY NOT IN ('USA','Canada')
    ORDER BY "Customer" DESC;

--  2.3	Выбрать из таблицы Customers все страны, в которых проживают заказчики. 
--Страна должна быть упомянута только один раз, Результат должен быть отсортирован 
--по убыванию. Не использовать предложение GROUP BY.
SELECT DISTINCT COUNTRY
    FROM CUSTOMERS
    ORDER BY COUNTRY DESC;

--  3	Использование оператора BETWEEN, DISTINCT

--  3.1	Выбрать все заказы из таблицы Order_Details (заказы не должны повторяться), 
--где встречаются продукты с количеством от 3 до 10 включительно – это колонка 
--Quantity в таблице Order_Details. Использовать оператор BETWEEN. Запрос должен 
--выбирать только колонку идентификаторы заказов.
SELECT DISTINCT ORDERID
    FROM ORDER_DETAILS
    WHERE QUANTITY BETWEEN 3 AND 10;

--  3.2	Выбрать всех заказчиков из таблицы Customers, у которых название страны 
--начинается на буквы из диапазона B и G. Использовать оператор BETWEEN. Проверить, 
--что в результаты запроса попадает Germany. Запрос должен выбирать только колонки 
--сustomerID  и сountry. Результат должен быть отсортирован по значению столбца 
--сountry.
SELECT CUSTOMERID, COUNTRY
    FROM CUSTOMERS
    WHERE COUNTRY BETWEEN 'B' AND 'H'
    ORDER BY COUNTRY;

--  3.3	Выбрать всех заказчиков из таблицы Customers, у которых название страны 
--начинается на буквы из диапазона B и G, не используя оператор BETWEEN. Запрос должен 
--выбирать только колонки сustomerID  и сountry. Результат должен быть отсортирован 
--по значению столбца сountry. 
SELECT CUSTOMERID, COUNTRY
    FROM CUSTOMERS
    WHERE COUNTRY >= 'B' AND COUNTRY <= 'H'
    ORDER BY COUNTRY;
--  С помощью опции “Execute Explain Plan” определить 
--какой запрос предпочтительнее 3.2 или 3.3. В комментариях к текущему запросу 
--необходимо объяснить результат.

--  "expr1 BETWEEN expr2 AND expr3" и "expr2 <= expr1 AND expr1 <= expr3" эквмвалентны

--  4	Использование оператора LIKE

--  4.1	В таблице Products найти все продукты (колонка productName), где встречается 
--подстрока 'chocolade'. Известно, что в подстроке 'chocolade' может быть изменена 
--одна буква 'c' в середине - найти все продукты, которые удовлетворяют этому 
--условию. Подсказка: в результате должны быть найдены 2 строки.
SELECT PRODUCTID, PRODUCTNAME 
    FROM PRODUCTS
    WHERE LOWER(PRODUCTNAME) LIKE '%cho%olade%';
    
--  5	Использование агрегатных функций (SUM, COUNT)

--  5.1	Найти общую сумму всех заказов из таблицы Order_Details с учетом количества 
--закупленных товаров и скидок по ним. Результат округлить до сотых и отобразить в 
--стиле: $X,XXX.XX, где “$” - валюта доллары, “,” – разделитель групп разрядов, “.” – 
--разделитель целой и дробной части, при этом дробная часть должна содержать цифры 
--до сотых, пример: $1,234.00. Скидка (колонка Discount) составляет процент из 
--стоимости для данного товара. Для определения действительной цены на проданный 
--продукт надо вычесть скидку из указанной в колонке unitPrice цены. Результатом 
--запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'.
SELECT LTRIM(TO_CHAR(SUM(UNITPRICE * QUANTITY * (1 - DISCOUNT)),'$999,999,999,999,999.99')) AS "Totals"
    FROM ORDER_DETAILS;

--  5.2	По таблице Orders найти количество заказов, которые еще не были доставлены 
--(т.е. в колонке shippedDate нет значения даты доставки). Использовать при этом 
--запросе только оператор COUNT. Не использовать предложения WHERE и GROUP.
SELECT COUNT(*) - COUNT(SHIPPEDDATE)
    FROM ORDERS;

--  5.3	По таблице Orders найти количество различных покупателей (сustomerID), 
--сделавших заказы. Использовать функцию COUNT и не использовать предложения 
--WHERE и GROUP.
SELECT COUNT(DISTINCT CUSTOMERID)
    FROM ORDERS;
    
--  6	Явное соединение таблиц, самосоединения, использование агрегатных функций 
--и предложений GROUP BY и HAVING 

--  6.1	По таблице Orders найти количество заказов с группировкой по годам. 
--Запрос должен выбирать две колонки c названиями Year и Total. Написать проверочный 
--запрос, который вычисляет количество всех заказов.
SELECT EXTRACT(YEAR FROM ORDERDATE) AS "Year", COUNT(ORDERID) AS "Total"
    FROM ORDERS
    GROUP BY ROLLUP(EXTRACT(YEAR FROM ORDERDATE));
    
SELECT COUNT(*) FROM ORDERS;

--  6.2	По таблице Orders найти количество заказов, cделанных каждым продавцом. 
--Заказ для указанного продавца – это любая запись в таблице Orders, где в колонке 
--employeeID задано значение для данного продавца. Запрос должен выбирать колонку 
--с полным именем продавца (получается конкатенацией lastName & firstName из таблицы 
--Employees)  с названием колонки ‘Seller’ и колонку c количеством заказов с названием 
--'Amount'. Полное имя продавца должно быть получено отдельным запросом в колонке 
--основного запроса (после SELECT, до FROM). Результаты запроса должны быть 
--упорядочены по убыванию количества заказов. 
SELECT (SELECT E.LASTNAME || ' ' || E.FIRSTNAME
            FROM EMPLOYEES E
            WHERE E.EMPLOYEEID = O.EMPLOYEEID
        ) AS "Seller",
        COUNT(ORDERID) AS "Amount"
    FROM ORDERS O
    GROUP BY EMPLOYEEID
    ORDER BY "Amount" DESC;

--  6.3	Выбрать 5 стран, в которых проживает наибольшее количество заказчиков. 
--Список должен быть отсортирован по убыванию популярности. Запрос должен выбирать 
--два столбца - сountry и Count (количество заказчиков).
SELECT * 
    FROM (
        SELECT COUNTRY AS "Country", COUNT(DISTINCT CUSTOMERID) AS "Count"
            FROM CUSTOMERS
            GROUP BY COUNTRY
            ORDER BY "Count" DESC
    )
    WHERE ROWNUM <= 5;

--  6.4	По таблице Orders найти количество заказов, cделанных каждым продавцом и 
--для каждого покупателя. Необходимо определить это только для заказов, сделанных 
--в 1998 году. Запрос должен выбирать колонку с именем продавца (название колонки 
--‘Seller’), колонку с именем покупателя (название колонки ‘Customer’) и колонку c 
--количеством заказов высвечивать с названием 'Amount'. В запросе необходимо 
--использовать специальный оператор языка PL/SQL для работы с выражением GROUP 
--(Этот же оператор поможет выводить строку “ALL” в результатах запроса). Группировки 
--должны быть сделаны по ID продавца и покупателя. Результаты запроса должны быть 
--упорядочены по продавцу, покупателю и по убыванию количества продаж. В результатах 
--должна быть сводная информация по продажам. Т.е. в результирующем наборе должны 
--присутствовать дополнительно к информации о продажах продавца для каждого покупателя 
--следующие строчки:
--  Seller	Customer	Amount
--  ALL 	ALL         <общее число продаж>
--  <имя>	ALL         <число продаж для данного продавца>
--  ALL	    <имя>       <число продаж для данного покупателя>
--  <имя>	<имя>       <число продаж данного продавца для даннного покупателя>


SELECT NVL((SELECT EMPLOYEES.LASTNAME || ' ' || EMPLOYEES.FIRSTNAME
            FROM EMPLOYEES
            WHERE ORDERS.EMPLOYEEID = EMPLOYEES.EMPLOYEEID
        ),'ALL') AS "Seller",
        NVL((SELECT CUSTOMERS.COMPANYNAME
            FROM CUSTOMERS
            WHERE ORDERS.CUSTOMERID = CUSTOMERS.CUSTOMERID
        ),'ALL') AS "Customer",
        COUNT(*) AS "Amount"
    FROM ORDERS
    WHERE EXTRACT(YEAR FROM ORDERDATE) = 1998
    GROUP BY CUBE(EMPLOYEEID, CUSTOMERID)
    ORDER BY "Seller" ASC, "Customer" ASC, "Amount" DESC;

--  6.5	Найти покупателей и продавцов, которые живут в одном городе. Если в городе 
--живут только продавцы или только покупатели, то информация о таких покупателях и 
--продавцах не должна попадать в результирующий набор. Не использовать конструкцию 
--JOIN или декартово произведение. В результатах запроса необходимо вывести следующие 
--заголовки для результатов запроса: ‘Person’, ‘Type’ (здесь надо выводить строку 
--‘Customer’ или  ‘Seller’ в зависимости от типа записи), ‘City’. Отсортировать 
--результаты запроса по колонкам ‘City’ и ‘Person’.
--  6.5.1
SELECT *
    FROM (
        SELECT COMPANYNAME AS "Person", 'Customer' AS "Type", City AS "City"
            FROM CUSTOMERS
            WHERE EXISTS (SELECT * FROM EMPLOYEES WHERE EMPLOYEES.CITY = CUSTOMERS.CITY)
        UNION
        SELECT LASTNAME || ' ' || FIRSTNAME AS "Person", 'Seller' AS "Type", City AS "City"
            FROM EMPLOYEES
            WHERE EXISTS (SELECT * FROM CUSTOMERS WHERE CUSTOMERS.CITY = EMPLOYEES.CITY)
    )
    ORDER BY "City", "Person";
--  6.5.2
SELECT *
    FROM (
        SELECT COMPANYNAME AS "Person", 'Customer' AS "Type", City AS "City"
            FROM CUSTOMERS
            WHERE CITY IN (SELECT City AS "City" FROM CUSTOMERS
                            INTERSECT
                            SELECT City AS "City" FROM EMPLOYEES)
        UNION
        SELECT LASTNAME || ' ' || FIRSTNAME AS "Person", 'Seller' AS "Type", City AS "City"
            FROM EMPLOYEES
            WHERE CITY IN (SELECT City AS "City" FROM CUSTOMERS
                            INTERSECT
                            SELECT City AS "City" FROM EMPLOYEES)
    )
    ORDER BY "City", "Person";

--  6.6	Найти всех покупателей, которые живут в одном городе. В запросе использовать 
--соединение таблицы Customers c собой - самосоединение. Высветить колонки сustomerID  
--и City. Запрос не должен выбирать дублируемые записи. Отсортировать результаты 
--запроса по колонке City. Для проверки написать запрос, который выбирает города, 
--которые встречаются более одного раза в таблице Customers. Это позволит проверить 
--правильность запроса.
--  6.6.1
SELECT DISTINCT CUSTOMERID, CITY
    FROM CUSTOMERS C1
    WHERE EXISTS (SELECT * FROM CUSTOMERS C2 WHERE C1.CITY = C2.CITY AND C1.CUSTOMERID <> C2.CUSTOMERID);
--  6.6.2
SELECT DISTINCT C1.CUSTOMERID, C1.CITY
    FROM CUSTOMERS C1, CUSTOMERS C2
    WHERE C1.CITY = C2.CITY
    AND C1.CUSTOMERID <> C2.CUSTOMERID;

SELECT CITY, COUNT(*) AS "Count"
    FROM CUSTOMERS
    GROUP BY CITY
    HAVING COUNT(*) > 1;

--  6.7	По таблице Employees найти для каждого продавца его руководителя, т.е. 
--кому он делает репорты. Высветить колонки с именами 'User Name' (lastName) и 'Boss'. 
--Имена должны выбираться из колонки lastName.
SELECT LASTNAME AS "User Name",
    (SELECT LASTNAME FROM EMPLOYEES E2 WHERE E2.EMPLOYEEID = E1.REPORTSTO) AS "Boss"
    FROM EMPLOYEES E1;
--  Выбираются ли все продавцы в этом запросе?
--  Выбираются все, но у Fuller'a Boss пустой, т.к. он никому не отчитывается

--  7	Использование Inner JOIN

--  7.1	Определить продавцов, которые обслуживают регион 'Western' (таблица Region). 
--Запрос должен выбирать: 'lastName' продавца и название обслуживаемой территории 
--(столбец territoryDescription из таблицы Territories). Запрос должен использовать 
--JOIN в предложении FROM. Для определения связей между таблицами Employees и 
--Territories надо использовать графическую схему для базы Southwind.
SELECT LASTNAME, T.TERRITORYDESCRIPTION
    FROM EMPLOYEES E
    JOIN EMPLOYEETERRITORIES ET ON E.EMPLOYEEID = ET.EMPLOYEEID
    JOIN TERRITORIES T ON ET.TERRITORYID = T.TERRITORYID
    WHERE T.REGIONID IN (
        SELECT REGIONID
        FROM REGION
        WHERE REGIONDESCRIPTION = 'Western'
    );

--  8	Использование Outer JOIN
--  8.1	Запрос должен выбирать имена всех заказчиков из таблицы Customers и суммарное 
--количество их заказов из таблицы Orders. Принять во внимание, что у некоторых 
--заказчиков нет заказов, но они также должны быть выведены в результатах запроса. 
--Упорядочить результаты запроса по возрастанию количества заказов.
SELECT NVL(C.COMPANYNAME,'Total:') AS "Customer", COUNT(O.ORDERID) AS "Count"
    FROM CUSTOMERS C
    LEFT JOIN ORDERS O ON O.CUSTOMERID = C.CUSTOMERID
    GROUP BY ROLLUP(C.COMPANYNAME)
    ORDER BY "Count";

--  9	Использование подзапросов

--  9.1	Запрос должен выбирать всех поставщиков (колонка companyName в таблице 
--Suppliers), у которых нет хотя бы одного продукта на складе (unitsInStock в 
--таблице Products равно 0). Использовать вложенный SELECT для этого запроса с 
--использованием оператора IN. Можно ли использовать вместо оператора IN оператор '='?
SELECT COMPANYNAME
    FROM SUPPLIERS
    WHERE SUPPLIERID IN (
        SELECT SUPPLIERID
        FROM PRODUCTS
        WHERE UNITSINSTOCK = 0
    );
--  можно использовать оператор "=" вместо "IN", только в том случае, когда вложенный запрос должен вернуть только одну запись.

--  10	Коррелированный запрос

--  10.1	Запрос должен выбирать имена всех продавцов, которые имеют более 150 
--заказов. Использовать вложенный коррелированный SELECT.
SELECT (SELECT E.LASTNAME || ' ' || E.FIRSTNAME
            FROM EMPLOYEES E
            WHERE E.EMPLOYEEID = O.EMPLOYEEID) AS "Seller"
    FROM ORDERS O
    GROUP BY O.EMPLOYEEID
    HAVING COUNT(*) > 150;
        
--  11	Использование EXISTS

--  11.1	Запрос должен выбирать имена заказчиков (таблица Customers), которые 
--не имеют ни одного заказа (подзапрос по таблице Orders). Использовать 
--коррелированный SELECT и оператор EXISTS.
SELECT C.COMPANYNAME
    FROM CUSTOMERS C
    WHERE NOT EXISTS (SELECT CUSTOMERID FROM ORDERS O WHERE O.CUSTOMERID = C.CUSTOMERID);

--  12	Использование строковых функций

--  12.1	Для формирования алфавитного указателя Employees необходимо написать 
--запрос должен выбирать из таблицы Employees список только тех букв алфавита, с 
--которых начинаются фамилии Employees (колонка lastName) из этой таблицы. Алфавитный 
--список должен быть отсортирован по возрастанию.
SELECT DISTINCT SUBSTR(LASTNAME,1,1) AS "LETTER"
    FROM EMPLOYEES
    ORDER BY LETTER;
    
--  13	Разработка функций и процедур

--  13.1	Написать процедуру, которая возвращает самый крупный заказ для каждого 
--из продавцов за определенный год. В результатах не может быть несколько заказов 
--одного продавца, должен быть только один и самый крупный. В результатах запроса 
--должны быть выведены следующие колонки: колонка с именем и фамилией продавца 
--(firstName и lastName – пример: Nancy Davolio), номер заказа и его стоимость. В 
--запросе надо учитывать Discount при продаже товаров. Процедуре передается год, 
--за который надо сделать отчет, и количество возвращаемых записей. Результаты 
--запроса должны быть упорядочены по убыванию суммы заказа. Название процедуры 
--GreatestOrders. Необходимо продемонстрировать использование этой процедуры.

--Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.

--Также помимо демонстрации вызова процедуры в скрипте Query.sql надо написать 
--отдельный ДОПОЛНИТЕЛЬНЫЙ проверочный запрос для тестирования правильности работы 
--процедуры GreatestOrders. Проверочный запрос должен выводить в удобном для 
--сравнения с результатами работы процедур виде для определенного продавца для всех 
--его заказов за определенный указанный год в результатах следующие колонки: имя 
--продавца, номер заказа, сумму заказа. Проверочный запрос не должен повторять 
--запрос, написанный в процедуре, - он должен выполнять только то, что описано 
--в требованиях по нему.

BEGIN
    GREATESTORDERS(1998);
END;
/

--  13.2	Написать процедуру, которая возвращает заказы в таблице Orders, согласно 
--указанному сроку доставки в днях (разница между orderDate и shippedDate).  
--В результатах должны быть возвращены заказы, срок которых превышает переданное 
--значение или еще недоставленные заказы. Значению по умолчанию для передаваемого 
--срока 35 дней. Название процедуры ShippedOrdersDiff. Процедура должна выводить 
--следующие колонки: orderID, orderDate, shippedDate, ShippedDelay (разность в днях 
--между shippedDate и orderDate), specifiedDelay (переданное в процедуру значение).  
--Результат должен быть отсортирован по shippedDelay. 
--Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
--Необходимо продемонстрировать использование этой процедуры.

BEGIN
    SHIPPEDORDERSDIFF();
END;
/

--  13.3	Написать процедуру, которая выводит всех подчиненных заданного продавца, 
--как непосредственных, так и подчиненных его подчиненных. В качестве входного 
--параметра процедуры используется employeeID. Необходимо вывести столбцы employeeID, 
--имена подчиненных и уровень вложенности согласно иерархии подчинения. Продавец, 
--для которого надо найти подчиненных также должен быть высвечен. Название процедуры 
--SubordinationInfo. Необходимо использовать конструкцию START WITH … CONNECT BY. 

--Продемонстрировать использование процедуры. 
BEGIN
    SUBORDINATIONINFO(5);
END;
/
--  Написать проверочный запрос, который вывод всё дерево продавцов.
SELECT EMPLOYEEID, LPAD(' ', 2 * (LEVEL-1)) || LASTNAME || ' ' || FIRSTNAME AS "NAME"
    FROM EMPLOYEES
    START WITH REPORTSTO IS NULL
    CONNECT BY PRIOR EMPLOYEEID = REPORTSTO
    ORDER SIBLINGS BY (LASTNAME || ' ' || FIRSTNAME);

--  13.4	Написать функцию, которая определяет, есть ли у продавца подчиненные 
--и возвращает их количество - тип данных INTEGER. В качестве входного параметра 
--функции используется employeeID. Название функции IsBoss. Продемонстрировать 
--использование функции для всех продавцов из таблицы Employees.
SELECT EMPLOYEEID, LASTNAME || ' ' || FIRSTNAME AS "NAME", ISBOSS(EMPLOYEEID) AS "SUBORDINAL COUNT"
    FROM EMPLOYEES;
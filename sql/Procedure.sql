--  13.1
create or replace PROCEDURE GreatestOrders(p_year IN NUMBER) IS
    CURSOR cur_get_orders IS
        WITH src AS (
            SELECT O.EMPLOYEEID, OD.ORDERID, TO_CHAR(SUM(OD.UNITPRICE * OD.QUANTITY * (1 - OD.DISCOUNT)),'999,999,999.99') SUMM
              FROM ORDERS O
              JOIN ORDER_DETAILS OD ON O.ORDERID = OD.ORDERID
              WHERE EXTRACT(YEAR FROM O.ORDERDATE) = p_year
              GROUP BY O.EMPLOYEEID, OD.ORDERID
        )
        SELECT t3.LASTNAME || ' ' || t3.FIRSTNAME AS FULLNAME, t1.ORDERID, t1.SUMM
            FROM src t1
            JOIN (SELECT EMPLOYEEID, MAX(SUMM) MAXSUM
                    FROM src 
                    GROUP BY EMPLOYEEID) t2
            ON T1.EMPLOYEEID = T2.EMPLOYEEID
            JOIN EMPLOYEES t3
            ON t2.EMPLOYEEID = t3.EMPLOYEEID
            AND T1.SUMM = T2.MAXSUM
            ORDER BY t1.SUMM DESC;
    v_get cur_get_orders%ROWTYPE;
BEGIN
    SYS.DBMS_OUTPUT.ENABLE;
    OPEN cur_get_orders;
    LOOP
        FETCH cur_get_orders INTO v_get;
        EXIT WHEN cur_get_orders%NOTFOUND;
        SYS.DBMS_OUTPUT.PUT_LINE(v_get.FULLNAME || CHR(9) || v_get.ORDERID || CHR(9) || LTRIM(v_get.SUMM));
    END LOOP;
    CLOSE cur_get_orders;
END GreatestOrders;
/
--  13.2
create or replace PROCEDURE ShippedOrdersDiff(p_specified_delay IN NUMBER := 35) IS
    CURSOR cur_get_orders IS
        SELECT ORDERID, ORDERDATE, SHIPPEDDATE, NVL2(SHIPPEDDATE, to_char(SHIPPEDDATE-ORDERDATE), 'Not Shipped') AS "SHIPPEDDELAY"
            FROM ORDERS
            WHERE (SHIPPEDDATE-ORDERDATE) > p_specified_delay
            OR SHIPPEDDATE IS NULL;
    v_get cur_get_orders%ROWTYPE;
BEGIN
    SYS.DBMS_OUTPUT.ENABLE;
    SYS.DBMS_OUTPUT.PUT_LINE('?' || CHR(9) || 'ORDERID' || CHR(9) || 'ORDERDATE' || CHR(9) || 'SHIPPEDDATE' || CHR(9) || 'SHIPPEDDELAY' || CHR(9) || 'SPECIFIEDDELAY');
    OPEN cur_get_orders;
    LOOP
        FETCH cur_get_orders INTO v_get;
        EXIT WHEN cur_get_orders%NOTFOUND;
        SYS.DBMS_OUTPUT.PUT_LINE(cur_get_orders%ROWCOUNT || CHR(9) || v_get.ORDERID || CHR(9) || v_get.ORDERDATE || CHR(9) || v_get.SHIPPEDDATE || CHR(9) || v_get.SHIPPEDDELAY || CHR(9) || p_specified_delay);        
    END LOOP;
    CLOSE cur_get_orders;
END ShippedOrdersDiff;
/
--  13.3
create or replace PROCEDURE SubordinationInfo(p_employee_id IN NUMBER := NULL) IS
    CURSOR cur_get_employees IS
        SELECT EMPLOYEEID, LPAD(' ', 2 * (LEVEL-1)) || LASTNAME || ' ' || FIRSTNAME "NAME", LEVEL
            FROM EMPLOYEES
            START WITH EMPLOYEEID = p_employee_id
            CONNECT BY PRIOR EMPLOYEEID = REPORTSTO
            ORDER SIBLINGS BY (LASTNAME || ' ' || FIRSTNAME);
    v_get cur_get_employees%ROWTYPE;
BEGIN
    SYS.DBMS_OUTPUT.ENABLE;
    OPEN cur_get_employees;
    LOOP
        FETCH cur_get_employees INTO v_get;
        EXIT WHEN cur_get_employees%NOTFOUND;
        SYS.DBMS_OUTPUT.PUT_LINE(v_get.EMPLOYEEID || CHR(9) || v_get."NAME" || CHR(9) || v_get.LEVEL);
    END LOOP;
    CLOSE cur_get_employees;
END SubordinationInfo;
/
--  13.4
create or replace FUNCTION ISBOSS(p_employee_id IN NUMBER := NULL) RETURN INTEGER IS
    v_out INTEGER;
BEGIN
    v_out := 0;
    SELECT COUNT(*) INTO v_out
        FROM EMPLOYEES            
        WHERE LEVEL > 1
        START WITH EMPLOYEEID = p_employee_id
        CONNECT BY PRIOR EMPLOYEEID = REPORTSTO;
    RETURN(v_out);
END ISBOSS;
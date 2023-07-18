CREATE TRIGGER BLOCK_DEL_EMP
    ON EMP
    FOR DELETE
    AS
BEGIN
    ROLLBACK;
END
GO

CREATE TRIGGER EMP_SET_COMM_0
    ON EMP
    FOR INSERT
    AS
BEGIN
    UPDATE EMP SET COMM = 0 WHERE EMPNO IN (SELECT EMPNO FROM inserted WHERE inserted.COMM IS NULL);
END
GO

CREATE TRIGGER EMP_SAL_1000
    ON EMP
    FOR INSERT, UPDATE
    AS
BEGIN
    IF EXISTS(SELECT 1 FROM inserted WHERE inserted.SAL <= 1000)
        BEGIN
            RAISERROR ('Pensja musi byc wieksza niz 1000!', 10, 1);
            ROLLBACK;
        END
END
GO

CREATE TABLE budzet
(
    wartosc INT NOT NULL
);

INSERT INTO budzet (wartosc)
SELECT SUM(sal)
FROM emp;

CREATE TRIGGER SUM_SAL
    ON EMP
    FOR INSERT, UPDATE, DELETE
    AS
BEGIN
    UPDATE budzet SET wartosc = (SELECT SUM(SAL) FROM EMP);
END
GO

CREATE TRIGGER DEPT_NAME
    ON DEPT
    FOR UPDATE
    AS
BEGIN
    IF EXISTS(SELECT d.DEPTNO
              FROM deleted d
                       INNER JOIN inserted i ON d.DEPTNO = i.DEPTNO
              WHERE i.DNAME != d.DNAME)
        ROLLBACK
END
GO

CREATE TRIGGER MULTI_EMP
    ON EMP
    FOR INSERT, UPDATE, DELETE
    AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) = 0
        BEGIN
            IF EXISTS(SELECT empno FROM deleted WHERE SAL > 0)
                BEGIN
                    ROLLBACK;
                END
        END
    ELSE
        IF (SELECT COUNT(*) FROM deleted) = 0
            BEGIN
                IF EXISTS(SELECT empno
                          FROM inserted i
                          WHERE ename IN (SELECT ename FROM emp e WHERE e.empno != i.empno))
                    BEGIN
                        ROLLBACK;
                    END
            END
        ELSE
            BEGIN
                IF EXISTS(SELECT i.ENAME
                          FROM inserted i
                                   INNER JOIN deleted d ON i.EMPNO = d.EMPNO
                          WHERE i.ENAME != d.ENAME)
                    BEGIN
                        ROLLBACK;
                    END
            END
END
GO

CREATE TRIGGER MULTI_EMP_2
    ON EMP
    FOR UPDATE, DELETE AS
BEGIN
    IF (SELECT COUNT(*) FROM inserted) = 0
        ROLLBACK;
    ELSE
        IF EXISTS(SELECT d.EMPNO
                  FROM inserted i
                           INNER JOIN deleted d ON i.EMPNO = d.EMPNO
                  WHERE i.sal < d.SAL)
            ROLLBACK;
END
GO
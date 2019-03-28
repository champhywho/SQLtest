-- 创建数据库
CREATE DATABASE jichu;

-- 创建表 student\course\score，指定数据类型，设置非空和主键约束
CREATE TABLE student
(Sno varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Ssex varchar(20) NOT NULL,
Sage INTEGER ,
Sdept varchar(20) NOT NULL,
PRIMARY KEY (Sno)
);

CREATE TABLE course
(Cno varchar(20) NOT NULL,
Cname varchar(20) NOT NULL,
Hours VARCHAR(20) NOT NULL,
PRIMARY KEY (Cno)
);

CREATE TABLE score
(Sno varchar(20) NOT NULL,
Cno varchar(20) NOT NULL,
Grade INTEGER ,
PRIMARY KEY (Sno,Cno)
);
-- 插入数据步骤略

-- 1.1 查询成绩80分以上的学生的姓名、课程号、成绩，并按成绩的降序排列结果
-- 通过内联结并表，where条件取数，order排序
SELECT ST.Sname,SC.Cno,SC.Grade
FROM student AS ST JOIN score  AS SC 
ON ST.Sno = SC.Sno
WHERE SC.grade > 80
ORDER BY SC.grade DESC;

-- 1.2 查询数学成绩80分以上的学生的学号、姓名
-- 通过子查询实现条件筛选
SELECT Sno,Sname
FROM student
WHERE dept = '数学系' AND Sno in 
(SELECT Sno 
FROM score 
WHERE Grade > 80);

-- 1.3 将所有选修了"c01"课程的学生的成绩加10分
-- 更新的基础运用 UPDATE <表名> SET <列名> = <表达式> WHERE <条件>；
UPDATE score
SET grade = grade + 10
WHERE Cno = 'C01'




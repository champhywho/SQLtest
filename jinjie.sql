-- 创建数据库
CREATE DATABASE jinjie;

-- 创建表 student\course\score\teacher，指定数据类型，设置非空和主键约束
-- 由于只能使用半角英文字母、数字、下划线(_)作为数据库、表和 列的名称，因此表仅在jinchu数据库上略做修改
CREATE TABLE student
(Sno varchar(20) NOT NULL,
Sname varchar(20) NOT NULL,
Sage INTEGER ,
Ssex varchar(20) NOT NULL,
PRIMARY KEY (Sno)
);

CREATE TABLE teacher
(Tno varchar(20) NOT NULL,
Tname varchar(20) NOT NULL,
PRIMARY KEY (Tno)
);

CREATE TABLE course
(Cno varchar(20) NOT NULL,
Cname varchar(20) NOT NULL,
Tno varchar(20) NOT NULL,
PRIMARY KEY (Cno)
);

CREATE TABLE score
(Sno varchar(20) NOT NULL,
Cno varchar(20) NOT NULL,
Grade INTEGER,
PRIMARY KEY (Sno,Cno)
);

-- 插入数据步骤略
-- 2.1 把成绩表中朱清时老师教的课的成绩改为此课程的平均成绩
-- 先复制score表，保证avg取值不受影响
-- 先将teacher和course内联结，确认朱清时老师的课程编号
-- 然后通过标量子查询更新grade
-- 之后删除score_2
create table score_2 
select * from score; 

UPDATE score
SET Grade=
(SELECT AVG(score_2.Grade) 
FROM score_2
WHERE score_2.Cno=score.Cno)
WHERE Cno= 
(SELECT Cno 
FROM course AS Co INNER JOIN teacher AS Te
ON Co.Tno=Te.Tno 
WHERE Tname='朱清时');

DROP TABLE score_2;

-- 2.2 查询不同课程成绩相同的同学的学号、课程号、学生成绩（学号相同，学号不同的两种情况）
-- 学号相同
SELECT DISTINCT s1.Cno,s2.Cno,s1.Sno,s2.Sno,s1.Grade,s2.Grade
FROM score AS s1, score AS s2 
WHERE s1.Grade = s2.Grade AND s1.Cno <> s2.Cno And s1.Sno = s2.Sno
-- 学号不同
SELECT DISTINCT s1.Cno,s2.Cno,s1.Sno,s2.Sno,s1.Grade,s2.Grade
FROM score AS s1, score AS s2 
WHERE s1.Grade = s2.Grade AND s1.Cno <> s2.Cno And s1.Sno <> s2.Sno

-- 2.3 统计出选修人数最多的课程，需要包含课程名，课程编号，学生名称，分数 四个字段
-- 分别涉及coure、student、score三张表
SELECT Cname,Cno,Sname,Grade
-- 用on子句实现多表联结
FROM score AS Sc INNER JOIN course AS Co
    on Sc.Cno = Co.Cno
    INNER JOIN student as St
    on Sc.Sno = St.Sno
WHERE Cno in(
	SELECT Cno
	FROM score
	GROUP BY score.Cno
    -- 由于max无法嵌套在select语句外，只能用order语句来实现top1的确认
	HAVING count(score.Sno)=(
		SELECT TOP 1 count(score.Cno)
		FROM score
		GROUP BY score.Cno
		ORDER BY count(score.Cno) DESC
		)
	)
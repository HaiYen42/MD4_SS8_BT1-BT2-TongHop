create database Tonghop3_bai2;
use Tonghop3_bai2;
-- 1 (Yến) tạo 4 bảng (như hình)
create table Class
(
    ClassId   int primary key auto_increment,
    ClassName varchar(255) not null,
    StartDate datetime     not null,
    Status    bit
);
Create table Student
(
    StudentId   int primary key,
    StudentName varchar(30) not null,
    Address     varchar(50),
    Phone       varchar(20),
    Status      bit,
    ClassId     int         not null
);
create table Subject
(
    subId   int primary key auto_increment,
    subName varchar(30) not null,
    Credit  tinyint     not null default 1 check (credit >= 1),
    Status  bit                  default 1
);
create table Mark
(
    MarkId    int primary key auto_increment,
    SubId     int not null,
    StudentId int not null,
    Mark      float   default 0 check (mark between 0 and 100),
    ExamTimes tinyint default 1,
    unique (SubId, StudentId)
);
drop table Mark;
-- 2 () Sử dụng câu lệnh sử đổi bảng để thêm các ràng buộc vào các bảng theo mô tả:
-- a (Yến) Thêm ràng buộc khóa ngoại trên cột ClassID của  bảng Student, tham chiếu đến cột ClassID trên bảng Class.
alter table Student
    add foreign key (ClassID) references Class (ClassID);

-- b (Yến) Thêm ràng buộc cho cột StartDate của  bảng Class là ngày hiện hành.
select *
from Class;
alter table Class
    alter column StartDate
        set default (now());

-- Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.
alter table student
    alter column Status
        set default 1;
-- Thêm ràng buộc khóa ngoại cho bảng Mark trên cột:
-- SubID trên bảng Mark tham chiếu đến cột SubID trên bảng Subject
-- StudentID tren bảng Mark tham chiếu đến cột StudentID của bảng Student.
alter table Mark
    add foreign key (SubId) references Subject (subId);

alter table Mark
    add foreign key (StudentId) references Student (StudentId);
-- Tạo bảng Class
insert into Class(ClassId, ClassName, StartDate, Status)
values (1, 'A1', '2008-12-20', 1),
       (2, 'A2', '2008-12-22', 1),
       (3, 'B3', curdate(), 0);
insert into Student (StudentId, StudentName, Address, Phone, Status, ClassId)
values (1, 'Hung', 'Ha Noi', '0912113113', 1, 1),
       (2, 'Hoa', 'Hai Phong', null, 1, 1),
       (3, 'Manh', 'HCM', '0123123123', 0, 2);
insert into Subject(subId, subName, Credit, Status)
values (1, 'CF', 5, 1),
       (2, 'C', 6, 1),
       (3, 'HDJ', 5, 1),
       (4, 'RDBMS', 10, 1);
insert into Mark(MarkId, SubId, StudentId, Mark, ExamTimes)
values (1, 1, 1, 8, 1),
       (2, 1, 2, 10, 2),
       (3, 2, 1, 12, 1);
-- Cập nhật dữ liệu
-- Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
update student
set ClassId =2
where StudentName = 'Hung';
-- Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
update student
set Phone = 'no phone'
where Phone is null;
-- Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
update Class
set ClassName = concat('New ', ClassName)
where Status = 0;

insert into Class(ClassId, ClassName, StartDate, Status)
values (3, 'New B3', curdate(), 0);
-- Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
update Class
set ClassName = replace(ClassName, 'New', 'Old')
where Status = 1
  and ClassName like 'New%';

-- Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
-- Cách 1
update Class c
    left join Student S on c.ClassId = S.ClassId
set c.Status = 0
where StudentName is null;
-- Cách 2:
update Class
set Status =0
where ClassId not in (select ClassId from Student);
-- Cập nhật trạng thái của môn học (bảng subject) là 0 nếu môn học đó chưa có sinh viên dự thi.
update subject
set Status = 0
where subId not in (select subId from Mark);
-- Hiển thị thông tin
-- Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
select StudentName
from student
where StudentName like 'h%';
-- Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
select *
from class
where month(StartDate) = 12;
-- Hiển thị giá trị lớn nhất của credit trong bảng subject.
select Credit
from subject
where Credit = (select max(Credit) from Subject);
-- Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
select *
from subject
where Credit = (select max(Credit) from subject);
-- Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
select *
from subject
where Credit between 3 and 5;
-- Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bản  Class, student
select c.classid, c.className, s.StudentName, s.address
from Student s
         join Class C on s.ClassId = C.ClassId;
-- Hiển thị các thông tin môn học chưa có sinh viên dự thi.
select *
from subject
where subId not in (select subId from mark);
-- Hiển thị các thông tin môn học có điểm thi lớn nhất.
select s.subName, m.mark
from subject s
         join mark m on s.subId = m.SubId
where m.Mark = (select max(mark) from mark);
-- Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
select s.StudentName, avg(m.mark) as 'Điểm trung bình'
from Student s
         join mark m on s.StudentId = m.StudentId
group by m.StudentId;
-- Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)

Select mark.mark, s.StudentName, rank() over (order by avg(mark.mark) DESC, s.StudentName) as ranking
from mark
         join student s on Mark.StudentId = s.StudentId
group by S.StudentId;

-- Hiển thị các thông tin sinh viên và điểm trung bình, ỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
select s.StudentName, avg(m.mark) as 'Điểm trung bình'
from Student s
         join mark m on s.StudentId = m.StudentId
group by m.StudentId
having avg(m.mark) > 10;

-- Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
select s.studentName, s2.subName, mark.mark
from mark
         join student s on Mark.StudentId = s.StudentId
         join subject s2 on Mark.SubId = s2.subId
order by mark.mark desc, s.StudentName;
-- Xóa dữ liệu.
-- Xóa tất cả các lớp có trạng thái là 0.
delete
from class
where Status = 0;
-- Xóa tất cả các môn học chưa có sinh viên dự thi.
delete
from subject
where subId not in (select subId from mark);
-- Thay đổi.
-- Xóa bỏ cột ExamTimes trên bảng Mark.
alter table mark
drop column ExamTimes;
-- Sửa đổi cột status trên bảng class thành tên ClassStatus.
alter table class
rename column status to ClassStatus;
-- Đổi tên bảng Mark thành SubjectTest.
alter table Mark
rename to SubjectTest





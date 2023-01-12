## Spring 2023 Course

### Course Summary and Purpose

We aim to introduce students to the concepts, tools, and framework necessary for independent work on the Linux kernel.

### Course description

Linux is the most widely used operating system in the world. The core software component of the Linux operating system is the kernel. A couple of its roles include managing hardware interactions, virtualizing system resources, and enforcing security constraints. In effect, Linux kernel powers almost all of the world’s top supercomputers, android phones, and an innumerable variety of other computers. This course will introduce students to Linux kernel development by focusing on device driver development. This will give students hands-on experience working with internal Linux kernel APIs and provide an overview of some of the core features and components of the kernel. Gaining an understanding of the inner workings of the operating system and how to make changes to it will give students an invaluable perspective on how their computers work behind the scenes that will reveal a new layer of understanding to apply to any future software engineering practice.


### Course objectives

Students will:

* Stretch their C programing skills to the limit

* Create, develop, and test interesting and creative Linux kernel modules

* Develop the ability to autonomously participate in the open source software community

* Learn how to give and recieve feedback on code patches

* Demonstrate the ability to explain your code and your knowledge of Linux in your own words

### Required Materials

1. A Linux environment to which you have root access and ideally physical access.

2. Patience, determination, and an ability to focus on a frustrating task for sustained periods of time.

### Course appplication

WELCOME APPLICANTS!

Please thoroughly read and then complete the following instructions:

Send an email to kdlp-application@googlegroups.com satisfying the following conditions:

a) The subject of the email contains your full legal name followed by the text "-- [SESSION] Application for Introduction to Linux Kernel Development", where [SESSION] is replaced by the appropriate string, i.e. "Fall" or "Spring" followed by the current year.

b) If you are enrolled at UMass Lowell, then send this email must be sent from your @student.uml.edu address.

c) The email should state your current student and/or occupational status, i.e. if you are enrolled in a school, name the school, your course of study, your level of progress through this course of study, and if you are employed, name your employer (or business, if you own one), and your job title.

d) The email should contain your response to the following question:

	What does the following C language expression evaluate to?

	"KDLP"[4]

	Explain your answer in fewer than 5 complete English sentences.

e) If you have a resume, KDLP allows that it be attached to this email as a PDF file or text file. No other document in any other format may be attached to this email.

f) The email must contain your discord username that you will use to complete step 2

g) If you prefer to use a different email to send and recieve email patches on our mailing list than the one you are using to send this message, you should specify this address. KDLP will provide instructions on the usage of gmail with our systems, but it is not required that all students use gmail.

h) Include a line certifying the [Developer Certificate of Origin](https://bssw.io/items/the-developer-certificate-of-origin)

i) Include your time zone.

By submitting this email, you acknowledge that you have read and agree to the course policies listed below.

### Course Schedule

|#| week starting|S|M|T|W|R|F|S|
|--|--|--|--|--|--|--|--|--|
|0| 15 Jan||||0|||
|1| 22 Jan||1||2|||
|2| 29 Sept||3||4|||
|3| 5 Feb||5||6||
|4| 8 Feb||7||8||
|5| 12 Feb||9||10||
|6| 19 Feb|||11|12||
|7| 26 Feb||13||14||
|8| 5 Mar||||||
|9| 12 Mar||15||16||
|10| 19 Mar||17||18||
|11| 26 Mar||19||20||
|12| 2 Apr||21||22||
|13| 9 Apr||23||24||
|14| 16 Apr||25||26||
|15| 23 Apr||27||28||
|16| 30 Apr|F|I|N|A|L|S|!|

### Course Policies

**Assignment Procedures:**

* Coding Assignments:
  * Assignments must be submitted in the format of plaintext unless explicitly specified.
  * Assignments must be submitted in the form of email code patches, and furthermore:
    * Submissions must onform to all Linux kernel coding standards that are sane in a particular context.
    * Submissions must not contain whitespace errors
  * The instructors will provide detailed guidelines for automated checking of these requirements, and will gladly explain them upon request to any interested student
    * Therefore the instructors reserve the right to refuse to grade any submission that does not conform to these standards.
  * Students will participate in peer review for these assignments, as explained in the section below.

* Presentation Assignments:
  * Students will be required to complete two (2) presentations throughout the course
  * Students must deliver their presentations over a live video call
  * Presentations must include original visual content, such as slides
  * Students are required to include live demonstrations of their code by sharing their text editor and/or terminal during the presentation

* Instructors reserve the right to change due dates within reason
  * In such a case, we will provide sufficient advance notice to students

**Peer Review Procedure (only for coding assignments)**

* Students must participate in the class mailing list for submissions by giving other students feedback on their work.
* This is a part of each assignment grade and the tripartite scheme is as follows:
  * The review process spans 2 days
  * Part 1: Initial submission
    * The student makes their submission to mailing list using git-send-email.
    * This submission is due on the listed assignment "due date".
  * Part 2: Peer review
    * A student is given two other student names (call them student A and student B)
    * The student is assigned to review student A's and student B's submissions 
    * If the student approves of a submission, then the student will reply to the approved email with what we call an "ack"
      * This consists of a single line containing the following: Acked-by: Firstname Lastname <email@domain.tld\>
    * If the student sees problems with a submission, the the student will reply to the problematic email with their feedback
    * In parallel, other students have been assigned the student's submission and the student should recieve feedback from two other students.
    * This review is due one day past initial submission.
  * Part 3: Final submission
    * The student, if canny, will act on the feedback from the received reviews and make a second, final submission
    * This is due two days after the initial submission, and due one day after receiving the reviews.
  * The student is graded only on the student's final submission
  * Reviews are graded based on how many issues a student missed
    * The student receives 20% off for each unique issue not spotted with max penalty of 100%
    * Each review given is worth 10% of the grade per assignment with the actual submission being 80%

**Late Work Policy:**

* There is no late work!
  * Students receive a zero for assignments not submitted on time
* One exception (a once per semester get out of jail free card):
  * Students may choose to opt out of the peer review process
  * By bypassing the ack requirement (both giving and receiving) students receive the two days that would be used for that process as an extension before they make their first and only final submission.
  * This means that you do you not get a chance to receive early feedback from your peers and so you get what you get for a final grade.

**UMass Lowell-specific Course Policies:**

* Automatic Course Failure (Grade of F)
  * In the case that a student fails to complete a task by a deadline with no prior notice, an instructor will reach out to you via email and/or direct message. If the student fails to respond to this message within seven (7) days of it’s receipt, the instructors reserve the right to give the student a failing grade (F) for the course.
  * Attendance is... required

**LFX-specific Course Policies (LFX):**

* Removal from the course
  * In the case that a student fails to complete a task by a deadline with no prior notice, an instructor will reach out to you via email and/or direct message. If the student fails to respond to this message within seven (7) days of it’s receipt, the instructors reserve the right to remove the student from the program.
  * Attendance is not required (because of timezones) but students should watch the recorded videos of class sessions


**Grading Policy:**

Students will be graded according to the following scheme:

| Category | Percentage |
|--|--|
| Assignments | 40% |
| Presentation 1 | 25% |
| Presentation 2 | 30% |
| Participation | 5% |


UMass Lowell students will be given a letter grade according to the following this scheme:

|Letter grade|Percentage range|
|--|--|
|A                             	|90 ~ 100|
|A-|                           	85 ~ 89.99|
|B+|                          	80 ~ 84.99|
|B                             	|75 ~ 79.99|
|B-|                           	70 ~ 74.99|
|C+|                          	65 ~ 69.99|
|C                             	|60 ~ 64.99|
|C-|                           	55 ~ 59.99|
|D+|                          	50 ~ 54.99|
|D                             	|40 ~ 49.99|
|F                              |below 40|

######A (4.0), A- (3.7), B+ (3.3), B (3.0), B- (2.7), C+ (2.3), C (2.0), C- (1.7), D+ (1.3), D (1.0), F (0.0)


**Mentorship Graduation**

* Students and mentees will be given the status of “Graduated” if we determine that their performance has been suitable to the degree that we would recommend as a strong candidate for an internship doing basic Linux kernel engineering work.

**Exceptions**

* There are no unconditional exceptions.
* Contact the instructors directly.


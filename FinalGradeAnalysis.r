# Initialize

setwd( "C:/Users/its_sbrown2/Documents/PBK/R/Untouched R" )
#Changes made to lines 144-150, 209-213
# Look at one semester's grades

x <- scan( "Book1.csv", what = list( pbk = "", stuid = 0, stumaj1 = "", stumaj2 = "", term = "", division = "", department = "", subject = "", courseid = 0, instid = 0, units = 0, pointgrade = 0, classof = 0 ), skip = 1, sep=",")
pbk <- x$pbk
stuid <- x$stuid
stumaj1 <- x$stumaj1
stumaj2 <- x$stumaj2
term <- x$term
division <- x$division
department <- x$department
subject <- x$subject
courseid <- x$courseid
instid <- x$instid
units <- x$units
pointgrade <- x$pointgrade
classof <- x$classof
cbind(pbk,stuid,subject ,courseid ,instid , units,pointgrade ,classof)
hist( pointgrade, nclass = 50 )

length( classof[is.na(classof)])
length( stuid[is.na(stuid)])
#length( department[department==""])


# Load up multiple semesters

	# Make sure these are ordered in time going up! Needed to get major right.
	# This could be fixed by converting term into a number and the selecting the largest one.
	
filenames <- NULL
filenames <- c( filenames, "Book1.csv" )
#filenames <- c( filenames, "avg grade points with identifiers sp07.csv" )
#filenames <- c( filenames, "avg grade points with identifiers fa07.csv" )
#filenames <- c( filenames, "avg grade points with identifiers sp08.csv" )
#filenames <- c( filenames, "avg grade points with identifiers fa08.csv" )
#filenames <- c( filenames, "avg grade points with identifiers sp09.csv" )
#filenames <- c( filenames, "avg grade points with identifiers fa09.csv" )
#filenames <- c( filenames, "avg grade points with identifiers sp10.csv" )
#filenames <- c( filenames, "avg grade points with identifiers fa10.csv" )
#filenames <- c( filenames, "avg grade points with identifiers sp11.csv" )

pbk <- NULL
stuid <- NULL
stumaj1 <- NULL
stumaj2 <- NULL
term <- NULL
division <- NULL
department <- NULL
subject <- NULL
courseid <- NULL
instid <- NULL
units <- NULL
pointgrade <- NULL
classof <- NULL

for ( filename in filenames )
{
	x <- scan( filename, what = list( pbk = "", stuid = 0, stumaj1 = "", stumaj2 = "", term = "", division = "", department = "", subject = "", courseid = 0, instid = 0, units = 0, pointgrade = 0, classof = 0 ), skip = 1, sep=",")
	pbk <- c( pbk, x$pbk )
	stuid <- c( stuid, x$stuid )
	stumaj1 <- c( stumaj1, x$stumaj1 )
	stumaj2 <- c( stumaj2, x$stumaj2 )
	term <- c( term, x$term )
	division <- c( division, x$division )
	department <- c( department, x$department )
	subject <- c( subject, x$subject )
	courseid <- c( courseid, x$courseid )
	instid <- c( instid, x$instid )
	units <- c( units, x$units )
	pointgrade <- c( pointgrade, x$pointgrade )
	classof <- c( classof, x$classof )
}

length( stuid[is.na(stuid)])
length( stuid[is.na(term)])
length( stuid[is.na(courseid)])
length( stuid[is.na(instid)])
length( stuid[is.na(units)])
length( stuid[is.na(pointgrade)])
length( stuid[is.na(classof)])


hist( pointgrade, nclass = 50 )

stdcut <- pointgrade > 3.5
length( pointgrade[stdcut] ) / length( pointgrade )
sum( pointgrade[stdcut] * units[stdcut] ) / sum( pointgrade * units )


# Statistics by department

departments <- unique( department )
length( departments )

number.grades <- NULL
number.units <- NULL
avg.grade.by.dept <- NULL
avg.grade.by.dept.sigma <- NULL
percentage.as <- NULL
percentage.a.units <- NULL
for ( this.department in departments )
{
	stdcut <- department == this.department
	number.grades <- c( number.grades, length( pointgrade[stdcut] ) )
	number.units <- c( number.units, sum( units[stdcut] ) )
	avg.grade.by.dept <- c( avg.grade.by.dept, sum( pointgrade[stdcut] * units[stdcut] ) / sum( units[stdcut] ) )
	avg.grade.by.dept.sigma <- c( avg.grade.by.dept.sigma, sqrt( var( pointgrade[stdcut] * units[stdcut] ) ) / sum( units[stdcut] ) / sqrt( length( pointgrade[stdcut] ) ) )
	percentage.as <- c( percentage.as, length( pointgrade[stdcut & pointgrade > 3.5] ) / length( pointgrade[stdcut] ) )
	percentage.a.units <- c( percentage.a.units, sum( units[stdcut & pointgrade > 3.5] ) / sum( units[stdcut] ) )
}

signif( weighted.mean( pointgrade, units ), 3 )
this.order <- order( avg.grade.by.dept, decreasing = TRUE )
cbind( departments[this.order], number.grades[this.order], signif( avg.grade.by.dept[this.order], 3 ), signif( percentage.as[this.order], 3 ), signif( percentage.a.units[this.order], 3 ) )
cbind( departments[this.order], number.units[this.order], signif( avg.grade.by.dept[this.order], 3 ), signif( 100 * percentage.a.units[this.order], 3 ) )
cbind( departments[this.order], signif( avg.grade.by.dept[this.order], 3 ), signif( 100 * percentage.a.units[this.order], 3 ) )

write( t( cbind( departments[this.order], signif( avg.grade.by.dept[this.order], 3 ), signif( 100 * percentage.a.units[this.order], 3 ) ) ), "DeptStatistics.txt", ncol = 3, sep = ", " )


# Get a student's grades

this.stuid <- sample( stuid, 1 )
this.stuid <- 50651081
stdcut <- stuid == this.stuid
pointgrade[stdcut]
stu.grades <- pointgrade[stdcut]
course.units <- units[stdcut]
course.ids <- courseid[stdcut]
inst.ids <- instid[stdcut]
pbk.info <- pbk[stdcut]
pbk.info
term.s <- term[stdcut]
classof[stdcut]
term[stdcut]

course.means <- NULL
course.sds <- NULL
course.sdoms <- NULL
course.numbers <- NULL
for ( i in 1:length( course.ids ) )
{
	this.course <- course.ids[i]
	this.inst <- inst.ids[i]
	stdcut <- courseid == this.course & instid == this.inst
	length( pointgrade[stdcut] )
	####################################################################################################
	course.means <- c( course.means, mean( pointgrade[stdcut] ) )

	cat(mean( pointgrade[stdcut],na.rm=TRUE ),course.ids[i], fill = TRUE) #my own addition
	
	course.sds <- c( course.sds, sqrt( var( pointgrade[stdcut]) ) )
	####################################################################################################
	
	course.sdoms <- c( course.sdoms, sqrt( var( pointgrade[stdcut] ) / length( pointgrade[stdcut] ) ) )
	course.numbers <- c( course.numbers, length( pointgrade[stdcut] ) )
}

normalized.grades <- (stu.grades - course.means ) / course.sds
cbind( stu.grades, course.means, course.sds, course.numbers, normalized.grades, course.units, term.s, course.ids )
weighted.mean( stu.grades, course.units )
mean( stu.grades )
weighted.mean( normalized.grades, course.units,na.rm=TRUE )
sum( course.units )

stdcut <- !is.na( course.sds ) & !is.nan( course.sds ) & course.sds != 0
stdcut
weighted.mean( normalized.grades[stdcut], course.units[stdcut] )


# Get all students grades

class.cut <- 2020
total.unit.cut <- 64 # Used to select PBK candidates

classof[is.na(classof)] <- 3000 # spring 2011 transfer students?  XXX need to check this
stdcut <- classof == class.cut

stuids <- unique( stuid[stdcut] )
length( stuids )
student.ids <- NULL
total.units <- NULL
rejected.units <- NULL
average.grade <- NULL
average.normalized.grade <- NULL
student.major <- NULL
pbk.info <- NULL
for ( this.stuid in stuids )
{
	stdcut <- stuid == this.stuid
	stu.grades <- pointgrade[stdcut]
	stu.units <- units[stdcut]
	
	if ( sum( stu.units ) > total.unit.cut )
	{
		student.ids <- c( student.ids, this.stuid )
		total.units <- c( total.units, sum( stu.units ) )
		junk <- stumaj1[stdcut]
		student.major <- c( student.major, junk[length(junk)] )
		junk <- pbk[stdcut]
		pbk.info <- c( pbk.info, junk[length(junk)] )
		
		course.ids <- courseid[stdcut]
		inst.ids <- instid[stdcut]
		course.means <- NULL
		course.sds <- NULL
		course.sdoms <- NULL
		course.numbers <- NULL
		for ( i in 1:length( course.ids ) )
		{
			stdcut <- courseid == course.ids[i] & instid == inst.ids[i]
			
			####################################################################################################
			course.means <- c( course.means, mean( pointgrade[stdcut] ) )
			course.sds <- c( course.sds, sqrt( var( pointgrade[stdcut] ) ) )
			course.sdoms <- c( course.sdoms, sqrt( var( pointgrade[stdcut]) / length( pointgrade[stdcut] ) ) )
			####################################################################################################
			
			course.numbers <- c( course.numbers, length( pointgrade[stdcut] ) )
			
		}
		
		print( cbind( stu.grades, stu.units, course.means, course.sds, course.numbers, (stu.grades - course.means ) / course.sds ) )
		
		average.grade <- c( average.grade, weighted.mean( stu.grades, stu.units ) )
	
		stdcut <- !is.na( course.sds ) & !is.nan( course.sds ) & course.sds != 0	
		normalized.grades <- ( stu.grades[stdcut] - course.means[stdcut] ) / course.sds[stdcut]
		average.normalized.grade <- c( average.normalized.grade, weighted.mean( normalized.grades, stu.units[stdcut] ) )
		rejected.units <- c( rejected.units, sum( stu.units[!stdcut] ) )
	}
}

sum( rejected.units ) / sum( total.units )

cbind( student.ids, total.units, average.grade, average.normalized.grade )

hist( average.grade )
hist( average.normalized.grade, xlab = "Normalized GPA", main = "Distribution of Normalized GPA", breaks = seq( from = -3.0, to = 3.0, by = 0.25 ) )


rank.gpas <- seq( student.ids ) * 0
rank.gpas[order( average.grade, decreasing = TRUE )] <- seq( student.ids )
rank.normalized.gpas <- seq( student.ids ) * 0
rank.normalized.gpas[order( average.normalized.grade, decreasing = TRUE )] <- seq( student.ids )

plot( rank.gpas, rank.normalized.gpas, type = "n" )
points( rank.gpas, rank.normalized.gpas, cex = 0.25 )
abline( 0, 1 )
abline( v = 0.15 * length( rank.gpas ), col = "red" ) # General PBK cutoff is 15% of class
abline( h = 0.15 * length( rank.gpas ), col = "red" )

this.order <- order( average.grade, decreasing = TRUE )[1:65]
# or
this.order <- order( average.normalized.grade, decreasing = TRUE )[1:65]

cbind( student.ids[this.order], rank.gpas[this.order], signif( average.grade[this.order], 3 ), pbk.info[this.order], student.major[this.order], rank.normalized.gpas[this.order], signif( average.normalized.grade[this.order], 3 ), total.units[this.order] )

dept.in.question <- "CHEM"
length( rank.gpas[ rank.gpas < 0.15 * length( rank.gpas ) & student.major == dept.in.question] )
length( rank.normalized.gpas[ rank.normalized.gpas < 0.15 * length( rank.gpas ) & student.major == dept.in.question] )


# Latin honors information

# Using current (not including fall or spring grades) data I get the following numbers and percentages
# 438 seniors
# Summa cutoff is 3.9.  15 students or 3.4%
# Magna cum laude cutoff is 3.75.  35 additional students or 8.0%
# Cum laude cutoff is 3.5.  98 additional students or 22.4%

length( average.grade )
length( average.grade[average.grade > 3.9])
length( average.grade[average.grade > 3.9]) / length( average.grade )
length( average.grade[average.grade > 3.75]) - length( average.grade[average.grade > 3.9])
(length( average.grade[average.grade > 3.75]) - length( average.grade[average.grade > 3.9])) / length( average.grade )
length( average.grade[average.grade > 3.5]) - length( average.grade[average.grade > 3.75])
(length( average.grade[average.grade > 3.5]) - length( average.grade[average.grade > 3.75])) / length( average.grade )

#If we try to achieve the same percentages with the normalized grade

rev( sort( average.normalized.grade ) )

summa.cutoff <- 0.93
magna.cutoff <- 0.70
cum.cutoff <- 0.283

length( average.normalized.grade )
length( average.normalized.grade[average.normalized.grade > summa.cutoff])
length( average.normalized.grade[average.normalized.grade > summa.cutoff]) / length( average.normalized.grade )
length( average.normalized.grade[average.normalized.grade > magna.cutoff]) - length( average.normalized.grade[average.normalized.grade > summa.cutoff])
(length( average.normalized.grade[average.normalized.grade > magna.cutoff]) - length( average.normalized.grade[average.normalized.grade > summa.cutoff])) / length( average.normalized.grade )
length( average.normalized.grade[average.normalized.grade > cum.cutoff]) - length( average.normalized.grade[average.normalized.grade > magna.cutoff])
(length( average.normalized.grade[average.normalized.grade > cum.cutoff]) - length( average.normalized.grade[average.normalized.grade > magna.cutoff])) / length( average.normalized.grade )


# Plots for PBK proposal

	pdf( "Normalized GPA.pdf" )

hist( average.normalized.grade, xlab = "Normalized GPA", main = "Distribution of Normalized GPA", breaks = seq( from = -3.0, to = 1.5, by = 0.25 ) )

	dev.off()

#rank.gpas <- seq( student.ids ) * 0s
rank.gpas[order( average.grade, decreasing = TRUE )] <- seq( student.ids )
rank.normalized.gpas <- seq( student.ids ) * 0
rank.normalized.gpas[order( average.normalized.grade, decreasing = TRUE )] <- seq( student.ids )
order(rank.normalized.gpas)#my addition
	pdf( "Rank vs Rank.pdf" )

plot( rank.gpas, rank.normalized.gpas, type = "n", xlab = "Rank using GPA", ylab = "Rank using normalized GPA", main = "Correlation plot of rank" )
#points( rank.gpas, rank.normalized.gpas, cex = 0.25 )
points( rank.gpas, rank.normalized.gpas )
abline( 0, 1 )
abline( v = 0.15 * length( rank.gpas ), col = "red" ) # General PBK cutoff is 15% of class
abline( h = 0.15 * length( rank.gpas ), col = "red" )

	dev.off()

stdcut <- rank.gpas < 0.15 * length( rank.gpas )
stdcut <- stdcut & rank.normalized.gpas < 0.15 * length( rank.gpas )
length( rank.gpas[stdcut] )

this.order <- order( average.normalized.grade, decreasing = TRUE )[1:20]
cbind( rank.normalized.gpas[this.order], signif( average.normalized.grade[this.order], 3 ), student.major[this.order], rank.gpas[this.order], signif( average.grade[this.order], 3 ) )

write( t( cbind( rank.normalized.gpas[this.order], signif( average.normalized.grade[this.order], 3 ), student.major[this.order], rank.gpas[this.order], signif( average.grade[this.order], 3 ) ) ), "Ranks.txt", ncol = 5, sep = ", " )




# Get course information for all (course, instructor, semester) combinations

course.ids <- unique( courseid )
length( course.ids )

course.means <- NULL
course.sds <- NULL
course.sdoms <- NULL
course.numbers <- NULL
course.units <- NULL
course.dept <- NULL
for ( this.course in course.ids )
{
	stdcut <- courseid == this.course
	inst.ids <- unique( instid[stdcut] )
	for ( this.inst in inst.ids )
	{
		stdcut <- courseid == this.course & instid == this.inst
		term.s <- unique( term[stdcut] )
		for ( this.term in term.s )
		{
			stdcut <- courseid == this.course & instid == this.inst & term == this.term
			course.means <- c( course.means, mean( pointgrade[stdcut] ) )
			course.sds <- c( course.sds, sqrt( var( pointgrade[stdcut] ) ) )
			course.sdoms <- c( course.sdoms, sqrt( var( pointgrade[stdcut] ) / length( pointgrade[stdcut] ) ) )
			course.numbers <- c( course.numbers, length( pointgrade[stdcut] ) )
			course.units <- c( course.units, mean( units[stdcut] ) )
			course.dept <- c( course.dept, department[stdcut][1] )
		}
	}
}

cbind( course.means, course.sds, course.sdoms, course.numbers, course.units )

stdcut <- course.sds == 0 & course.means > 3.8 & course.numbers > 1
hist( course.numbers[stdcut], breaks = seq( from = 0, to = 25, by = 1 ), main = "Distribution of all-A courses\nby unique course, instructor and semester combinations" )
length( course.means[stdcut] ) / length( course.means )
cbind( course.means[stdcut], course.sds[stdcut], course.numbers[stdcut], course.dept[stdcut] )


plot( course.means, course.sds )


# Get course information for all (course, instructor) combinations

course.ids <- unique( courseid )
length( course.ids )

course.means <- NULL
course.sds <- NULL
course.sdoms <- NULL
course.numbers <- NULL
course.units <- NULL
course.dept <- NULL
for ( this.course in course.ids )
{
	stdcut <- courseid == this.course
	inst.ids <- unique( instid[stdcut] )
	for ( this.inst in inst.ids )
	{
		stdcut <- courseid == this.course & instid == this.inst
		course.means <- c( course.means, mean( pointgrade[stdcut] ) )
		course.sds <- c( course.sds, sqrt( var( pointgrade[stdcut] ) ) )
		course.sdoms <- c( course.sdoms, sqrt( var( pointgrade[stdcut] ) / length( pointgrade[stdcut] ) ) )
		course.numbers <- c( course.numbers, length( pointgrade[stdcut] ) )
		course.units <- c( course.units, mean( units[stdcut] ) )
		course.dept <- c( course.dept, department[stdcut][1] )
	}
}

cbind( course.means, course.sds, course.sdoms, course.numbers, course.units, course.dept )

this.order <- order( course.means, decreasing = TRUE )
cbind( course.means[this.order], course.sds[this.order], course.numbers[this.order], course.dept[this.order] )

stdcut <- course.sds == 0 & course.means > 3.8 & course.numbers > 1
hist( course.numbers[stdcut], breaks = seq( from = 0, to = max( course.numbers[stdcut] ), by = 1 ), main = "Distribution of all-A courses\nby individual course and instructor for the past 5 years" )
length( course.means[stdcut] ) / length( course.means )
cbind( course.means[stdcut], course.sds[stdcut], course.numbers[stdcut], course.dept[stdcut] )


plot( course.means, course.sds )







# How many courses issue all As

course.ids <- unique( courseid )
length( course.ids )

straight.as <- 0
numbers.straight.as <- NULL
course.numbers <- NULL
for ( this.course in course.ids )
{
	stdcut <- courseid == this.course
	course.numbers <- c( course.numbers, length( courseid[stdcut] ) )
	if ( min( pointgrade[stdcut] ) == 4.0 )
	{
		straight.as <- straight.as + 1
		numbers.straight.as <- c( numbers.straight.as, length( stuid[courseid == this.course] ) )
	}
}

length( course.ids )
straight.as
hist( numbers.straight.as )

stdcut <- numbers.straight.as > 4
length( numbers.straight.as[stdcut] )

stdcut <- course.numbers > 4
length( course.ids[stdcut] )





# Look at Jim's average grade points by division

x <- scan( "avg grade points by div fa94-sp11.csv", what = list( semester = 0, division = "", avggrade = 0, number = 0), skip = 1, sep=",")
semester <- x$semester
division <- x$division
avg.grade <- x$avggrade
number <- x$number

	pdf( "Oxy grade data.pdf" )

plot( 0, -1, main = "Average Grade by Division", ylab = "Average Grade", xlim = c( 1995, 2010 ), ylim = c( 2, 4.3 ), col = "blue", type = "n" )
stdcut <- x$division == "ARHU" & number > 1000
points( x$semester[stdcut] / 100, x$avggrade[stdcut], col = "red" )
stdcut <- x$division == "SOSC" & number > 1000
points( x$semester[stdcut] / 100, x$avggrade[stdcut], col = "blue" )
stdcut <- x$division == "SCI" & number > 1000
points( x$semester[stdcut] / 100, x$avggrade[stdcut], col = "green" )

text( 1995, 4.1, "Arts and Humanities", col = "red", pos = 4 )
text( 1995, 4.0, "Social Science", col = "blue", pos = 4 )
text( 1995, 3.9, "Science", col = "green", pos = 4 )

	dev.off()


# Look at Jim's average grade points by department

x <- scan( "avg grade points by dept fa94-sp11.csv", what = list( semester = 0, department = "", avggrade = 0, number = 0), skip = 1, sep=",")
semester <- x$semester
department <- x$department
avg.grade <- x$avggrade
number <- x$number

dept.colors <- rainbow( length( unique( department ) ) )

	pdf( "Oxy grade data.pdf" )

plot( 0, -1, main = "Average Grade by Department", ylab = "Average Grade", xlim = c( 1995, 2015 ), ylim = c( 2.6, 3.75 ), col = "blue", type = "n" )

i <- 1
for ( this.department in unique( department ) )
{
    stdcut <- department == this.department & number > 100
    lines( semester[stdcut] / 100, avg.grade[stdcut], col = dept.colors[i] )
    x <- avg.grade[stdcut]
    text( 2012, x[length(x)], this.department, cex = 0.5, col = dept.colors[i] )
    i <- i + 1
}

	dev.off()



/*
SQLyog Community v13.1.6 (64 bit)
MySQL - 10.4.32-MariaDB : Database - st_alberts_finance_management
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`st_alberts_finance_management` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `st_alberts_finance_management`;

/*Table structure for table `account_details` */

DROP TABLE IF EXISTS `account_details`;

CREATE TABLE `account_details` (
  `account_details_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `acc_no` varchar(100) DEFAULT NULL,
  `ifsc` varchar(100) DEFAULT NULL,
  `bankname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`account_details_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `account_details` */

insert  into `account_details`(`account_details_id`,`user_id`,`acc_no`,`ifsc`,`bankname`) values 
(1,2,'545454646','ABCD0123456','hddhsjjs');

/*Table structure for table `feedback` */

DROP TABLE IF EXISTS `feedback`;

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `feedback` varchar(100) DEFAULT NULL,
  `date` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`feedback_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `feedback` */

insert  into `feedback`(`feedback_id`,`user_id`,`feedback`,`date`) values 
(1,1,'good','25/06/2024'),
(2,2,'dhhsbdsbsb','2024-12-10');

/*Table structure for table `finance` */

DROP TABLE IF EXISTS `finance`;

CREATE TABLE `finance` (
  `finance_id` int(11) NOT NULL AUTO_INCREMENT,
  `finance_company_id` int(11) DEFAULT NULL,
  `finance` varchar(100) DEFAULT NULL,
  `details` varchar(100) DEFAULT NULL,
  `date` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`finance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `finance` */

insert  into `finance`(`finance_id`,`finance_company_id`,`finance`,`details`,`date`) values 
(2,1,'finance 1','nsnssnnsnns','2024-12-10'),
(3,1,'sbsbsh','hdhddhdh','2024-12-10');

/*Table structure for table `finance_company` */

DROP TABLE IF EXISTS `finance_company`;

CREATE TABLE `finance_company` (
  `finance_company_id` int(11) NOT NULL AUTO_INCREMENT,
  `login_id` int(11) DEFAULT NULL,
  `cname` varchar(100) DEFAULT NULL,
  `place` varchar(100) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`finance_company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `finance_company` */

insert  into `finance_company`(`finance_company_id`,`login_id`,`cname`,`place`,`phone`,`email`) values 
(1,3,'comp1','kottayam','87989','kott@gmail.com'),
(2,3,'company number 1','kollam ','9851247523','comp2@gmail.com');

/*Table structure for table `instructions` */

DROP TABLE IF EXISTS `instructions`;

CREATE TABLE `instructions` (
  `instructions_id` int(11) NOT NULL AUTO_INCREMENT,
  `finance_id` int(11) DEFAULT NULL,
  `instructions` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`instructions_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `instructions` */

insert  into `instructions`(`instructions_id`,`finance_id`,`instructions`) values 
(2,2,'shshsshshh');

/*Table structure for table `login` */

DROP TABLE IF EXISTS `login`;

CREATE TABLE `login` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `usertype` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `login` */

insert  into `login`(`login_id`,`username`,`password`,`usertype`) values 
(1,'admin','admin1234','admin'),
(3,'comp1','comp12345','company'),
(4,'anna','anna1234','user');

/*Table structure for table `querires` */

DROP TABLE IF EXISTS `querires`;

CREATE TABLE `querires` (
  `querires_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `finance_company_id` int(11) DEFAULT NULL,
  `query` varchar(100) DEFAULT NULL,
  `reply` varchar(100) DEFAULT NULL,
  `date` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`querires_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `querires` */

insert  into `querires`(`querires_id`,`user_id`,`finance_company_id`,`query`,`reply`,`date`) values 
(1,2,1,'vsbdhdhd+','bshajaj','2024-12-10');

/*Table structure for table `request` */

DROP TABLE IF EXISTS `request`;

CREATE TABLE `request` (
  `request_id` int(11) NOT NULL AUTO_INCREMENT,
  `finance_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `date` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`request_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `request` */

insert  into `request`(`request_id`,`finance_id`,`user_id`,`reason`,`date`,`status`) values 
(1,2,2,'send amount','2024-12-10','amount as send to account number');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `login_id` int(11) DEFAULT NULL,
  `fname` varchar(100) DEFAULT NULL,
  `lname` varchar(100) DEFAULT NULL,
  `place` varchar(100) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `users` */

insert  into `users`(`user_id`,`login_id`,`fname`,`lname`,`place`,`phone`,`email`) values 
(1,2,'anu','q','ernakulam','576576576','anu@gmail.com'),
(2,4,'anna','h','ernakulam ','2358965235','anna@gmqil.com');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

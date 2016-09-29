CREATE DATABASE IF NOT EXISTS testdb DEFAULT CHARACTER SET utf8;
CREATE TABLE test_data (
    case_id INT NOT NULL UNIQUE  AUTO_INCREMENT COMMENT '用例 ID,唯一 ' ,
    http_method VARCHAR(5) NOT NULL COMMENT 'http 方法（POST、GET',
    request_name VARCHAR(30) COMMENT '自定义接口名称 建议格式：接口名-测试简单说明 ',
    request_url VARCHAR(200) NOT NULL COMMENT '接口 URL',
    request_param VARCHAR(1000) NOT NULL COMMENT '接口所需的全部或部分参数--python 字典形式的字符串 ',
    test_method VARCHAR(50) NOT NULL COMMENT '测试方法，一个测试用例对应一个方法 ',
    test_desc VARCHAR(2000) NOT NULL COMMENT '测试描述--主要描述这个用例的测试点、测试目的 ',
    PRIMARY KEY(case_id)
);
CREATE TABLE pre_condition_data (
    case_id INT NOT NULL AUTO_INCREMENT COMMENT '用例 ID ',
    step INT NOT NULL COMMENT '执行该用例 ID 需要的第一步、第一个前提条件的step ID ',
    request_url VARCHAR(200) NOT NULL COMMENT '接口 URL ',
    request_param VARCHAR(1000) NOT NULL COMMENT '接口参数--python 字典形式的字符串 ',
    other VARCHAR(1000) COMMENT '保留字段，可能是执行用例需要预先执行的 sql 语句等 ',
    test_desc VARCHAR(2000) NOT NULL COMMENT '数据描述--描述这条数据用途  ',
    PRIMARY KEY (case_id , step)
);


CREATE TABLE test_result (
    case_id INT NOT NULL UNIQUE AUTO_INCREMENT COMMENT '用例 ID ',
    http_method VARCHAR(5) NOT NULL COMMENT 'http 方法（POST、GET ',
    request_name VARCHAR(30) COMMENT '自定义接口名称 ',
    request_url VARCHAR(200) NOT NULL COMMENT '接口 URL ',
    request_param VARCHAR(1000) NOT NULL COMMENT '接口所需的全部参数--python 字典形式的字符串 ',
    test_method VARCHAR(50) NOT NULL COMMENT '接口测试方法 ',
    test_desc VARCHAR(2000) NOT NULL COMMENT '数据描述--描述测试目的 ',
    result VARCHAR(20) NOT NULL COMMENT '测试结果 ',
    reason VARCHAR(20) COMMENT '测试失败原因 ',
    PRIMARY KEY(case_id)
)
;

DROP SCHEMA  IF EXISTS testdb;
CREATE SCHEMA testdb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
use testdb;
CREATE TABLE `t_case_group` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_case_group_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_case_date` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `http_method` varchar(10) DEFAULT NULL COMMENT 'http 方法（POST、GET等）',
  `request_url` varchar(200) DEFAULT NULL,
  `request_param` varchar(1000) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `case_group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_case_group` FOREIGN KEY (`case_group_id`) REFERENCES `t_case_group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `testdb`.`t_case_result` (
    `id` INT(10) NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(45) NOT NULL,
    `date` DATETIME NULL,
    `result` VARCHAR(100) NULL,
    `case_id` INT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `id_UNIQUE` (`id` ASC),
    CONSTRAINT `fk_case_date` FOREIGN KEY (`case_id`)
        REFERENCES `testdb`.`t_case_date` (`id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

INSERT INTO `testdb`.`t_case_group` (`id`, `code`, `description`) VALUES ('1', 'eleOrder', '饿了么订单');
INSERT INTO `testdb`.`t_case_group` (`id`, `code`, `description`) VALUES ('2', 'partnerOrder', '大B订单');
INSERT INTO `testdb`.`t_case_group` (`id`, `code`, `description`) VALUES ('3', 'psbOrder', '配送宝订单');

INSERT INTO `testdb`.`t_case_date` (`id`, `code`, `http_method`, `request_url`, `request_param`, `description`, `case_group_id`) VALUES ('1', 'eleCreateOrder', 'POST', '/eleme/v1/order/create', 'order_number=4-1000-1274323767&delivery_number=3132739827697&order_price=10.00&store_consignee_fee=0.00&planned_pickup_time=1457489751&planned_complete_time=1457489751&order_note=订单备注&store_id=20160304&store_name=蒙娜丽莎的微笑&store_address=北京望京SOHO-T3-B-1907&store_longitude=116.475166&store_latitude=40.001566&store_phone=13836130596&store_sequence_number=01&deliver_type=1&consignee_name=王超&consignee_phone=13836130596&consignee_address=北京望京SOHO-T3-B-1907&consignee_longitude=116.475166&consignee_latitude=40.001566&consignee_note=用户备注&city_code=110000&is_predicted=0&invoice_title=饿了么发票&order_products=[{\"name\":\"榴莲\",\"quantity\":\"5\",\"total_price\":\"5000\",\"total_weight\":\"2500\",\"unit\":\"份\",\"unit_price\":\"1000\",\"unit_weight\":\"500\"}]&app_key=ele123456789qwe&sign=7594310cd3ff15d4a8610ceeab7f4089', '饿了么创建订单', '1');

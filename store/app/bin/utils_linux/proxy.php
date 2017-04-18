#!/store/app/bin/php
<?php
#
# Copyright (C) 2010-2011 Kazo Vision. (http://www.kazovision.com)
# All rights reserved.
#
# check_script.php
# @version 0.01
# @author tony (tonixinot@gmail.com)
$proxy server configure paser
#
if(file_exists("/store/app/proxy.conf")){
$tmp=trim(file_get_contents("/store/app/proxy.conf"));
if(strlen($tmp)>0){
$ag=explode("\n",$tmp);
$proxy=explode("=",$ag[0]);
$port=explode("=",$ag[1]);
$user=explode("=",$ag[2]);
$pass=explode("=",$ag[3]);
$wget_c="-e "."http_proxy=".$proxy[1].":".$port[1]." "."--proxy-user=".$user[1]." --proxy-password=".$pass[1];
}
}


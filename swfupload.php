<?php // RAY_temp_upload_example.php

 error_reporting(0);
 	 //今天的文件目录
	$todaydir=date('Ymd');
	 //保存的文件名
	$savepath='/uploads/'.$todaydir;//保存图片的相对路径，为网站根目录，请不要随便改动
	$filename=$savepath.'/'.getfilename($_FILES["Filedata"]["name"] );//保存图片的相对路径
	$jueduifilepath=$_SERVER['DOCUMENT_ROOT'].$savepath;//绝对保存目录
	 if(!file_exists($jueduifilepath)) createdir($jueduifilepath);
	 
	 
 if (!empty($_FILES))
 {

	 if (!move_uploaded_file($_FILES["Filedata"]["tmp_name"],$_SERVER['DOCUMENT_ROOT'].$filename)){
		 echo "CANNOT MOVE {$_FILES["Filedata"]["name"]}" . PHP_EOL;
	 }else{
		
		 echo "data={'imgpath':'".$filename."','newname':'".getfilename($_FILES["Filedata"]["name"] )."','oldname':'".$_FILES["Filedata"]["name"]."'}";
		die();
		 }
		  writeFile( "data={'imgpath':'".$filename."','newname':'".getfilename($_FILES["Filedata"]["name"] )."','oldname':'".$_FILES["Filedata"]["name"]."'}",'batupload.log');
 }

$act=@$_GET['act'];
if($act=="delimg"){

	$filename=$_GET['imgpath'];
	delimg($filename);
	die();
	}
function delimg($myfile){
	if (file_exists($_SERVER['DOCUMENT_ROOT'].$myfile)) {
    $result=unlink ($_SERVER['DOCUMENT_ROOT'].$myfile);
    die($result);//.$_GET['imgpath'];
  }
	} 
 
 //生成文件名
function getfilename($filename){
	 $nam=date('ymdhms').rand(10000,99999).".".extend_3($filename);
	 return $nam;
	} 
 
 //方法一:
function extend_1($file_name)
{
$retval="";
$pt=strrpos($file_name, ".");
if ($pt) $retval=substr($file_name, $pt+1, strlen($file_name) - $pt);
return ($retval);
}

//方法二
function extend_2($file_name)
{
$extend = pathinfo($file_name);
$extend = strtolower($extend["extension"]);
return $extend;
}
//方法三
function extend_3($file_name)
{
$extend =explode("." , $file_name);
$va=count($extend)-1;
return $extend[$va];
}
function createDir($path){     
if (!file_exists($path)){     
createDir(dirname($path));     
mkdir($path, 0777);     
}     
}
/*
*@param $body 写入的内容
*@param $path 写入的文件路径
*可自动创建目录（多层）PHP写入文件的函数（目录不存在自动建立）
*格式如下 writefile("需要写入的内容","cache/1/1/1.txt")
*所有目录不存在自动循环建立。
*writefile('test','keli/keli/keli.txt')
*/
function writeFile($body,$path){    
createDir(dirname($path));     
$handle=fopen($path,'a');     
 fwrite($handle,$body);     
 fclose($handle);    
 return 1;    
    } 

 ?>
 
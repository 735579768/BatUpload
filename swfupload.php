<?php // RAY_temp_upload_example.php

 error_reporting(0);
 	 //������ļ�Ŀ¼
	$todaydir=date('Ymd');
	 //������ļ���
	$savepath='/uploads/'.$todaydir;//����ͼƬ�����·����Ϊ��վ��Ŀ¼���벻Ҫ���Ķ�
	$filename=$savepath.'/'.getfilename($_FILES["Filedata"]["name"] );//����ͼƬ�����·��
	$jueduifilepath=$_SERVER['DOCUMENT_ROOT'].$savepath;//���Ա���Ŀ¼
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
 
 //�����ļ���
function getfilename($filename){
	 $nam=date('ymdhms').rand(10000,99999).".".extend_3($filename);
	 return $nam;
	} 
 
 //����һ:
function extend_1($file_name)
{
$retval="";
$pt=strrpos($file_name, ".");
if ($pt) $retval=substr($file_name, $pt+1, strlen($file_name) - $pt);
return ($retval);
}

//������
function extend_2($file_name)
{
$extend = pathinfo($file_name);
$extend = strtolower($extend["extension"]);
return $extend;
}
//������
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
*@param $body д�������
*@param $path д����ļ�·��
*���Զ�����Ŀ¼����㣩PHPд���ļ��ĺ�����Ŀ¼�������Զ�������
*��ʽ���� writefile("��Ҫд�������","cache/1/1/1.txt")
*����Ŀ¼�������Զ�ѭ��������
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
 
package 
{
	import flash.net.URLLoader;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.DataEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import fl.controls.Button;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.external.ExternalInterface;
	/**
	* 多图上传及显示
	* 用法:addChild(new UploadImg())
	* php后端文件uploads.php
	* @author PlumKiller
	*/
	/**
	* FileReferenceList运行流程
	     * FileReferenceList实例化->FileReferenceList.browse()->for each->FileReference实例->DataEvent.UPLOAD_COMPLETE_DATA [FileReference.load()->Event.INIT->Loader.loadBytes]->FileReference.upload();
	     */

	public class UploadImg extends Sprite
	{

		private var seltBtn:Button;//定义按钮样子
		private var _file:FileReference;//上传文件
		private var _files:Array;//得到上传的文件数组
		private var frl:FileReferenceList;//上传个文件列表
		private var _nums:uint;//得到个数
		private var _xypx:uint = 0;//图片放的位置
		
		private var _xml:XML;
		private var _uploadURL:String;//上传图片的服务器角本路径
		private var _filterimg:String;//上传图片浏览框中的过滤字符串
		
		private var _imgnum:uint = 0;//当前传输第几张图片
		private var _imgcount:uint = 0;//上传的图片总数
		private var _imgid:uint = 0;//图片js的id
		function UploadImg()
		{
			// var mai:Main=new Main();
			init();
		}

		private function init():void
		{//取配置文件;
			var lujing:URLLoader = new URLLoader  ;
			//注册一个监听句柄加载完成后取出上传路径
			lujing.addEventListener(Event.COMPLETE,com);
			lujing.load(new URLRequest("config.xml"));
			/*var uploadbtn:Button = new Button  ;
			uploadbtn.label = "开始上传";
			uploadbtn.x = 150;
			uploadbtn.y = 10;
			this.addChild(uploadbtn);
			uploadbtn.addEventListener(MouseEvent.CLICK,uploadBtnClick);*/
			
		}
		private function com(evt:Event)
		{
			//配置加载完成后开始初始化界面
			_xml = new XML(evt.target.data);
			//num = _xml.p.length();//取图片的数量
			//从xml文件中取出上传的路径，和按钮标题
			 
			_uploadURL = _xml.p[0]. @ url;
			var _btnwidth:uint = _xml.button[0]. @ bwidth;//上传按钮宽
			var _btnheight:uint = _xml.button[0]. @ bheight;//上传按钮高
			var _btnX:uint = _xml.button[0]. @ bX;//上传按钮X坐标
			var _btnY:uint = _xml.button[0]. @ bY;//上传按钮Y坐标
			
			var _btntitle:String = _xml.button[0]. @ btitle;//上传按钮文本
			var _bsize:uint = _xml.button[0]. @ bsize;//上传按钮文本大小
			var _bcolor:String = _xml.button[0]. @ bcolor;//上传按钮文本大小
			
			
			//初始化flash上传按钮
			seltBtn = new Button  ;
			seltBtn.label = _btntitle;
			seltBtn.setSize(_btnwidth,_btnheight);
			seltBtn.x = _btnX;
			seltBtn.y = _btnY;
			seltBtn.alpha = 0.8;
			this.addChild(seltBtn);
			seltBtn.addEventListener(MouseEvent.CLICK,selectClickHandler);

			var tf:TextFormat = new TextFormat();
			tf.size = _bsize;//设置字体大小
			tf.color = _bcolor;//设置字体颜色
			tf.bold = true;//设置字体粗细
			seltBtn.setStyle("textFormat",tf);
		}
		private function uploadBtnClick(evt:MouseEvent)
		{

		}
		private function selectClickHandler(evt:MouseEvent):void
		{
			//单击按钮的时候调用的代码，生成一个浏览框
			frl = new FileReferenceList  ;//这里一定要把变量在全局声明,原因不明,只知道若做为临时变量,无法响应事件
			
			//注册一个选择事件，选择图片后调用对应的句柄
			frl.addEventListener(Event.SELECT,onSelectHandler);
			var fileFilter:FileFilter = new FileFilter( _xml.guolv[0]. @ descr,_xml.guolv[0]. @ imgtype);
			frl.browse([fileFilter]);
			//_nums = 0;
		}

		private function onSelectHandler(evt:Event):void
		{
			for (var i:uint = 0; i < evt.target.fileList.length; i++)
			{
				/**
				* 显示区域
				*/
				//onCompleteHandler(e:Event)
				var fileRef:FileReference = FileReference(evt.target.fileList[i]);
				fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onUploadCompleteHandler);//上传完成事件
				fileRef.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);//上传出错事件
				fileRef.addEventListener(ProgressEvent.PROGRESS,onProgresshandler);//上传过程中发生事件
				fileRef.upload(new URLRequest(_uploadURL));//开始上传
				trace(fileRef.name);//调试输出
				ExternalInterface.call("createimgdiv",_imgcount++);//调用外部js
			}
		}

		private function onUploadCompleteHandler(evt:DataEvent):void
		{
			trace(('图片上传完成' + evt.data));//后面的是网页返回的数据是一个json字符串
			//evt.target as FileReference.addEventListener(Event.COMPLETE, onCompleteHandler);
			//evt.target as FileReference.load();
			ExternalInterface.call("imgcomplete",_imgid++,evt.data);
			//完成后调用外部js;
			//evt.target.addEventListener(Event.COMPLETE,onCompleteHandler);//完成后加载图片到flash
			//evt.target.load();
		}

		private function ioErrorHandler(evt:Event):void
		{
			trace(evt);
			//上传出错时调用的函数
			ExternalInterface.call("imgerror",_imgid++,evt);
		}

		private function onProgresshandler(evt:ProgressEvent):void
		{
			var _temnum:uint = uint(evt.bytesLoaded / evt.bytesTotal * 100);


			ExternalInterface.call("imgProgres",_imgid,(uint(evt.bytesLoaded / evt.bytesTotal * 100) + "%"));
			if (_temnum==100)
			{
				_imgnum++;
			}
			trace(evt.target);
			trace((((((uint(evt.bytesLoaded / evt.bytesTotal * 100) + "%,已加载:") + evt.bytesLoaded) + "字节,总共有") + Math.floor(evt.bytesTotal / 1024)) + "K"));
		}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//上传完成后在界面中显示缩略图;
		private function onCompleteHandler(e:Event):void
		{
			//显示 
			var _loader:Loader = new Loader  ;
			if ((_xypx >= 5))
			{
				_xypx = 0;
			}
			_loader.x = 105 * _xypx;
			if (1)
			{
				if (((5 > _nums) > 0))
				{
					_loader.y = 50 * 1;
				}
				else
				{
					_loader.y = 120 * ((_nums + 5) - (_nums % 5)) / 5 - 55;
				}
			}//_loader.y = 50;
			_loader.contentLoaderInfo.addEventListener(Event.INIT,ImgHandler);

			this.addChild(_loader);
			_loader.loadBytes(e.target.data);
			createLable(_loader.x,_loader.y + 100,e.target.name);
			_nums++;
			_xypx++;
		}
		//对缩略图进行处理
		private function ImgHandler(e:Event):void
		{
			trace(e.currentTarget,e.target.toString());
			e.currentTarget.loader.width = 100;
			e.currentTarget.loader.height = 100;
		}

		//创建文本标签
		private function createLable(_x:uint,_y:uint,str:String)
		{
			var txt:TextField = new TextField  ;
			var format1:TextFormat = new TextFormat  ;
			format1.align = "center";
			txt.text = str;
			txt.x = _x;
			txt.y = _y;
			this.addChild(txt);
			txt.setTextFormat(format1);
		}
	}
}
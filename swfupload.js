//删除图片
function delimg(id){
	var imgpath=$('#thumb'+id).attr('alt');
	$.get('swfupload.php',{
				'act':'delimg',
				'imgpath':imgpath
		},function(data){
			if(data=='1'){
			$('#thumb'+id).parent().remove();
			}else{
				alert('error :'+data);
				}
			});
}
//flash在开始上传图片时调用的函数在网页中创建div,参数id是正在上传的图片个数,它最终会是总数
	function createimgdiv(id){
		var str="<div class='imgbox'>"+
					"<img id='thumb"+id+"' src='#' width='100' height='100' />"+
					"<input class='title' id='title"+id+"' name='title"+id+"' value='标题"+(id+1)+"' />"+
					"<textarea class='content' id='content"+id+"' name='content"+id+"'>内容</textarea>"+
					"<input class='picpath' id='imgpath"+id+"' name='imgpath"+id+"' value='' readonly='readonly' />"+
					"<div class='imgbar'>"+
						"<div class='bigbox'>"+
							"<div id='smabox"+id+"' class='smabox'>0%</div>"+
						"</div>"+
						"<div class='delimg' onclick='delimg("+id+")'>删除</div>"+
					"</div>"+
				"</div>";
		
	$('#imgcontainer').append(str);
	}
	//上传图片进度函数
	function imgProgres(id,data){
		$('#smabox'+id).css("width",data);
		$('#smabox'+id).html(data);
		if(data=="100%"){$('#smabox'+id).html("上传成功");}
		}
	//图片上传出错后调用的函数
	function imgerror(id,data){
		alert('error:image  '+id+'--'+data);
		}
	//图片上传完成后调用的数据
	function imgcomplete(id,data){
		var res=eval(data);
		$('#thumb'+id).attr('src',res.imgpath);
		$('#thumb'+id).attr('alt',res.imgpath);
		$('#thumb'+id).attr('title',res.imgpath);
		$('#imgpath'+id).val(res.imgpath);
		//$('#smabox'+id).html(res.oldname);
		$('#smabox'+id).html('上传成功!');
		$('#smabox'+id).css("width","100%");
		
		$('#thumb'+id).css('opacity',0);
		$('#thumb'+id).animate({'opacity':1},4000);
		}
	function oktijiao(){
		var jsonstr='';
		$('.imgbox').each(function(index, element) {
            var title=$(this).children('.title').val();
			var content=$(this).children('.content').val();
			var picpath=$(this).children('.picpath').val();
			if(index==0){
				jsonstr=picpath;
				}else{
				jsonstr+='|||'+picpath;	
					}
        });
		$("#jsonstr").val(jsonstr);
		console.log($("#jsonstr").val());
		//opener.document.getElementById('pic').value=jsonstr;
		//window.close();
		}

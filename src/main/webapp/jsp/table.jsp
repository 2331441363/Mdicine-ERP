<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	//注册table，form
	layui.use([ 'table', 'form' ], function() {
		//获取table组件
		var table = layui.table;
		//获取form组件
		var form = layui.form;
		//加载table
		table.render({
			elem : '#test', //table Id
			url : 'add1.do', //后台路径
			toolbar : '#toolbarDemo', //工具	
			title : '用户数据', //标题
			limits : [ 10, 20, 30 ], //设置每页显示数
			cols : [ [ {
				type : 'checkbox', //在前面加复选框
				fixed : 'left'
			}, {
				field : 'stuId',
				title : 'ID',
				fixed : 'left',
				unresize : true,
				sort : true
			//开启排序
			}, {
				field : 'stuName',
				title : '姓名'
			}, {
				field : 'stuAge',
				title : '年龄'
			}, {
				field : 'stuSex',
				title : '性别'
			}, {
				field : 'thId',
				title : '班级id'
			}, {
				fixed : 'right',
				title : '操作',
				toolbar : '#barDemo', //添加工具
				width : 150
			} ] ],
			page : true
		//启动分页
		});

		//头工具栏事件
		table.on('toolbar(test)', function(obj) {
			var checkStatus = table.checkStatus(obj.config.id);
			switch (obj.event) {
			case 'select':
				//关闭id
				document.getElementById("stuod").style.display = "none";
				//清空form表单的值
				document.getElementById("form").reset();
				//显示form表单
				layer.open({
					title : '增加管理员',//标题
					type : 1,//样式
					area : [ '600px', '400px' ],//大小
					//显示form表单
					content : $("#form"),
					success:function(layero){
		                   var mask = $(".layui-layer-shade");
		                   mask.appendTo(layero.parent());
		                  //其中：layero是弹层的DOM对象
		             }
				});
				//隐藏域赋值为1
				$("#hid").val("1");
				//修改按钮文字
				$("#but").val("添加");
				break;
			case 'getCheckData':
				var data = checkStatus.data;
				layer.alert(JSON.stringify(data));
				break;

			case 'getCheckLength':
				var data = checkStatus.data;
				layer.msg('选中了：' + data.length + ' 个');
				break;

			case 'isAll':
				layer.msg(checkStatus.isAll ? '全选' : '未全选');
				break;
			}
			;
		});

		//监听行工具事件
		table.on('tool(test)', function(obj) {
			//得到选择的行的信息
			var data = obj.data;
			//判断是否选中删除
			if (obj.event === 'del') {
				layer.confirm('真的删除行么', function(index) {
					$.ajax({
						url : 'deleteStu.do',
						data : 'id=' + data.stuId,
						success : function(back) {
							//关闭弹出框
							layer.close(index);
							//刷新表格数据
							$(".layui-laypage-btn")[0].click()
						}
					})
				});
				//修改
			} else if (obj.event === 'edit') {
				//隐藏域赋值为2
				$("#hid").val("2");
				//修改按钮文字
				$("#but").val("编辑");
				//显示id
				document.getElementById("stuod").style.display = "block";
				//显示form表单
				layer.open({
					title : '修改管理员',//标题
					type : 1,//样式
					area : [ '600px', '400px' ],//大小
					//显示form表单
					content : $("#form")
				});
				$("[name='stuSex']").each(function() {
					if ($(this).val() == data.stuSex) {
						$(this).attr("checked", "checked");
					}
				});
				//初始化form表单
				form.val("1", {
					"stuId" : data.stuId,
					"stuName" : data.stuName,
					"stuAge" : data.stuAge,
					"thId" : data.thId,
				})

			}
		});
	});

	function show() {
		//得到form表单的值
		var num = $("#form").serialize();
		//得到隐藏域
		var i = $("#hid").val();
		//判断隐藏域 隐藏域为1 则新增数据   隐藏域为2 则修改数据
		if (i == "1") {
			//新增
			$.ajax({
				url : 'insertLayui.do', //路劲
				data : num, //将form表单的值传回后台
				success : function(back) {
					if (back == 1) {
						//关闭所有层
						layer.closeAll();
						//清空form表单的值
						document.getElementById("form").reset();
						//刷新表格数据
						$(".layui-laypage-btn")[0].click()
					}
				}
			})
		} else if (i == "2") {
			//修改
			$.ajax({
				url : 'updateStu.do',//路劲
				data : num, //将form表单的值传回后台
				success : function(back) {
					if (back == 1) {
						//关闭所有层
						layer.closeAll();
						//清空form表单的值
						document.getElementById("form").reset();
						//刷新表格数据
						$(".layui-laypage-btn")[0].click()
					}
				}
			})
		}

	}
</script>


<table class="layui-hide" id="test" lay-filter="test"></table>

<script type="text/html" id="toolbarDemo">
  <div class="layui-btn-container">
    <button class="layui-btn layui-btn-sm" lay-event="select">添加数据</button>
    <button class="layui-btn layui-btn-sm" lay-event="getCheckData">获取选中行数据</button>
    <button class="layui-btn layui-btn-sm" lay-event="getCheckLength">获取选中数目</button>
    <button class="layui-btn layui-btn-sm" lay-event="isAll">验证是否全选</button>
  </div>
</script>

<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<!-- 新增数据form表单 -->
<form class="layui-form" id="form" style="display: none;" lay-filter="1">
	<div class="layui-form-item" style="display: none;" id="stuod">
		<label class="layui-form-label">Id</label>
		<div class="layui-input-block">
			<input type="text" name="stuId" id="id1" lay-verify="required"
				value="1" readonly="readonly" class="layui-input">
		</div>
	</div>
	<input type="hidden" id="hid" value="">
	<div class="layui-form-item">
		<label class="layui-form-label">姓名</label>
		<div class="layui-input-block">
			<input type="text" name="stuName" id="name" lay-verify="required"
				autocomplete="off" placeholder="请输入姓名" class="layui-input">
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">年龄</label>
		<div class="layui-input-block">
			<input type="text" name="stuAge" id="age" lay-verify="required"
				placeholder="请输入年龄" autocomplete="off" class="layui-input">
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">单选框</label>
		<div class="layui-input-block">
			<input type="radio" name="stuSex" id="sex" value="男" title="男">
			<input type="radio" name="stuSex" id="sex" value="女" title="女">
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label">班级</label>
		<div class="layui-input-block">
			<input type="text" name="thId" id="thid" lay-verify="required"
				autocomplete="off" placeholder="请输入班级" class="layui-input">
		</div>
	</div>
	<div class="layui-form-item">
		<div class="layui-input-block">
			<input type="button" id="but" class="layui-btn" onclick="show();"
				value="添加">
			<button type="reset" class="layui-btn layui-btn-primary">重置</button>
		</div>
	</div>
</form>



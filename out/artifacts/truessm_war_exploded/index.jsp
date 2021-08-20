<%--
  Created by IntelliJ IDEA.
  User: 56597
  Date: 8/16
  Time: 4:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <%--    此处是以斜杠开头，没有斜杠结尾--%>

    <%--    web路径
    不以/开始的相对路径：找资源，以当前路径的路径为基准，经常容易出问题
    以/开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306）;需要加上项目名称
    --%>
    <%--    引入jquery--%>
    <script type="text/javascript" src="${APP_PATH}/js/jquery-3.4.1.js"></script>
    <%--    引入样式--%>
    <link rel="stylesheet" href="${APP_PATH}/boostrap/bootstrap-4.4.1-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/boostrap/bootstrap-4.4.1-dist/js/bootstrap.min.js"></script>
</head>
<body>
<%--搭建显示页面--%>
<div class="container">
    <%--        标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!-- 模态框 -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">员工添加</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group row">
                            <label for="empName_add_input" class="col-sm-2 col-form-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                                <div class="invalid-feedback">
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="empName_add_input" class="col-sm-2 col-form-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_add_input" placeholder="@guigu.com">
                                <div class="invalid-feedback">
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="empName_add_input" class="col-sm-2 col-form-label">gender</label>
                            <div class="col-sm-10">
                                <div class="custom-control custom-radio custom-control-inline">
                                    <input type="radio" id="gender1_add_input" name="gender" class="custom-control-input" value="M" checked="checked">
                                    <label class="custom-control-label" for="gender1_add_input">男</label>
                                </div>
                                <div class="custom-control custom-radio custom-control-inline">
                                    <input type="radio" id="gender2_add_input" name="gender" class="custom-control-input" value="F">
                                    <label class="custom-control-label" for="gender2_add_input">女</label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="empName_add_input" class="col-sm-2 col-form-label">deptName</label>
                            <div class="col-sm-4">
                                <select class="custom-select" name="dId" id="dept_add_select">
<%--                                    部门的Id需要查询出来--%>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                </div>
            </div>
        </div>
    </div>
    <%--        按钮--%>
    <div class="row">
        <div class="col-md-4 offset-md-8">
            <button class="btn btn-success" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <%--        显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>

    <%--        显示分页数据--%>
    <div class="row">
        <%--            分页信息--%>
        <div class="col-md-6" id="page_info_area">

        </div>
        <%--            分页条--%>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>

<script type="text/javascript">

    var totalRecord;
<%--    1、页面加载完成后，直接去发送ajax请求，要到分页数据--%>
    $(function (){
       to_page(1);
    });

    function to_page(pn){
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+ pn,
            type:"GET",
            success:function (result){
                // console.log(result)
                // 1、解析并显示员工数据
                build_emps_table(result);
                // 2、解析并显示分页信息
                build_page_info(result);
                build_page_nav(result);
            }
        });
    }

    function build_emps_table(result){
        //清空table表格
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item){
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var GenderTd = $("<td></td>").append(item.gender == 'M'?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-success btn-sm")
                 .append($("<i></i>").addClass("bi bi-pen"))
                .append("编辑");
            var delBtn =   $("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<i></i>").addClass("bi bi-trash"))
                .append("删除");
            var Btn = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            //append()方法执行完成之后还是返回原来的元素
            $("<tr></tr>").append(empIdTd)
                .append(empNameTd)
                .append(GenderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(Btn)
                .appendTo("#emps_table tbody");
            // alert(item.empId);
        })
    };

    // 解析显示分析信息
    function build_page_info(result){
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页,总"+result.extend.pageInfo.pages
            +"页，总" + result.extend.pageInfo.total + "条记录");
        totalRecord = result.extend.pageInfo.total;
    };

    // 解析显示分页条
    function build_page_nav(result){
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        var firstPageLi = $("<li></li>").addClass("page-item").append($("<a></a>").addClass("page-link").attr("href","#").append("首页"));
        var prePageLi = $("<li></li>").addClass("page-item").append($("<a></a>").addClass("page-link").attr("href","#").append("&laquo;"));
        if(result.extend.pageInfo.hasPreviousPage == false){
            prePageLi.addClass("disabled");
            firstPageLi.addClass("disabled");
        }else {
            firstPageLi.click(function (){
                to_page(1);
            });
            prePageLi.click(function (){
                to_page(result.extend.pageInfo.pageNum-1);
            });
        };
        var nextPageLi =$("<li></li>").addClass("page-item").append($("<a></a>").addClass("page-link").attr("href","#").append("&raquo;"));
        var lastPageLi = $("<li></li>").addClass("page-item").append($("<a></a>").addClass("page-link").attr("href","#").append("末页"));
        if(result.extend.pageInfo.hasNextPage==false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            nextPageLi.click(function (){
                to_page(result.extend.pageInfo.pageNum+1);
            });
            lastPageLi.click(function (){
                to_page(result.extend.pageInfo.pages);
            });
        };

        // 添加首页和前一页
        ul.append(firstPageLi).append(prePageLi);
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item){
            var numLi = $("<li></li>").addClass("page-item").append($("<a></a>").addClass("page-link").attr("href","#").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            };
            // 给其中每页添加
            //绑定单击事件，实现跳转
            numLi.click(function (){
                to_page(item)
            });
            ul.append(numLi);
        });

        ul.append(nextPageLi).append(lastPageLi);
        var test = $("<nav></nav>").append(ul);
        test.appendTo("#page_nav_area");

    };

    function reset_form(ele){
        $(ele)[0].reset();
        //清空表单样式
        $(ele).find("*").removeClass("is-valid is-invalid");
    }

    //点击新增按钮弹出模态框
    $("#emp_add_modal_btn").click(function (){
        //*清除表单数据
        reset_form("#exampleModal form");
        //发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts();
        //弹出模态框
        $('#exampleModal').modal({
            backdrop:'static'
        });
    });

    //产出所有的部门信息并显示在下拉列表中
    function  getDepts(){
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            success:function (result){
                // console.log(result.extend.depts);
                // 显示部门信息在下拉列表中
                $("#dept_add_select").empty();
                $.each(result.extend.depts,function (index,value){
                    var optionEle = $("<option></option>").append(value.deptName).attr("value",value.deptId);
                    optionEle.appendTo("#dept_add_select");
                });
            }
        });
    };


    //校验表单数据
    function validate_add_form(){
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]+$)/;
        if(!regName.test(empName)){
            show_validatee_msg("#empName_add_input","false","用户可以是2-5位中文或者6-16位英文和数字的组合");
            return false;
        }else{
            show_validatee_msg("#empName_add_input","success","");
        };
        //2.校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail =/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!regEmail.test(email)){
            show_validatee_msg("#email_add_input","false","邮箱格式不正确");
            return false;
        }else{
            show_validatee_msg("#email_add_input","success","");
        };
        return true;
    };

    //显示校验结果的提示信息
    function show_validatee_msg(ele,status,msg){
        //清除当前元素的检验状态
        $(ele).removeClass("is-valid is-invalid");
        $(ele).next("div").text("")
        if("success"==status){
            $(ele).addClass("is-valid");
            $(ele).next("div").text(msg);
        }else if("false" == status){
            $(ele).addClass("is-invalid");
            $(ele).next("div").text(msg);
        }
    }

    //点击保存，保存员工
    $("#emp_save_btn").click(function (){
        //1、模态框中填写的表单数据提交给服务器进行保存
        //2、发送ajax请求保存员工
        //1、先对要提交给服务器的信息进行校验
        // if(!validate_add_form()){
        //     return false;
        // };

        //*判断之前的ajax用户校验是否成功
        if($(this).attr("ajax-va")=="false"){
            return false;
        }

        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            data:$("#exampleModal form").serialize(),
            success:function (result){
                // *
                if(result.code == 100){
                    //员工保存成功
                    //1、关闭模态框
                    $('#exampleModal').modal('hide');
                    //2、来到最后一页，显示刚才保存的数据,最后一页的信息来源于ajax请求
                    //发送ajax请求显示数据
                    //总记录数当做页码
                    to_page(totalRecord)
                }else{
                    //*显示失败信息
                    // console.log(result);
                    //有哪个字段的错误信息就显示哪个字段
                    if (undefined != result.extend.errorFields.email){
                        //显示邮箱错误信息
                        show_validatee_msg("#email_add_input","false",result.extend.errorFields.email);
                    }
                    if(undefined != result.extend.errorFields.empName){
                        //显示员工的错误信息
                        show_validatee_msg("#empName_add_input","false",result.extend.errorFields.empName);
                    }

                }

            }
        })
    });

    $("#empName_add_input").change(function (){
        //发送ajax请求校验用户是否可用
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data:"empName=" + empName,
            type:"POST",
            success:function (result){
                if(result.code == 100){
                    show_validatee_msg("#empName_add_input","success","用户名称可用");
                    $("#empName_add_input").attr("ajax-va","success");
                }else{
                    show_validatee_msg("#empName_add_input","false",result.extend.va_msg);
                    $("#empName_add_input").attr("ajax-va","false");
                }
            }
        });
    });


</script>

</body>
</html>

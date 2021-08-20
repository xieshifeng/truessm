<%--
  Created by IntelliJ IDEA.
  User: 56597
  Date: 8/16
  Time: 4:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <%--        按钮--%>
        <div class="row">
            <div class="col-md-4 offset-md-8">
                <button class="btn btn-success">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
<%--        显示表格数据--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover">
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                    <c:forEach items="${pageInfo.list}" var="emp">
                        <tr>
                            <th>${emp.empId}</th>
                            <th>${emp.empName}</th>
                            <th>${emp.gender=="M"?"男":"女"}</th>
                            <th>${emp.email}</th>
                            <th>${emp.department.deptName}</th>
                            <th>
                                <button class="btn btn-success btn-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pen" viewBox="0 0 16 16">
                                        <path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001zm-.644.766a.5.5 0 0 0-.707 0L1.95 11.756l-.764 3.057 3.057-.764L14.44 3.854a.5.5 0 0 0 0-.708l-1.585-1.585z"/>
                                    </svg>
                                    添加
                                </button>
                                <button class="btn btn-danger btn-sm">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
                                        <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                                        <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                                    </svg>
                                    删除
                                </button>

                            </th>
                        </tr>
                    </c:forEach>


                </table>
            </div>
        </div>

<%--        显示分页数据--%>
        <div class="row">
<%--            分页信息--%>
            <div class="col-md-6">
                当前${pageInfo.pageNum}页,总${pageInfo.pages}页，总${pageInfo.total}条记录
            </div>
<%--            分页条--%>
            <div class="col-md-6">
                <nav aria-label="Page navigation example">
                    <ul class="pagination">
                        <li class="page-item"><a class="page-link" href="${APP_PATH}/emps?pn=1">首页</a></li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li class="page-item">
                                <a class="page-link" href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach items="${pageInfo.navigatepageNums}" var="nums">
                            <c:if test="${nums == pageInfo.pageNum}">
                                <li class="page-item active"><a class="page-link" href="#">${nums}</a></li>
                            </c:if>
                            <c:if test="${nums != pageInfo.pageNum}">
                                <li class="page-item"><a class="page-link" href="${APP_PATH}/emps?pn=${nums}">${nums}</a></li>
                            </c:if>
                        </c:forEach>

                        <c:if test="${pageInfo.hasNextPage}">
                            <li class="page-item">
                                <a class="page-link" href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <li class="page-item"><a class="page-link" href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>


</body>
</html>

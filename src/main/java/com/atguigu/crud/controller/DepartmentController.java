package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理和部门有关的请求
 * @author XieShifeng
 * @create 2021-08-20 1:37
 */
@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    /*
    返回所有的部门信息
     */
    @ResponseBody
    @RequestMapping("/depts")
    public Msg getDepts(){
        List<Department> departments=departmentService.getDepts();
        return Msg.success().add("depts",departments);
    }
}

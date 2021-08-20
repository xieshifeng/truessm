package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工的CRUD请求
 * @author XieShifeng
 * @create 2021-08-16 4:50
 */

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/checkuser",method = RequestMethod.POST)
    public Msg checkUser(@RequestParam("empName")String empName){
        //*同步前端校验的结果，使用正则表达式
        String regName = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]+$)";
        if(!empName.matches(regName)){
            return Msg.fail().add("va_msg","用户必须是6-16位数字和字母的组合或者2-5位中文");
        }

        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if(b){
            return Msg.success();
        }else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    @ResponseBody
    @RequestMapping(value="/emp",method = RequestMethod.POST)
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
            //校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String,Object> map= new HashMap<>();
            List<FieldError> fieldErrors = result.getFieldErrors();
            for(FieldError fieldError:fieldErrors){
                System.out.println("错误字段名：" + fieldError.getField());
                System.out.println("错误信息：" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else{
            employeeService.saveEmp(employee);
            return Msg.success();

        }
    }

    /**
     * 需要导入jason包
     * @param pn
     * @return
     */
    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmpsWithJson(@RequestParam(value="pn",defaultValue = "1") Integer pn){

        //这不是一个分页查询
        //引入PageHelper分页插件
        //在查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
        //startPage后面紧跟的查询，就是分页查询
        List<Employee> employees = employeeService.getAll();

        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
        //封装了详细的分页信息，包括我们查询出来的数据,传入连续显示的页数
        PageInfo page = new PageInfo(employees,5);
        return Msg.success().add("pageInfo",page);
    }

//    @RequestMapping("/emps")
//    public String getEmps(@RequestParam(value="pn",defaultValue = "1") Integer pn, Model model){
//
//        //这不是一个分页查询
//        //引入PageHelper分页插件
//        //在查询之前只需要调用，传入页码，以及每页的大小
//        PageHelper.startPage(pn,5);
//        //startPage后面紧跟的查询，就是分页查询
//        List<Employee> employees = employeeService.getAll();
//
//        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
//        //封装了详细的分页信息，包括我们查询出来的数据,传入连续显示的页数
//        PageInfo page = new PageInfo(employees,5);
//        model.addAttribute("pageInfo",page);
//        return "list";
//    }
}

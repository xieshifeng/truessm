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
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
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
     * 单个批量删除二合一
     * 批量删除：1-2-3
     * 单个删除：1
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value="/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deletEmpById(@PathVariable("ids") String ids){
        if(ids.contains("-")){
            List<Integer> del_ids = new ArrayList<>();
            String[] split = ids.split("-");
            //组装id的集合
            for (String s : split) {
                del_ids.add(Integer.parseInt(s));
            }
            employeeService.deleteBatch(del_ids);
        }else {
            int i = Integer.parseInt(ids);
            employeeService.deletEmp(i);
        }
        return Msg.success();
    }

    /**
     * 如果直接发送ajax=PUT形式的请求
     * 封装的数据
     * Employee{empId=3, empName='null', gender='null', email='null', dId=null, department=null}
     *
     * 问题：
     * 请求体中有数据
     * 但是Employee封装不上
     *
     * 原因：
     * Tomcat：
     *      1、将请求体中的数据，封装为一个map
     *      2、request.getParameter（"empName"）就会从这个map中取值
     *      3、SpringMVC封装POJO对象的时候
     *          会把POJO中每个属性的值，request.getParamter("email")
     *
     * AJAX发送PUT请求会发生错误：
     *      PUT请求，请求体中的数据，request.getParamter("empName")拿不到
     *      Tomcat发现是PUT请求，不会封装请求体中的数据，只有POST请求才能往下解析
     *
     *我们要直接发送PUT之类的请求还要封装请求体中的数据
     * 配置上HttpPutFormContentFilter
     * 它的作用：将请求体中的数据解析包装成一个map
     * request被重新包装，request.getParameter()被重写，就会从自己封装的map中取出数据进行封装
     *
     *员工更新方法
     */
    @ResponseBody
    @RequestMapping(value="/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        System.out.println("请求体中的值" + request.getParameter("gender"));
        System.out.println(employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 根据id查询员工
     */
    @ResponseBody
    @RequestMapping(value="/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable("id") Integer id){
       Employee employee =  employeeService.getEmp(id);
       return Msg.success().add("emp",employee);

    }

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

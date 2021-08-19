package com.atguigu.crud.test;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

/**
 * @author XieShifeng
 * @create 2021-08-13 8:57
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:conf/applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    SqlSession sqlSession;
    @Autowired
    EmployeeMapper employeeMapper;
    @Test
    public void testCRUD(){
//        departmentMapper.insertSelective(new Department(null,"电脑部"));
//        departmentMapper.insertSelective(new Department(null,"手机部"));

//        批量插入多个员工:批量使用可以批量操作的sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//        for(int i=0;i<2000;i++){
//            String uid=UUID.randomUUID().toString().substring(0,5)+i;
//            mapper.insertSelective(new Employee(null,uid,"M",uid + "@atguigu.com",1));
//        }
//        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
//        for (Employee employee:employees) {
//            System.out.println(employee);
//        }
        for(int i=2000;i<16000;i++){
            mapper.deleteByPrimaryKey(i);
        }

    }
}

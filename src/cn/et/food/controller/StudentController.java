package cn.et.food.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.et.food.entity.Student;
import cn.et.food.service.StudentService;

@Controller
public class StudentController {

	@Autowired
	StudentService service;
	@ResponseBody
	@RequestMapping("/queryStudent")
	public List<Student> queryStudent(String sname){
		return service.queryStudent(sname);
	}
}

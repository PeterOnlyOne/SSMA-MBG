package cn.et.food.service;

import java.util.List;

import cn.et.food.entity.Student;

public interface StudentService {

	public abstract List<Student> queryStudent(String sname);

}
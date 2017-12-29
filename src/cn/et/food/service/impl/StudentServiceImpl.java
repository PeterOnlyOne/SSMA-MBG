package cn.et.food.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.et.food.dao.StudentMapper;
import cn.et.food.entity.Student;
import cn.et.food.entity.StudentExample;
import cn.et.food.entity.StudentExample.Criteria;
import cn.et.food.service.StudentService;
@Service
public class StudentServiceImpl implements StudentService {

	@Autowired
	StudentMapper sm;
	/* (non-Javadoc)
	 * @see cn.et.food.service.impl.StudentService#queryStudent(java.lang.String)
	 */
	public List<Student> queryStudent(String sname){
		StudentExample se = new StudentExample();
		Criteria c = se.createCriteria();
		c.andSnameLike("%"+sname+"%");
		return sm.selectByExample(se);
	}
}

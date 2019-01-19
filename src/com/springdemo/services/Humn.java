package com.springdemo.services;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

@Service("Humn")
public class Humn implements IHumn {

	@Override
	public String show() {
		// TODO Auto-generated method stub
		return "show";
	}

}

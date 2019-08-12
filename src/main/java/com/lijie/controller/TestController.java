package com.lijie.controller;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TestController {
	@RequestMapping("a.do")
	public void a(HttpSession session) {
		System.out.println("==========112233");
		session.setAttribute("name", "lijie");
	}
}

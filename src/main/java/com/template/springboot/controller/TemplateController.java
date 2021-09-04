package com.template.springboot.controller;

import java.util.HashMap;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController

public class TemplateController {

    @RequestMapping("/")
    @GetMapping
    public HashMap<String, String> home() {

        HashMap<String, String> res = new HashMap<>();
        res.put("status", "OK");

        return res;
    }

}

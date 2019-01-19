package com.springdemo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dugking.DTO.GetMethodParam;
import com.dugking.Util.SerizelizeModel;
import com.dugking.algorithmMNMF.MNMF;
import com.dugking.model.ClusterModel;
import com.dugking.model.JsonQXChart;
import com.dugking.model.Legend;
import com.dugking.model.Series;
import com.dugking.model.Tootip;
import com.dugking.model.XAxis;
import com.dugking.model.YAxis;
import com.springdemo.services.Humn;

import Jama.Matrix;

@Controller
@RequestMapping("/demo")
public class DemoController {
	
	@Autowired
	public Humn humn;
	
	@RequestMapping("/index")
	public String index() {
		return "index";
	}
	
	@RequestMapping("/demo")
	public String demo() {
		return "demo";
	}

	@RequestMapping("/show")
	public ModelAndView show() {
		ModelAndView model = new ModelAndView("show");
		return model;
	}

	@RequestMapping("/showCluster")
	public ModelAndView showCluster() {
		ModelAndView model = new ModelAndView("showCluster");
		return model;
	}

	@RequestMapping("/showDataAnalysis")
	public ModelAndView showDataAnalysis() {
		ModelAndView model = new ModelAndView("showDataAnalysis");
		return model;
	}
	@RequestMapping(value="/getShopInJSON",method = RequestMethod.GET)
	public @ResponseBody JsonQXChart getShopInJSON(GetMethodParam model,HttpServletRequest request) {
		System.out.println(model.toString());
		List<Matrix> listV=new ArrayList<Matrix>();
		for (int i = 0; i < 3; i++) {
			listV.add(Matrix.random(100, 100).times(100));
		}
		model.setClusterNum(3);
		MNMF model2=new MNMF(listV, Integer.valueOf(model.getMaxIter()), model.getClusterNum(), Math.pow(0.1,10), Math.pow(0.1, model.getRelarErr()),0);
		model2.update();
		
		String serModel=request.getServletContext().getRealPath("/model");
		SerizelizeModel.serlizeModel(model2, serModel+"MMNFModel.model");
		
		System.out.println(request.getServletContext().getRealPath("/model"));
		model2=SerizelizeModel.deSerlizeModel(serModel+"MMNFModel.model");
		System.out.println("-----����json����--------");
		JsonQXChart json = new JsonQXChart();
		
		
		YAxis yModel=new YAxis();
		Map<String,String> title=new HashMap<String,String>();
		title.put("text", "��ʧ����");
		yModel.setTitle(title);
		json.setyAxis(yModel);
		
		
		Map<String,String> titleYAxis=new HashMap<String,String>();
		titleYAxis.put("text", "��ʧ����");
		json.setTitle(titleYAxis);
		
		
		
		Map<String,String> titlesub=new HashMap<String,String>();
		titlesub.put("text", "");
		json.setSubTitle(titlesub);
		
		ArrayList<String> arr=new ArrayList<String>();
		for (int i = 0; i < model2.getErrAll().length; i++) {
			arr.add(String.valueOf(i+1));
		}
		XAxis xModel=new XAxis();
		xModel.setCategories(arr);
		json.setxAxis(xModel);
		
		

		
		
		
		Tootip tootip=new Tootip();
		tootip.setValueSuffix("��ʧ����Ϊ:");
		json.setTootip(tootip);
		
		Series sModel=new Series();
		sModel.setName("��ʧ����ͼ");
		
		ArrayList<Double> arrInt=new ArrayList<Double>();
		for (int i = 0; i < model2.getErrAll().length; i++) {
			arrInt.add(model2.getErrAll()[i][0]);
		}
		
		sModel.setData(arrInt);
		ArrayList<Series> getArrSeries=new ArrayList<Series>();
		getArrSeries.add(sModel);
		
		
		json.setArrSeries(getArrSeries);
		
		Legend legend=new Legend();
		legend.setAlign("right");

		legend.setLayout("vertical");
		legend.setBorderWidth(1);
		legend.setVerticalAlign("middle");
		json.setLengend(legend);
		

		return json;
 
	}
	
	@RequestMapping(value="/getJsonCluster",method = RequestMethod.GET)
	public @ResponseBody ClusterModel getJsonCluster(GetMethodParam model,HttpServletRequest request) {
		System.out.println(model.toString());
		List<Matrix> listV=new ArrayList<Matrix>();
		int[] label=new int[100];
		for (int i = 0; i < 3; i++) {
			listV.add(Matrix.random(100, 100).times(100));
			if(i<50)
			{
				label[i]=1;
			}else{
				label[i]=0;
			}
		}
		MNMF model2=new MNMF(listV, 500, 3, Math.pow(0.1, 10), Math.pow(0.1, 10),1);
		model2.update();
		
		String serModel=request.getServletContext().getRealPath("/model");
		SerizelizeModel.serlizeModel(model2, serModel+"MMNFModel.model");
		
		System.out.println(request.getServletContext().getRealPath("/model"));
		model2=SerizelizeModel.deSerlizeModel(serModel+"MMNFModel.model");
		System.out.println("-----����json����--------");
		ClusterModel json=new ClusterModel();
		json.setClusterVector(model2.getH().getArray());
		json.setLabel(label);
		return json;
	}

}
package com.springdemo.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.ModelAndView;

import com.dugking.DTO.ClusterInc;
import com.dugking.DTO.GetArr;
import com.dugking.DTO.GetMethodParam;
import com.dugking.Util.FileUtil;
import com.dugking.Util.GlobalData;
import com.dugking.Util.GraphType;
import com.dugking.Util.ListUnion;
import com.dugking.Util.SerizelizeModel;
import com.dugking.algorithmMNMF.MNMF;
import com.dugking.algorithmMNMF.MNMF_Base;
import com.dugking.manifold.ConstrucGraph;
import com.dugking.measure.ClusterEvaluation;
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
		
		String datasetPath=request.getServletContext().getRealPath("/dataset/");
		model.setDatasets("/3sources.mat");
		String datasetName=model.getDatasets();
		Map<String, ArrayList<double[][]>> listData=FileUtil.getMatCell2ArrayList(datasetPath+datasetName,"data");
		ArrayList<double[][]> arrDataSet=listData.get("data");
		List<Matrix> listV=new ArrayList<Matrix>();
		for (int i = 0; i < arrDataSet.size(); i++) {
			double[][] dataSingle=arrDataSet.get(i);
			double[][] inputData=new Matrix(dataSingle).transpose().getArray();
			ConstrucGraph modelGraph = new ConstrucGraph(inputData, 7, 7, GraphType.HeartKernel);
			listV.add(modelGraph.getGraphKnn());
		}
		
		Map<String, ArrayList<double[][]>> listLabel=FileUtil.getMatCell2ArrayList(datasetPath+datasetName, "truelabel");
		double[][] label=listLabel.get("truelabel").get(0);
		int clusterNum=ListUnion.getCluster(label);
		model.setClusterNum(clusterNum);
		
		MNMF model2=new MNMF(listV, Integer.valueOf(model.getMaxIter()), model.getClusterNum(), Math.pow(0.1,10), Math.pow(0.1, model.getRelarErr()),1);
		model2.update();
		
		String serModel=request.getServletContext().getRealPath("/model");
		SerizelizeModel.serlizeModel(model2, serModel+"MMNFModel.model");
		
		System.out.println(request.getServletContext().getRealPath("/model"));
		model2=SerizelizeModel.deSerlizeModel(serModel+"MMNFModel.model");
		System.out.println("-----请求json数据--------");
		JsonQXChart json = new JsonQXChart();
		
		
		YAxis yModel=new YAxis();
		Map<String,String> title=new HashMap<String,String>();
		title.put("text", "损失函数");
		yModel.setTitle(title);
		json.setyAxis(yModel);
		
		
		Map<String,String> titleYAxis=new HashMap<String,String>();
		titleYAxis.put("text", "损失函数");
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
		tootip.setValueSuffix("损失函数为:");
		json.setTootip(tootip);
		
		Series sModel=new Series();
		sModel.setName("损失函数图");
		
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
		int[] arrLabel=ListUnion.getDouble2Int(label);
		GlobalData.labelData=arrLabel;
		model2.getClusterLabel(model2.getW());
		System.out.println(ClusterEvaluation.NMI(model2.getLabelCluster(), arrLabel));
		return json;
 
	}
	
	@RequestMapping(value="/getJsonCluster",method = RequestMethod.GET)
	public @ResponseBody ClusterModel getJsonCluster(GetMethodParam model,HttpServletRequest request) {		
		String serModel=request.getServletContext().getRealPath("/model");
		System.out.println(request.getServletContext().getRealPath("/model"));
		MNMF_Base model2 = SerizelizeModel.deSerlizeModel(serModel+"MMNFModel.model");
		System.out.println("-----请求json数据--------");
		ClusterModel json=new ClusterModel();
		json.setClusterVector(( model2).getH().getArray());
		
		json.setLabel(GlobalData.labelData);
		return json;
	}
	@RequestMapping("/uploadHtml")
	public String uploadHtml() {
		return "uploadHtml";
	}
	 //上传文件会自动绑定到MultipartFile中
    @RequestMapping(value="/upload",method=RequestMethod.POST)
    public String upload(HttpServletRequest request, @RequestParam("file") MultipartFile file) throws Exception {

       //如果文件不为空，写入上传路径
       if(!file.isEmpty()) {
           //上传文件路径
           String path = request.getServletContext().getRealPath("/images/");
           //上传文件名
           String filename = file.getOriginalFilename();
           File filepath = new File(path,filename);
           //判断路径是否存在，如果不存在就创建一个
           if (!filepath.getParentFile().exists()) { 
               filepath.getParentFile().mkdirs();
           }
           //将上传文件保存到一个目标文件当中
           file.transferTo(new File(path + File.separator + filename));
           return "demo";
       } else {
           return "error";
       }

    }
    
    ///获得聚类结果
    @RequestMapping(value="/getClusterInc",method = RequestMethod.POST)
    public @ResponseBody ClusterInc getClusterInc(GetArr model)
    {
    	String[] A=model.getExpected().split(",");
    	String[] B=model.getPredicted().split(",");
    	ClusterInc modelJson=ClusterEvaluation.getClusterInc(A,B);
		return modelJson;
    	
    }
    


}
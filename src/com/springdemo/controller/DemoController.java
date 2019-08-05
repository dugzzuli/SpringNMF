package com.springdemo.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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

import com.dugking.DTO.AllJsonTotal;
import com.dugking.DTO.ClusterInc;
import com.dugking.DTO.ClusterLabel;
import com.dugking.DTO.DataSetIndexAttrDetail;
import com.dugking.DTO.DataSetIndexDetail;
import com.dugking.DTO.DatasetsAttr;
import com.dugking.DTO.GetArr;
import com.dugking.DTO.GetMethodParam;
import com.dugking.DTO.GetMethodParamGNMF;
import com.dugking.DTO.Status;
import com.dugking.DTO.TableJson;
import com.dugking.Util.DatasetAttributes;
import com.dugking.Util.FileUtil;
import com.dugking.Util.GlobalData;
import com.dugking.Util.GraphType;
import com.dugking.Util.ListUnion;
import com.dugking.Util.MultiViewData;
import com.dugking.Util.SerizelizeModel;
import com.dugking.Util.StaticDug;
import com.dugking.Util.UtilPython;
import com.dugking.algorithmMNMF.GMNMF;
import com.dugking.algorithmMNMF.MNMF;
import com.dugking.algorithmMNMF.MNMF_Base;
import com.dugking.algorithmNMF.Single_GNMF;
import com.dugking.manifold.ConstrucGraph;
import com.dugking.manifold.LaplanceDug;
import com.dugking.measure.ClusterEvaluation;
import com.dugking.model.ClusterModel;
import com.dugking.model.JsonQXChart;
import com.dugking.model.Legend;
import com.dugking.model.Series;
import com.dugking.model.Tootip;
import com.dugking.model.XAxis;
import com.dugking.model.YAxis;
import Jama.Matrix;

@Controller
@RequestMapping(value = { "/demo", "/" })
public class DemoController {

	// 上传的文件的路径，需要判断是否为空
	private static String fileUrPath = "";

	@RequestMapping(value = { "/index", "/" })
	public String index() {
		return "index";
	}

	// 登录界面 启动界面
	@RequestMapping(value = { "/login" })
	public String login() {
		return "login";
	}

	// 主题页面 开始
	@RequestMapping(value = { "/theme" })
	public String theme() {
		return "theme";
	}
	// 主题页面 结束

	// 流数据聚类界面 开始
	@RequestMapping("/streamCluster")
	public String streamCluster() {
		return "streamCluster";
	}
	// 流数据聚类界面 结束

	// 流数据异常界面 开始
	@RequestMapping("/streamOutlier")
	public String streamOutlier() {
		return "streamOutlier";
	}
	// 流数据异常界面 结束

	// 重叠社区 开始
	@RequestMapping("/overlapDetec")
	public String overlapDetec() {
		return "showdatasets";
	}
	// 重叠社区 结束

	@RequestMapping("/meathPath")
	public String meathPath() {
		return "meathPath";
	}

	@RequestMapping("/structureHole")
	public String structureHole() {
		return "structureHole";
	}

	@RequestMapping("/NetworkEmbedding")
	public String NetworkEmbedding() {
		return "NetworkEmbedding";
	}

	@RequestMapping("/DeepHawkes")
	public String DeepHawkes() {
		return "DeepHawkes";
	}

	@RequestMapping("/comRumor")
	public String comRumor() {
		return "comRumor";
	}

	// 杨逍论文所属界面
	@RequestMapping("/allyangxiao")
	public String allyangxiao() {

		return "allyangxiao";
	}

	@RequestMapping("/sociallocation")
	public ModelAndView sociallocation() {
		ModelAndView model = new ModelAndView("sociallocation");
		return model;
	}

	// 单视角聚类 控制器 开始.....
	@RequestMapping("/showsingledatasetsDetail")
	public String showsingledatasetsDetail() {

		return "showSingleView/showsingledatasetsDetail";
	}

	@RequestMapping("/showsingleview")
	public String showsingleview() {

		return "showSingleView/showsingleview";
	}

	@RequestMapping("/showSingleDataAnalysis")
	public ModelAndView showSingleDataAnalysis() {
		ModelAndView model = new ModelAndView("showSingleView/showSingleDataAnalysis");
		return model;
	}
	@RequestMapping("/showSingleCluster")
	public ModelAndView showSingleCluster() {
		ModelAndView model = new ModelAndView("showSingleView/showSingleCluster");
		return model;
	}
	// 单视角聚类 控制器 结束.....

	
	// 多视角控制器开始
//	@RequestMapping("/multiview")
	public ModelAndView multiview() {
		ModelAndView model = new ModelAndView("multi_view");
		return model;
	}
	
	@RequestMapping("/showCluster")
	public ModelAndView showCluster() {
		ModelAndView model = new ModelAndView("multiviewNew/showCluster");
		return model;
	}

	@RequestMapping(value = "/showdatasetsDetails", method = RequestMethod.GET)
	public @ResponseBody DatasetsAttr showdatasetsDetails(String datasetName) {
		DatasetsAttr model = DatasetAttributes.getattributes(datasetName);
		return model;
	}

	@RequestMapping("/showdatasetsDetail")
	public ModelAndView showdatasetsDetail() {
		ModelAndView model = new ModelAndView("multiviewNew/showdatasetsDetail");
		return model;
	}

	@RequestMapping(value = "/getDataSETAtt", method = RequestMethod.GET)
	public @ResponseBody DatasetsAttr getDataSETAtt() {

		DatasetsAttr model = new DatasetsAttr();
		MultiViewData model2 = MultiViewData.getInstance(fileUrPath);
		model.setNumViews(model2.getNumView());
		model.setSamples(model2.getNum());
		model.setDatasetname(fileUrPath.substring(fileUrPath.lastIndexOf('\\') + 1));
		return model;

	}

	@RequestMapping(value = "/getIndexDetail", method = RequestMethod.GET)
	public @ResponseBody DataSetIndexDetail getIndexDetail(int curView, int index) {

		DataSetIndexDetail model = new DataSetIndexDetail();

		MultiViewData model2 = MultiViewData.getInstance(fileUrPath);
		if (curView < 0)
			curView = 0;

		if (curView >= model2.getNumView()) {
			curView = model2.getNumView() - 1;
		}
		double[][] arr = model2.getListView().get(curView);

		double zuidazhi = StaticDug.getMax(arr, index);
		double zuixiaozhi = StaticDug.getMin(arr, index);
		double mean = StaticDug.getMean(arr, index);
		double std = StaticDug.getStandardDiviation(arr, index);

		model.setMean(mean);
		model.setStd(std);
		model.setZuidazhi(zuidazhi);
		model.setZuixiaozhi(zuixiaozhi);
		model.setDim(StaticDug.getCurViewDim(arr, index));
		model.setCurView(curView);
		return model;

	}

	@RequestMapping(value = "/getIndexAttrDetail", method = RequestMethod.GET)
	public @ResponseBody DataSetIndexAttrDetail getIndexAttrDetail(int curView, int index) {

		MultiViewData model2 = MultiViewData.getInstance(fileUrPath);
		if (curView < 0)
			curView = 0;

		if (curView >= model2.getNumView()) {
			curView = model2.getNumView() - 1;
		}
		double[][] arr = model2.getListView().get(curView);

		DataSetIndexAttrDetail model = new DataSetIndexAttrDetail();
		double[] arrRe = StaticDug.getIndexData(arr, index);
		model.setArr(arrRe);
		model.setLabel(StaticDug.getIndexDataLabel(arr, index));
		return model;

	}

	@RequestMapping(value = "/getTableJson", method = RequestMethod.GET)
	public @ResponseBody List<TableJson> getTableJson(int curView) {
		TableJson table = new TableJson();
		List<TableJson> ModelList = new ArrayList<TableJson>();

		MultiViewData model = MultiViewData.getInstance(fileUrPath);
		if (curView < 0)
			curView = 0;

		if (curView >= model.getNumView()) {
			curView = model.getNumView() - 1;
		}
		int size = model.getDimnum(curView);
		for (int i = 0; i < size; i++) {
			table = new TableJson();
			table.setName("Attr" + i);
			table.setNumber(i);
			ModelList.add(table);
		}

		return ModelList;

	}



	

	@RequestMapping("/showDataAnalysis")
	public ModelAndView showDataAnalysis() {
		ModelAndView model = new ModelAndView("multiviewNew/showDataAnalysis");
		return model;
	}

	// 获取当前session状态
	@RequestMapping(value = "/getCurrentStatus", method = RequestMethod.GET)
	public @ResponseBody Status getCurrentStatus(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Status model = new Status();

		model.setDesc(session.getAttribute("statusCur").toString());
		return model;
	}

	@RequestMapping(value = "/getShopInJSON", method = RequestMethod.GET)
	public @ResponseBody JsonQXChart getShopInJSON(GetMethodParam model, HttpServletRequest request) {

		MultiViewData modelDataSet = MultiViewData.getInstance(fileUrPath);
		// 用来保存当前状态....
		HttpSession session = request.getSession();
		session.setAttribute("statusCur", "开始执行.....");

		Map<String, ArrayList<double[][]>> listData = FileUtil.getMatCell2ArrayList(fileUrPath, "data");
		ArrayList<double[][]> arrDataSet = listData.get("data");
		List<Matrix> listV = new ArrayList<Matrix>();
		for (int i = 0; i < arrDataSet.size(); i++) {
			double[][] dataSingle = arrDataSet.get(i);
			double[][] inputData = new Matrix(dataSingle).transpose().getArray();

			ConstrucGraph modelGraph = new ConstrucGraph(inputData, 7, 8, GraphType.HeartKernel);
			listV.add(modelGraph.getGraphKnn());
			session.setAttribute("statusCur", "正在处理数据.....");
		}
		session.setAttribute("statusCur", "正在分解.....");
		if (model.getMethod().equals("MNMF")) {

			Map<String, ArrayList<double[][]>> listLabel = FileUtil.getMatCell2ArrayList(fileUrPath, "truelabel");
			double[][] label = listLabel.get("truelabel").get(0);
			int clusterNum = ListUnion.getCluster(label);
			model.setClusterNum(clusterNum);

			MNMF model2 = new MNMF(listV, Integer.valueOf(model.getMaxIter()), model.getClusterNum(), Math.pow(0.1, 10),
					Math.pow(0.1, model.getRelarErr()), 1);
			model2.update();

			String serModel = request.getServletContext().getRealPath("/model");

			SerizelizeModel.serlizeModel(model2, serModel + "model.model");

			System.out.println(request.getServletContext().getRealPath("/model"));
			model2 = SerizelizeModel.deSerlizeModel(serModel + "model.model");

			System.out.println("-----请求json数据--------");
			JsonQXChart json = new JsonQXChart();

			YAxis yModel = new YAxis();
			Map<String, String> title = new HashMap<String, String>();
			title.put("text", "损失函数");
			yModel.setTitle(title);
			json.setyAxis(yModel);

			Map<String, String> titleYAxis = new HashMap<String, String>();
			titleYAxis.put("text", "损失函数");
			json.setTitle(titleYAxis);

			Map<String, String> titlesub = new HashMap<String, String>();
			titlesub.put("text", "");
			json.setSubTitle(titlesub);

			ArrayList<String> arr = new ArrayList<String>();
			for (int i = 0; i < model2.getErrAll().length; i++) {
				arr.add(String.valueOf(i + 1));
			}
			XAxis xModel = new XAxis();
			xModel.setCategories(arr);
			json.setxAxis(xModel);

			Tootip tootip = new Tootip();
			tootip.setValueSuffix("损失函数为:");
			json.setTootip(tootip);

			Series sModel = new Series();
			sModel.setName("损失函数图");

			ArrayList<Double> arrInt = new ArrayList<Double>();
			for (int i = 0; i < model2.getErrAll().length; i++) {
				arrInt.add(model2.getErrAll()[i][0]);
			}

			sModel.setData(arrInt);
			ArrayList<Series> getArrSeries = new ArrayList<Series>();
			getArrSeries.add(sModel);

			json.setArrSeries(getArrSeries);

			Legend legend = new Legend();
			legend.setAlign("center");
			legend.setLayout("vertical");
			legend.setBorderWidth(1);
			legend.setVerticalAlign("middle");
			json.setLengend(legend);
			int[] arrLabel = ListUnion.getDouble2Int(label);
			GlobalData.labelData = arrLabel;
			model2.getClusterLabel(model2.getW());

			System.out.println(ClusterEvaluation.NMI(model2.getLabelCluster(), arrLabel));
			System.out.println(ClusterEvaluation.Purity(model2.getLabelCluster(), arrLabel));
			System.out.println("MNMF");
			session.setAttribute("statusCur", "分解完成！");
			return json;

		} else if (model.getMethod().equals("GMNMF")) {
			Map<String, ArrayList<double[][]>> listLabel = FileUtil.getMatCell2ArrayList(fileUrPath, "truelabel");
			double[][] label = listLabel.get("truelabel").get(0);
			int clusterNum = ListUnion.getCluster(label);
			model.setClusterNum(clusterNum);

			GMNMF model2 = new GMNMF(listV, Integer.valueOf(model.getMaxIter()), model.getClusterNum(),
					Math.pow(0.1, 10), Math.pow(0.1, model.getRelarErr()), 1, 10);
			model2.update();

			String serModel = request.getServletContext().getRealPath("/model");

			SerizelizeModel.serlizeModel(model2, serModel + "model.model");

			System.out.println(request.getServletContext().getRealPath("/model"));
			model2 = SerizelizeModel.deSerlizeModel(serModel + "model.model");

			System.out.println("-----请求json数据--------");
			JsonQXChart json = new JsonQXChart();

			YAxis yModel = new YAxis();
			Map<String, String> title = new HashMap<String, String>();
			title.put("text", "损失函数");
			yModel.setTitle(title);
			json.setyAxis(yModel);

			Map<String, String> titleYAxis = new HashMap<String, String>();
			titleYAxis.put("text", "损失函数");
			json.setTitle(titleYAxis);

			Map<String, String> titlesub = new HashMap<String, String>();
			titlesub.put("text", "");
			json.setSubTitle(titlesub);

			ArrayList<String> arr = new ArrayList<String>();
			for (int i = 0; i < model2.getErrAll().length; i++) {
				arr.add(String.valueOf(i + 1));
			}
			XAxis xModel = new XAxis();
			xModel.setCategories(arr);
			json.setxAxis(xModel);

			Tootip tootip = new Tootip();
			tootip.setValueSuffix("损失函数为:");
			json.setTootip(tootip);

			Series sModel = new Series();
			sModel.setName("损失函数图");

			ArrayList<Double> arrInt = new ArrayList<Double>();
			for (int i = 0; i < model2.getErrAll().length; i++) {
				arrInt.add(model2.getErrAll()[i][0]);
			}

			sModel.setData(arrInt);
			ArrayList<Series> getArrSeries = new ArrayList<Series>();
			getArrSeries.add(sModel);

			json.setArrSeries(getArrSeries);

			Legend legend = new Legend();
			legend.setAlign("center");
			legend.setLayout("vertical");
			legend.setBorderWidth(1);
			legend.setVerticalAlign("middle");
			json.setLengend(legend);
			int[] arrLabel = ListUnion.getDouble2Int(label);
			GlobalData.labelData = arrLabel;
			model2.getClusterLabel(model2.getW());

			System.out.println(ClusterEvaluation.NMI(model2.getLabelCluster(), arrLabel));
			System.out.println(ClusterEvaluation.Purity(model2.getLabelCluster(), arrLabel));
			System.out.println("GMNMF");
			session.setAttribute("statusCur", "分解完成！");
			return json;
		}
		return null;

	}

	@RequestMapping(value = "/getJsonCluster", method = RequestMethod.POST)
	public @ResponseBody ClusterModel getJsonCluster(GetMethodParam model, HttpServletRequest request) {
		String serModel = request.getServletContext().getRealPath("/model");
		System.out.println(request.getServletContext().getRealPath("/model"));
		MNMF_Base model2 = SerizelizeModel.deSerlizeModel(serModel + "model.model");
		System.out.println("-----请求json数据--------");
		ClusterModel json = new ClusterModel();
		json.setClusterVector((model2).getH().getArray());
		json.setLabel(GlobalData.labelData);
		return json;
	}
	// 多视角控制器 结束

	// 单视角聚类控制器
	
	@RequestMapping(value = "/getSingleJsonCluster", method = RequestMethod.POST)
	public @ResponseBody ClusterModel getSingleJsonCluster(GetMethodParam model, HttpServletRequest request) {
		String serModel = request.getServletContext().getRealPath("/model");
		System.out.println(request.getServletContext().getRealPath("/model"));
		Single_GNMF model2 = SerizelizeModel.deSerlizeModel(serModel + "model.model");
		System.out.println("-----请求json数据--------");
		ClusterModel json = new ClusterModel();
		json.setClusterVector((model2).getH().getArray());

		json.setLabel(GlobalData.labelData);
		return json;
	}
	
	@RequestMapping(value = "/getSVCLuster")
	public @ResponseBody JsonQXChart getSVCLuster(GetMethodParamGNMF model, HttpServletRequest request) {

//		MultiViewData modelDataSet = MultiViewData.getInstance(fileUrPath);
		// 用来保存当前状态....
		HttpSession session = request.getSession();
		session.setAttribute("statusCur", "开始执行.....");

		Map<String, ArrayList<double[][]>> listData = FileUtil.getMatCell2ArrayList(fileUrPath, "data");

		ArrayList<double[][]> arrDataSet = listData.get("data");
		List<Matrix> listV = new ArrayList<Matrix>();
		for (int i = 0; i < arrDataSet.size(); i++) {
			double[][] dataSingle = arrDataSet.get(i);
			double[][] inputData = new Matrix(dataSingle).transpose().getArray();

			ConstrucGraph modelGraph = new ConstrucGraph(inputData, 7, 8, GraphType.HeartKernel);
			listV.add(modelGraph.getGraphKnn());
			session.setAttribute("statusCur", "正在处理数据.....");
		}
		session.setAttribute("statusCur", "正在分解.....");
		
		Map<String, ArrayList<double[][]>> listLabel = FileUtil.getMatCell2ArrayList(fileUrPath, "truelabel");
		double[][] label = listLabel.get("truelabel").get(0);
		int clusterNum = ListUnion.getCluster(label);
		model.setClusterNum(clusterNum);
		
		LaplanceDug eigenmap = new LaplanceDug(listV.get(0).getArray(), 5, 0.5, GraphType.Binary);
		Matrix d = eigenmap.getdDug();
		Matrix w = eigenmap.getwDug();
		
		Single_GNMF modelGNMF = new Single_GNMF(listV.get(0).transpose(), model.getMaxIter(), model.getClusterNum(),
		Math.pow(0.1, 10), Math.pow(0.1, 10), model.getAlpha(), d, w);
		modelGNMF.update();


		String serModel = request.getServletContext().getRealPath("/model");

		SerizelizeModel.serlizeModel(modelGNMF, serModel + "model.model");

		System.out.println(request.getServletContext().getRealPath("/model"));
		modelGNMF = SerizelizeModel.deSerlizeModel(serModel + "model.model");

		System.out.println("-----请求json数据--------");
		JsonQXChart json = new JsonQXChart();

		YAxis yModel = new YAxis();
		Map<String, String> title = new HashMap<String, String>();
		title.put("text", "损失函数");
		yModel.setTitle(title);
		json.setyAxis(yModel);

		Map<String, String> titleYAxis = new HashMap<String, String>();
		titleYAxis.put("text", "损失函数");
		json.setTitle(titleYAxis);

		Map<String, String> titlesub = new HashMap<String, String>();
		titlesub.put("text", "");
		json.setSubTitle(titlesub);

		ArrayList<String> arr = new ArrayList<String>();
		for (int i = 0; i < modelGNMF.getErrAll().length; i++) {
			arr.add(String.valueOf(i + 1));
		}
		XAxis xModel = new XAxis();
		xModel.setCategories(arr);
		json.setxAxis(xModel);

		Tootip tootip = new Tootip();
		tootip.setValueSuffix("损失函数为:");
		json.setTootip(tootip);

		Series sModel = new Series();
		sModel.setName("损失函数图");

		ArrayList<Double> arrInt = new ArrayList<Double>();
		for (int i = 0; i < modelGNMF.getErrAll().length; i++) {
			arrInt.add(modelGNMF.getErrAll()[i][0]);
		}

		sModel.setData(arrInt);
		ArrayList<Series> getArrSeries = new ArrayList<Series>();
		getArrSeries.add(sModel);

		json.setArrSeries(getArrSeries);

		Legend legend = new Legend();
		legend.setAlign("center");
		legend.setLayout("vertical");
		legend.setBorderWidth(1);
		legend.setVerticalAlign("middle");
		json.setLengend(legend);
		int[] arrLabel = ListUnion.getDouble2Int(label);
		GlobalData.labelData = arrLabel;
		modelGNMF.getClusterLabel(modelGNMF.getH());

		System.out.println(ClusterEvaluation.NMI(modelGNMF.getLabelCluster(), arrLabel));
		System.out.println(ClusterEvaluation.Purity(modelGNMF.getLabelCluster(), arrLabel));
		System.out.println("MNMF");
		session.setAttribute("statusCur", "分解完成！");
		return json;

	}

	// 上传文件会自动绑定到MultipartFile中
	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public @ResponseBody Status upload(HttpServletRequest request, @RequestParam("file") MultipartFile file)
			throws Exception {

		Status status = new Status();
		// 如果文件不为空，写入上传路径
		if (!file.isEmpty()) {
			// 上传文件路径
			String path = request.getServletContext().getRealPath("/dataset/");
			// 上传文件名
			String filename = file.getOriginalFilename();
			File filepath = new File(path, filename);
			if (filepath.exists()) {
				filepath.delete();
			}
			// 判断路径是否存在，如果不存在就创建一个
			if (!filepath.getParentFile().exists()) {
				filepath.getParentFile().mkdirs();
			}
			// 将上传文件保存到一个目标文件当中

			fileUrPath = path + File.separator + filename;
			file.transferTo(new File(fileUrPath));

			MultiViewData multiViewData = MultiViewData.getInstance(fileUrPath);
			Map<String, ArrayList<double[][]>> listData = FileUtil.getMatCell2ArrayList(fileUrPath, "data");
			ArrayList<double[][]> arrDataSet = listData.get("data");

			multiViewData.setListView(arrDataSet);

			Map<String, ArrayList<double[][]>> listLabel = FileUtil.getMatCell2ArrayList(fileUrPath, "truelabel");
			double[][] label = listLabel.get("truelabel").get(0);
			multiViewData.setLabel(label);

			status.setCode(200);
			return status;
		} else {
			status.setCode(400);
			return status;
		}
	}

	/// 获得聚类结果
	@RequestMapping(value = "/getClusterInc", method = RequestMethod.POST)
	public @ResponseBody ClusterInc getClusterInc(GetArr model) {
		String[] A = model.getExpected().split(",");
		String[] B = model.getPredicted().split(",");
		ClusterInc modelJson = ClusterEvaluation.getClusterInc(A, B);
		return modelJson;

	}

}
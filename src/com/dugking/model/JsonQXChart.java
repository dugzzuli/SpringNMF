package com.dugking.model;

import java.util.ArrayList;
import java.util.Map;

public class JsonQXChart {
	// json.title = title;
	// json.subtitle = subtitle;
	// json.xAxis = xAxis;
	// json.yAxis = yAxis;
	// json.tooltip = tooltip;
	// json.legend = legend;
	// json.series = series;
	private Map<String,String> title;
	private Tootip tootip;
	public Tootip getTootip() {
		return tootip;
	}
	public void setTootip(Tootip tootip) {
		this.tootip = tootip;
	}
	private Map<String,String> subTitle;
	private XAxis xAxis;
	private ArrayList<Series> arrSeries;
	public Legend lengend;
	private YAxis yAxis;
	public Map<String, String> getTitle() {
		return title;
	}
	public void setTitle(Map<String, String> title) {
		this.title = title;
	}
	public Map<String, String> getSubTitle() {
		return subTitle;
	}
	public void setSubTitle(Map<String, String> subTitle) {
		this.subTitle = subTitle;
	}
	public XAxis getxAxis() {
		return xAxis;
	}
	public void setxAxis(XAxis xAxis) {
		this.xAxis = xAxis;
	}
	public ArrayList<Series> getArrSeries() {
		return arrSeries;
	}
	public void setArrSeries(ArrayList<Series> arrSeries) {
		this.arrSeries = arrSeries;
	}
	public Legend getLengend() {
		return lengend;
	}
	public void setLengend(Legend lengend) {
		this.lengend = lengend;
	}
	public YAxis getyAxis() {
		return yAxis;
	}
	public void setyAxis(YAxis yAxis) {
		this.yAxis = yAxis;
	}

	

}

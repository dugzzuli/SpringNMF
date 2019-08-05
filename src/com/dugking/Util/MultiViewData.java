package com.dugking.Util;

import java.util.ArrayList;

public class MultiViewData {
	public  String url;
	public int numView;
	public int getNumView() {
		return numView;
	}
	public void setNumView(int numView) {
		this.numView = numView;
	}
	public static MultiViewData getMultiViewData() {
		return multiViewData;
	}
	public static void setMultiViewData(MultiViewData multiViewData) {
		MultiViewData.multiViewData = multiViewData;
	}
	public  String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	private static MultiViewData multiViewData;
	private MultiViewData(String url){
		this.setUrl(url);
	}
	
	public static  MultiViewData getInstance(String url){
		
		if(multiViewData==null)
		{
			multiViewData=new MultiViewData(url);
			multiViewData.setUrl(url);
			return multiViewData ;
		}
		else
		return multiViewData;
		
	}
	
	public int getNum(){
		return this.getLabel()[0].length;
	}
	
	public int getDimnum(int index){
		
		return this.getListView().get(index).length;
	}
	
	ArrayList<double[][]> listView;
	double[][] label;
	public ArrayList<double[][]> getListView() {
		return listView;
	}
	public void setListView(ArrayList<double[][]> listView) {
		this.setNumView(listView.size());
		this.listView = listView;
	}
	public double[][] getLabel() {
		return label;
	}
	public void setLabel(double[][] label) {
		this.label = label;
	}
}

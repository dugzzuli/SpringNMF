package com.dugking.DTO;

public class GetMethodParam {
	
	private String datasets;
	private String method;
	private int clusterNum;
	private int maxIter;
	private int relarErr;
	private double aplpha;
	int numsSamples;
	public int getNumsSamples() {
		return numsSamples;
	}
	public void setNumsSamples(int numsSamples) {
		this.numsSamples = numsSamples;
	}
	public double getAplpha() {
		return aplpha;
	}
	public void setAplpha(double aplpha) {
		this.aplpha = aplpha;
	}
	public String getMethod() {
		return method;
	}
	public void setMethod(String method) {
		this.method = method;
	}
	public int getClusterNum() {
		return clusterNum;
	}
	public void setClusterNum(int clusterNum) {
		this.clusterNum = clusterNum;
	}
	public int getMaxIter() {
		return maxIter;
	}
	public void setMaxIter(int maxIter) {
		this.maxIter = maxIter;
	}
	public int getRelarErr() {
		return relarErr;
	}
	public void setRelarErr(int relarErr) {
		this.relarErr = relarErr;
	}
	public String getAbsoluteErr() {
		return absoluteErr;
	}
	public void setAbsoluteErr(String absoluteErr) {
		this.absoluteErr = absoluteErr;
	}
	public String getDatasets() {
		return datasets;
	}
	public void setDatasets(String datasets) {
		this.datasets = datasets;
	}
	private String absoluteErr;
	
	
}

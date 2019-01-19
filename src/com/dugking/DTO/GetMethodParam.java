package com.dugking.DTO;

public class GetMethodParam {
	
	private String method;
	private int clusterNum;
	private int maxIter;
	private int relarErr;
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
	private String absoluteErr;
	
	
}

package com.dugking.DTO;

public class DatasetsAttr {
	String desc;
	int numViews;
	int samples;
	String url;
	int clusterNum;
	String Datasetname;
	public String getDatasetname() {
		return Datasetname;
	}

	public void setDatasetname(String datasetname) {
		Datasetname = datasetname;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public int getNumViews() {
		return numViews;
	}

	public void setNumViews(int numViews) {
		this.numViews = numViews;
	}

	public int getSamples() {
		return samples;
	}

	public void setSamples(int samples) {
		this.samples = samples;
	}

	public int getClusterNum() {
		return clusterNum;
	}

	public void setClusterNum(int clusterNum) {
		this.clusterNum = clusterNum;
	}

	
}

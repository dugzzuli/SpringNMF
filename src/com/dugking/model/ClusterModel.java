package com.dugking.model;

public class ClusterModel {
	public double[][] clusterVector;
	public int[] label;
	
	public double[][] getClusterVector() {
		return clusterVector;
	}
	public void setClusterVector(double[][] clusterVector) {
		this.clusterVector = clusterVector;
	}
	public int[] getLabel() {
		return label;
	}
	public void setLabel(int[] label) {
		this.label = label;
	}
}

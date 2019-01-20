package com.dugking.algorithmMNMF;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import Jama.Matrix;
import Jama.util.Maths;
import smile.clustering.KMeans;

public abstract class MNMF_Base implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2600077191912387912L;

	private List<Matrix> listV;
	
	/**
	 * k �������
	 */
	private int k;
	public int getK() {
		return k;
	}

	public void setK(int k) {
		this.k = k;
	}

	public double getAbsuluteErr() {
		return absuluteErr;
	}

	public void setAbsuluteErr(double absuluteErr) {
		this.absuluteErr = absuluteErr;
	}

	public double getRelarErr() {
		return relarErr;
	}

	public void setRelarErr(double relarErr) {
		this.relarErr = relarErr;
	}

	public int getMaxIter() {
		return maxIter;
	}

	public void setMaxIter(int maxIter) {
		this.maxIter = maxIter;
	}

	public double[][] getErrAll() {
		return errAll;
	}

	public void setErrAll(double[][] errAll) {
		this.errAll = errAll;
	}

	public int getM() {
		return m;
	}

	public void setM(int m) {
		this.m = m;
	}

	public int getN() {
		return n;
	}

	public void setN(int n) {
		this.n = n;
	}

	public int getFinalIter() {
		return finalIter;
	}

	public void setFinalIter(int finalIter) {
		this.finalIter = finalIter;
	}

	public int[] getLabelCluster() {
		return labelCluster;
	}

	public void setLabelCluster(int[] labelCluster) {
		this.labelCluster = labelCluster;
	}

	/**
	 * absuluteErr  �������
	 */
	private double absuluteErr=Math.pow(0.1, 5);
	
	/**
	 * relarErr ������
	 */
	private double relarErr=Math.pow(0.1, 5);
	/**
	 * ����������
	 */
	private int maxIter=1000;
	
	/**
	 * �����������
	 */
	private double[][] errAll;
	/**
	 * m ������
	 */
	private int m;
	/**
	 * ������
	 */
	private int n;
	
	/**
	 * ���յ�������
	 */
	private int finalIter;
	
	
	/**
	 * ��¼��ǩ
	 */
	private int[] labelCluster;

	private Matrix W;
	
	
	private Matrix H;
	
	private int viewNum;
	public Matrix getW() {
		return W;
	}

	public void setW(Matrix w) {
		W = w;
	}

	public Matrix getH() {
		return H;
	}

	public void setH(Matrix h) {
		H = h;
	}

	public int getViewNum() {
		return viewNum;
	}

	public void setViewNum(int viewNum) {
		this.viewNum = viewNum;
	}

	public List<Matrix> getListH() {
		return listH;
	}

	public void setListH(List<Matrix> listH) {
		this.listH = listH;
	}

	/**
	 *��ƬNMF ��H ����
	 */
	private List<Matrix> listH=new ArrayList<Matrix>();
	
	
	/**
	 * @param listV ��������
	 * @param maxIter ��������
	 * @param clusterNum ������Ŀ
	 * @param absErr �������
	 * @param relarErr ������
	 */
	public MNMF_Base(List<Matrix> listV,int maxIter, int clusterNum, double absErr, double relarErr){
		this.setListV(listV);
		for (Matrix matrix : listV) {
			this.checkIsHasNOn(matrix);
		}
		this.setViewNum(listV.size());
		this.setMaxIter(maxIter);
		this.setK(clusterNum);
		this.setAbsuluteErr(absErr);
		this.setRelarErr(relarErr);
		this.setM(this.getListV().get(0).getRowDimension());
		this.setN(this.getListV().get(0).getColumnDimension());
		
		this.W = Matrix.random(this.m, this.k);
		this.H = Matrix.random(this.n, this.k);
		
		if (checkIsHasNOn(this.W, this.m, this.k)) {
			System.err.println("�ֽ��ꇲ��ܞ鸺��....E");
			return;
		}
		
		if (checkIsHasNOn(this.H, this.n, this.k)) {
			System.err.println("�ֽ��ꇲ��ܞ鸺��....H");
			return;
		}
		for (int i = 0; i < this.getViewNum(); i++) {
			this.getListH().add(H);
		}
		this.setErrAll(new double[this.getMaxIter()][1]);
		this.setFinalIter(maxIter);
	}
	
	public List<Matrix> getListV() {
		return listV;
	}

	public void setListV(List<Matrix> listV) {
		this.listV = listV;
	}
	
	/**
	 * @param updateW �滻����
	 * @param eps �滻��ֵ
	 * @return Matrix �滻��ľ���
	 */
	 Matrix updateWreplaceEps(Matrix updateW, double eps) {
		// TODO Auto-generated method stub
		int mm=updateW.getRowDimension();
		int nn=updateW.getColumnDimension();
		for (int j = 0; j <mm; j++) {
			for (int j2 = 0; j2 < nn; j2++) {
				if(updateW.get(j, j2)<0)
				{
					updateW.set(j, j2, eps);
				}
			}

		}
		return updateW;
	}

	/**
	 * @param V �������
	 * @param mm ��������
	 * @param nn ��������
	 * @return
	 */
	public boolean checkIsHasNOn(Matrix V, int mm, int nn) {
		double[][] VM = V.getArray();
		for (int i = 0; i < mm; i++) {
			for (int j = 0; j < nn; j++) {
				if (VM[i][j] < 0) {
					return true;
				}
			}
		}
		return false;
	}
	/**
	 * ��������
	 */
	public abstract void update();
	
	
	/**
	 * @param clusterInc ͨ��������� ��ÿһ����һ������
	 */
	public void getClusterLabel(Matrix clusterInc) {
		KMeans km=new smile.clustering.KMeans(clusterInc.getArray(),this.k);
		this.labelCluster=km.getClusterLabel();
	}
	
	/**
	 * @param normV ��Ҫ���㷶���ĺ�
	 * @return
	 */
	public double getNorm(Matrix normV) {
		return normV.normF();

	}
	private double getDoubleMatrix(Matrix normV){
		double f = 0;
		double[][] A = normV.getArray();
	      for (int i = 0; i < m; i++) {
	         for (int j = 0; j < n; j++) {
	           f=f+A[i][j]*A[i][j];
	         }
	      }
	      return Math.sqrt(f);
	}
	/**
	 * @param V ���һ�������Ƿ��и���
	 * @return
	 */
	public boolean checkIsHasNOn(Matrix V) {
		double[][] VM = V.getArray();
		for (int i = 0; i < m; i++) {
			for (int j = 0; j < n; j++) {
				if (VM[i][j] < 0) {
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * @return ��ȡ��ʧ�������
	 */
	public abstract double getErrOBJ();
	
	
	
}

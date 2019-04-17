package com.dugking.algorithmMNMF;

import java.util.ArrayList;
import java.util.List;

import com.dugking.Util.GraphType;
import com.dugking.manifold.LaplanceDug;

import Jama.Matrix;

public class GMNMF extends MNMF {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public int getVerbose() {
		// TODO Auto-generated method stub
		return super.getVerbose();
	}

	@Override
	public void setVerbose(int verbose) {
		// TODO Auto-generated method stub
		super.setVerbose(verbose);
	}

	/**
	 * @return 拉普拉斯正则...误差
	 */
	public double getErrL()
	{
		double sum=0;
	for (Matrix matrix : lAll) {
		sum=sum+this.getW().transpose().times(matrix).times(this.getW()).trace();
	}	
		return sum;
		
	}
	@Override
	public double getErrOBJ() {
		// TODO Auto-generated method stub

		return super.getErrOBJ()+getErrL();
	}

	public List<Matrix> dAll;
	public List<Matrix> wAll;
	public List<Matrix> lAll;

	public List<Matrix> getdAll() {
		return dAll;
	}

	public void setdAll(List<Matrix> dAll) {
		this.dAll = dAll;
	}

	public List<Matrix> getwAll() {
		return wAll;
	}

	public void setwAll(List<Matrix> wAll) {
		
		
		
		this.wAll = wAll;
	}

	private double alpha;

	/**
	 * @param listV
	 * @param maxIter
	 * @param clusterNum
	 * @param absErr
	 * @param relarErr
	 * @param verbose 是否显示日志
	 * @param alpha
	 */
	public GMNMF(List<Matrix> listV, int maxIter, int clusterNum, double absErr, double relarErr, int verbose,
			double alpha) {
		super(listV, maxIter, clusterNum, absErr, relarErr, verbose);
		this.setVerbose(verbose);
		this.setAlpha(alpha);
		dAll = new ArrayList<Matrix>();
		wAll = new ArrayList<Matrix>();
		lAll=new ArrayList<Matrix>();
		this.initDW();
	}
	
	public void initDW(){
		LaplanceDug eigenmap ;
		for (Matrix matrix : this.getListV()) {
			 eigenmap = new LaplanceDug(matrix.getArray(),5, 0.5,GraphType.Binary);
			Matrix d=eigenmap.getdDug();
			Matrix w=eigenmap.getwDug();
			dAll.add(d);
			wAll.add(w);
			lAll.add(d.minus(w));
		}
		
	}
	
	@Override
	public void update() {
		// TODO Auto-generated method stub
		double lastErr = Double.MAX_VALUE;
		double eps = Math.pow(0.1, 10);
		for (int i = 0; i < this.getMaxIter(); i++) {

			List<Matrix> upWAll = new ArrayList<Matrix>();
			for (int j = 0; j < this.getViewNum(); j++) {
				Matrix VTW = this.getListV().get(j).transpose().times(this.getW());
				
				upWAll.add(VTW);
			}

			List<Matrix> downWAll = new ArrayList<Matrix>();
			for (int j = 0; j < this.getViewNum(); j++) {
				Matrix MM = this.getW();
				Matrix downW = this.getListH().get(j).times(MM.transpose()).times(MM);
				downWAll.add(downW);
			}

			for (int j = 0; j < this.getViewNum(); j++) {
				Matrix updateW = upWAll.get(j).arrayRightDivide(downWAll.get(j));
				updateW = super.updateWreplaceEps(updateW, eps);
				Matrix HH = this.getListH().get(j);
				HH = HH.arrayTimes(updateW);
				this.getListH().set(j, HH);
			}

			Matrix upH = new Matrix(this.getM(), this.getK());
			
			Matrix upLw = new Matrix(this.getM(), this.getK());
			for (int j = 0; j < this.getViewNum(); j++) {
				Matrix lw=this.wAll.get(j).times(this.getW());
				upLw.plusEquals(lw);
			}
					
			for (int j = 0; j < this.getViewNum(); j++) {
				
				upH.plusEquals(this.getListV().get(j).times(this.getListH().get(j)));
			}
			if(this.getAlpha()>0)
			upH.plusEquals(upLw.times(this.getAlpha()));
			
			
			Matrix downH = new Matrix(this.getM(), this.getK());
			Matrix downLD = new Matrix(this.getM(), this.getK());
			for (int j = 0; j < this.getViewNum(); j++) {
				
				
				Matrix HH = this.getListH().get(j);
				
				downLD.plusEquals(this.dAll.get(j).times(this.getW()));
				downH.plusEquals(this.getW().times(HH.transpose()).times(HH));
			}
			if(this.getAlpha()>0)
			{
				downH.plusEquals(downLD.times(this.getAlpha()));
			}

			
			Matrix updateH = upH.arrayRightDivide(downH);
			updateH = super.updateWreplaceEps(updateH, eps);
			Matrix WW = this.getW();
			WW.arrayTimesEquals(updateH);
			double err = this.getErrOBJ();
			if (this.getVerbose() == 1) {
				System.out.println("正在更新..." + i);

				System.out.println("绝对誤差:" + err);

				System.out.println("绝对誤差:" + Math.abs(lastErr - err));
			}
			this.getErrAll()[i][0] = err;

			if (err < this.getAbsuluteErr()) {
				System.out.println("绝对误差值终止");
				this.setFinalIter(i);
				break;
			}
			if (Math.abs(lastErr - err) < this.getRelarErr()) {
				System.out.println("相对误差值终止");
				this.setFinalIter(i);
				break;
			}
			lastErr = err;
		}

	}

	public double getAlpha() {
		return alpha;
	}

	public void setAlpha(double alpha) {
		this.alpha = alpha;
	}

}

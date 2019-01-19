package com.dugking.mainRun;

import java.util.ArrayList;
import java.util.List;

import com.dugking.Util.SerizelizeModel;
import com.dugking.algorithmMNMF.MNMF;

import Jama.Matrix;

public class DemoMNMFSerilize {
	public static void main(String[] args) {
		List<Matrix> listV=new ArrayList<Matrix>();
		for (int i = 0; i < 3; i++) {
			listV.add(Matrix.random(100, 100).times(100));
		}
		MNMF model=new MNMF(listV, 1000, 3, Math.pow(0.1, 10), Math.pow(0.1, 10),0);
		model.update();
		SerizelizeModel.serlizeModel(model, "src/com/dugking/seriezeModel/MMNFModel.model");
		MNMF model2=SerizelizeModel.deSerlizeModel("src/com/dugking/seriezeModel/MMNFModel.model");
		model2.getH().print(4, 2);
	}
}

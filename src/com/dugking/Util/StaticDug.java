package com.dugking.Util;

public class StaticDug {
	public static double getMax(double[][] arr, int index) {
		int m = arr.length;
		int n = arr[0].length;
		double max = 0;
		for (int i = 0; i < m; i++) {
			if (arr[i][index] > max) {
				max = arr[i][index];
			}
		}
		return max;
	}

	public static double getMin(double[][] arr, int index) {
		int m = arr.length; // 行
		int n = arr[0].length; // 列 一列 一个样本

		double min = 9999;
		for (int i = 0; i < m; i++) {
			if (arr[i][index] < min) {
				min = arr[i][index];
			}
		}
		return min;
	}

	public static double getMean(double[][] arr, int index) {
		int m = arr.length;
		int n = arr[0].length;
		double sum = 0;
		for (int i = 0; i < m; i++) {

			sum += arr[i][index];
		}
		return sum / m;
	}

	public static double[] getIndexData(double[][] arr, int index) {

		int m = arr[0].length;
		double[] re = new double[m];
		for (int i = 0; i < m; i++) {

			re[i] = arr[i][index];

		}
		return re;
	}

	public static int[] getIndexDataLabel(double[][] arr, int index) {

		int m = arr[0].length;

		int[] re = new int[m];
		for (int i = 0; i < m; i++) {

			re[i] = i;

		}
		return re;
	}

	public static int getCurViewDim(double[][] arr, int index) {

		int m = arr.length;

		return m;
	}

	// 标准差σ=sqrt(s^2)
	public static double getStandardDiviation(double[][] arr, int index) {
		int m = arr.length;
		double[] x = new double[m];
		for (int i = 0; i < m; i++) {
			x[i] = arr[i][index];
		}

		double sum = 0;
		for (int i = 0; i < m; i++) {// 求和
			sum += x[i];
		}
		double dAve = sum / m;// 求平均值
		double dVar = 0;
		for (int i = 0; i < m; i++) {// 求方差
			dVar += (x[i] - dAve) * (x[i] - dAve);
		}
		return Math.sqrt(dVar / m);
	}

}

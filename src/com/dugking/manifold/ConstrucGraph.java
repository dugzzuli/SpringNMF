package com.dugking.manifold;

import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.dugking.Util.CosineDistance;
import com.dugking.Util.GraphType;

import smile.data.SparseDataset;
import smile.graph.AdjacencyList;
import smile.graph.Graph;
import smile.graph.Graph.Edge;
import smile.math.Math;
import smile.math.distance.EuclideanDistance;
import smile.math.matrix.SparseMatrix;
import smile.neighbor.CoverTree;
import smile.neighbor.KDTree;
import smile.neighbor.KNNSearch;
import smile.neighbor.Neighbor;

public class ConstrucGraph {
	private static final Logger logger = LoggerFactory.getLogger(ConstrucGraph.class);
	private Graph graph;
	public Graph getGraph() {
		return graph;
	}
	public void setGraph(Graph graph) {
		this.graph = graph;
	}
	public static Logger getLogger() {
		return logger;
	}
	
	
	private double[][] graphKnn;
	
	public Jama.Matrix getGraphKnn() {
		return new Jama.Matrix(graphKnn);
	}
	public void setGraphKnn(double[][] graphKnn) {
		this.graphKnn = graphKnn;
	}
	/**
	 * @param data ��������
	 * @param nn ��nn���ھ�
	 * @param k ǰk���ھ�
	 * @param type ��������
	 */
	public ConstrucGraph(double[][] data,int nn,int k, GraphType type)
	{
		int n = data.length;
		KNNSearch<double[], double[]> knn = null;
		if (data[0].length < 10) {
			knn = new KDTree<>(data, data);
		} else {
			if (type == GraphType.HeartKernel)
				knn = new CoverTree<>(data, new EuclideanDistance());
			else if (type == GraphType.Cosine) {
				knn = new CoverTree<>(data, new CosineDistance());
			} else if (type == GraphType.Binary) {
				knn = new CoverTree<>(data, new EuclideanDistance());
			}
		}
		
		graph = new AdjacencyList(n);
		for (int i = 0; i < n; i++) {
			//ѡȡ�����k����
			Neighbor<double[], double[]>[] neighbors = knn.knn(data[i], k);
			//ѡȡ��ǰ��ǰi�ĵ�nn���ھ�
			Neighbor<double[], double[]>[] neighborsNNFenmuI = knn.knn(data[i], nn);
			double gama1=neighborsNNFenmuI[nn-1].distance;
			
			for (int j = 0; j < k; j++) {
				switch (type) {
				case Binary:
					graph.setWeight(i, neighbors[j].index,1.0);
					break;
				case HeartKernel:
					//��ȡ��ǰ����j�ĵ�nn���ھ�
					Neighbor<double[], double[]>[] neighborsNNFenmuJ = knn.knn(data[j], nn);
					double gama2=neighborsNNFenmuJ[nn-1].distance;
					//��ȡ��i�������͵�j������֮��ľ���
					double weight=Math.sqr(neighbors[j].distance);
					//��ȡ����
					double gama=-1.0/(gama1*gama2);
					
					weight=Math.exp(gama * weight);
					graph.setWeight(i, neighbors[j].index, weight);
					//����Ȩ��
					break;
				case Cosine:
					double weightCosine=neighbors[j].distance;
					graph.setWeight(i, neighbors[j].index, weightCosine);

					break;
				default:
					break;
				}
				
				
			}
		}
		SparseDataset W = new SparseDataset(n);
		for (int i = 0; i < n; i++) {
			Collection<Edge> edges = graph.getEdges(i);
			for (Edge edge : edges) {
				int j = edge.v2;
				if (i == j) {
					j = edge.v1;
				}
				double w = edge.weight;
				W.set(i, j, w);
			}
		}
		this.setGraphKnn(W.toArray());
	}

}

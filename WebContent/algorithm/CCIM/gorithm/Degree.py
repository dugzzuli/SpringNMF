#!/usr/bin/env python
# coding=utf-8

import networkx as nx
import matplotlib.pyplot as plt
#import graphviz
#from Queue import PriorityQueue
import random
import Evaluation


class Degree_Heuristic():
    def __init__(self, graph_path):
        self.graph, self.num_node, self.num_edge = self.load_graph(graph_path)

    def load_graph(self, graph_path):
        G = nx.Graph()
        with open(graph_path,'r') as f:
            for i, line in enumerate(f):
                if i == 0:
                    num_node, num_edge = line.strip().split(' ')
                    continue
                node1,node2=line.strip().split('\t')
                G.add_edge(int(node1),int(node2))
        return G, int(num_node), int(num_edge)


    def seed_selection(self,k):
        print ("Finding top",k,"nodes")
        print ("No.\tNode_id\tDegree\tTimes(s)")
        pairs=dict()
        seed_set=[]
        for node in self.graph.nodes():
            degree = self.graph.degree(node)
            pairs[node]=degree
            if len(pairs)>k:
                pairs=dict(sorted(pairs.items(),key=lambda item:item[1],reverse=False)[1:])

        for i in range(0,k):
            best_pair = sorted(pairs.items(),key=lambda item:item[1],reverse=True)[0]
            pairs=dict(sorted(pairs.items(),key=lambda item:item[1],reverse=True)[1:])
            seed_set.append(best_pair[0])
            print (i+1,"\t",best_pair[0],"\t",best_pair[1],"\t",0)
        return seed_set


    def draw_graph(self):
        nx.draw(self.graph)
        plt.show()

if __name__ == '__main__':
    DH = Degree_Heuristic('../LFR/100_3_0.01.txt')
    seeds=DH.seed_selection(50)
    # inf=Evaluation.monte_carlo(DH,list(seeds),50,10)
    # print "Total influence:",inf
    print(seeds)

    seed1 = [4996, 4993, 4997, 4995, 4998, 4994, 4991, 4992, 4978, 5000, 4986, 4988, 4980, 4981, 4976, 4999, 4977, 4982, 4985, 4979, 4968, 4971, 4983, 4975, 4987, 4974, 4960, 4984, 4957, 4990, 4966, 4969, 4964, 4970, 4961, 4989, 4965, 4951, 4963, 4959, 4973, 4972, 4962, 4952, 4956, 4958, 4953, 4942, 4954, 4937]
    seed = [4998, 4994, 5000, 4996, 4995, 4997, 4999, 4993, 4987, 4991, 4992, 4989, 4978, 4973, 4988, 4986, 4985, 4974, 4975, 4976, 4966, 4970, 4983, 4977, 4990, 4984, 4972, 4968, 4979, 4981, 4965, 4967, 4980, 4982, 4959, 4950, 4948, 4971, 4961, 4955, 4969, 4952, 4956, 4946, 4949, 4947, 4962, 4960, 4958, 4942]
    a=[1,5,10,15,20,25,30,35,40,45,50]
    for num in a:
        inf=Evaluation.monte_carlo(DH,seeds,num,10000)
        print ("seed number:",num,"Total influence:",inf)
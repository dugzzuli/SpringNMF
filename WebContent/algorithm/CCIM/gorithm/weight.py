import networkx as nx
import math
import random

def load_graph(graph_path):  # 读入图 无向无权图
    G = nx.Graph()
    with open(graph_path, 'r') as f:
        for i, line in enumerate(f):
            if i == 0:
                num_node, num_edge = line.strip().split(' ')
                continue
            node1, node2 = line.strip().split('\t')
            G.add_edge(int(node1), int(node2))
    print(G.number_of_nodes())
    return G

def list_community(comm_path):
    community_comm = dict()  # community_comm 用于存放社区{0：1，2，3  1：4，5，6}
    with open(comm_path, 'r') as f:
        for i, line in enumerate(f):
            list = []
            nodes_in_comm = line.strip().split('\t')

            for node in nodes_in_comm:
                list.append(int(node))
            community_comm[i] = list
    print(community_comm)
    return community_comm



if __name__ == '__main__':

    network = '../LFR/80_5_0.01.txt'
 #   community = './community/NeTHEPT_com.txt'
    G = load_graph(network)
  #  comm = list_community(community)



    with open('../LFR/80_5_0.01_weight.txt', 'w') as fr:
        fr.write(str(G.number_of_nodes()))
        fr.write(' ')
        fr.write(str(G.number_of_edges()))
        fr.write('\n')
        for node in G.nodes():
            for node1 in G.neighbors(node):
                    fr.write(str(node))
                    fr.write(' ')
                    fr.write(str(node1))
                    fr.write(' ')
                    fr.write(str('%.6f'% (1.0/G.degree(node1))))
                  #  fr.write(str('%.6f' % random.uniform(0.001,0.5)))
                    fr.write('\n')







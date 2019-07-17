import networkx as nx
import math
import Evaluation

class my():
    def __init__(self, graph_path, comm_path):
        self.graph,self.num_node= self.load_graph(graph_path)
        self.comm,self.list_comm  = self.load_comm(comm_path) #存放节点的社区,存放社区列表

        self.com_ave_short_len = self.get_com_average_short_len() #存放社区的平均最短路径
        self.com_ave_degree = self.get_com_average_degree()

    def load_graph(self,graph_path):  # 读入图 无向无权图
        G = nx.Graph()
        with open(graph_path, 'r') as f:
            for i, line in enumerate(f):
                if i == 0:
                    num_node, num_edge = line.strip().split(' ')
                    continue
                node1, node2 ,wei= line.strip().split(' ')
                G.add_edge(int(node1), int(node2),weight = float(wei))
        return G,int(num_node)

    def load_comm(self,comm_path):  # 读入社区
        node2comm = dict()
        community_comm = dict()
        with open(comm_path, 'r') as f:
            for i, line in enumerate(f):
                nodes_in_comm = line.strip().split('\t')
                print(nodes_in_comm)
                list = []
                for node in nodes_in_comm:
                    list.append(int(node))
                    list1 = []
                    if node in node2comm.keys():
                        list1 = node2comm[node]
                        list1.append(i)
                        node2comm[node] = list1
                    else:
                        list1.append(i)
                        node2comm[int(node)] = list1
                community_comm[i] = list
   #     print(node2comm)
    #    print(sorted(node2comm.items(), key=lambda item: item[0], reverse=False))
    #    print(community_comm)
        return node2comm ,community_comm

    def compute_potential(self): #计算节点的邻居势
        plt_arr = {}
        for node in self.graph.nodes:
            score = 0.0
            for nei in self.graph.neighbors(node):
               score += float(self.graph.get_edge_data(node,nei).get('weight'))
            plt_arr[node] = score
    #    print(plt_arr)
     #   print(sorted(plt_arr.items(), key=lambda item: item[1], reverse=True))
        return plt_arr

    def get_com_average_short_len(self):
        com_average_short_len = {}
        for item in self.list_comm.items():
          #  print(item[1])
            G = self.graph.subgraph(item[1])

            if nx.is_connected(G):# nx.is_empty(G) or
                com_average_short_len[item[0]] = '%.6f' % (1.0 / (nx.average_shortest_path_length(G)+1))

            else:
                com_average_short_len[item[0]] = '%.6f' % (1.0 / 1000)
                print("no")
                print(item[0])
                L = G.number_of_edges()
                N = G.number_of_nodes()
             #   print(L)
           #    print(N)
             #   com_average_short_len[item[0]] = '%.6f'%( (2*L) /(N*(N-1)))

   #     print(com_average_short_len)
        with open('../LFR_community/80_5_0.01_com_avelen.txt', 'w') as fr:
            for item in com_average_short_len.items():
                fr.write(str(item[0]))
                fr.write('\t')
                fr.write(str(item[1]))
                fr.write('\n')
        return com_average_short_len

    def get_com_average_degree(self):
        com_average_degree = {}
        for item in self.list_comm.items():
         #   print(item[1])
            G = self.graph.subgraph(item[1])


            total=sum(int(G.degree(node)) for node in G.nodes() )
         #   com_average_degree[item[0]] = '%.6f' % (total/G.number_of_nodes())
     #   print(sorted(com_average_degree.items(), key=lambda item: item[1], reverse=True))
        return com_average_degree






if __name__ == '__main__':
    network = '../LFR/80_5_0.01_weight.txt'
    community = '../LFR_community/community_80_5_c0.01.txt'
    my = my(network,community)

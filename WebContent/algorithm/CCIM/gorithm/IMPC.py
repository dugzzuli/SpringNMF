import timeit
import networkx as nx
import matplotlib.pyplot as plt
import math
#import graphviz
#from Queue import PriorityQueue
import random
import Evaluation


# S_STATE=0
# I_STATE=1
# SI_STATE=2
# R_STATE=3

class CoFIM():
    def __init__(self, graph_path, comm_path):
        self.graph, self.num_node = self.load_graph(graph_path)
        self.comm = self.load_comm(comm_path)
        self.list_comm = self.list_community(comm_path)
        self.plt_arr = self.compute_potential()

    def load_graph(self, graph_path):
        G = nx.DiGraph()
        with open(graph_path,'r') as f:
            for i, line in enumerate(f):
                if i == 0:
                    num_node, num_edge = line.strip().split(' ')
                    continue
                node1,node2,wei=line.strip().split(' ')
                G.add_edge(int(node1),int(node2),weight=wei)
        print(num_node,num_edge)
        print(G.number_of_nodes())

        return G,int(num_node)

    def load_comm(self, comm_path):
        node2comm = dict()

        with open(comm_path,'r') as f:
            for i, line in enumerate(f):
                # node,commNo= line.strip().split('\t')
                # node2comm[int(node)-1]=int(commNo)-1
                nodes_in_comm = line.strip().split('\t')
                print(nodes_in_comm)

                for node in nodes_in_comm:
                    node2comm[int(node)] = i
            self.write_community(node2comm)
        return node2comm

    def list_community(self, comm_path):
        community_comm = dict()  # community_comm 用于存放社区{0：1，2，3  1：4，5，6}
        with open(comm_path, 'r') as f:
            for i, line in enumerate(f):
                list = []
                nodes_in_comm = line.strip().split('\t')

                for node in nodes_in_comm:
                    list.append(node)
                community_comm[i] = list
        return community_comm

    def write_community(self, node2comm):  # 将每个节点属于哪个社区写入文件中
        with open('../community/network_node_com.txt', 'w') as fr:
            for key in node2comm.keys():
                fr.write(str(key))
                fr.write('\t')
                fr.write(str(node2comm[key]))
                fr.write('\n')

    def compute_potential(self):
        plt_arr = {}
        for node in self.graph.nodes:
            score = 0.0
            for succ in self.graph.successors(node):
               score += float(self.graph.get_edge_data(node,succ).get('weight'))
            plt_arr[node] = score
        print(plt_arr)
        print(sorted(plt_arr.items(), key=lambda item: item[1], reverse=True))
        return plt_arr

    def get_com_inf(self,num_nodes,com_size,alpha,beta):
        return alpha * (1 - beta * math.exp(-2.0*com_size * num_nodes /(com_size + num_nodes)))

    def get_inf(self,node,alpha,beta):
        inf = 1.0  #the influence of node on itself
        inf += self.plt_arr[node]  #the influence of node on its direct neighbors
        inf1 = 0.0
        nc_map = {}  #nc_map用于存放node的邻居社区和社区中有多少node的邻居节点{0：2，1：3}
        for succ in self.graph.successors(node):
            inf_prob = float(self.graph.get_edge_data(node,succ).get('weight'))
            inf += inf_prob*self.plt_arr[succ]
            if self.comm[succ] not in nc_map.keys():
                nc_map[self.comm[succ]] = 1
            else:
                nc_map[self.comm[succ]] += 1
        #computer the inflence within communities
        for item in nc_map.items():
            neigh_com = item[0]
            num_node = item[1]
            com_size = len(self.list_comm[neigh_com])
            inf += self.get_com_inf(num_node,com_size,alpha,beta)
            inf1 += self.get_com_inf(num_node,com_size,alpha,beta)
        print(node,inf1)
        return inf

    def marginal_gain(self,node,r_arr,neigh_set,nc_map,alpha,beta):
        gain = 1.0 + self.plt_arr[node] #the increase by node's potential
        tmp_map = dict()
        if node in neigh_set: # if node is in the neighbor set of S
            gain -= (1-r_arr[node])*self.plt_arr[node] #its previously computed influence should be eliminated

        for succ in self.graph.successors(node):
            gain += r_arr[succ]*float(self.graph.get_edge_data(node,succ).get('weight'))*self.plt_arr[succ]
            if succ not in neigh_set: #if the neigh is new
                if self.comm[succ] not in tmp_map.keys():
                    tmp_map[self.comm[succ]] = 1
                else:
                    tmp_map[self.comm[succ]] += 1
        #computer the marginal gain of community influence
        for item in tmp_map.items():
            neigh_com = item[0]
            new_nodes = item[1]
            if neigh_com not in nc_map.keys():
                old_nodes = 0
            else:
                old_nodes = nc_map[neigh_com]
            com_size = len(self.list_comm[neigh_com])
            gain += self.get_com_inf(old_nodes+new_nodes,com_size,alpha,beta) - self.get_com_inf(old_nodes,com_size,alpha ,beta)
        return gain

    def add_seed(self,r_arr,seed_set,neigh_set,nc_map,node):
        seed_set.append(node)
        r_arr[node] = 0.0
        for succ in self.graph.successors(node):
            if r_arr[succ] == 1.0:  #succ不被影响的概率为1，succ一定不在种子集的邻居集中
                neigh_set.add(succ)  #添加到N(S)
                if self.comm[succ] not in nc_map.keys():
                    nc_map[self.comm[succ]] = 1
                else:
                    nc_map[self.comm[succ]] +=1

            inf_prob = float(self.graph.get_edge_data(node,succ).get('weight')) #the influence probability from node to neigh
            r_arr[succ] *=(1-inf_prob) #update the not influence probability from S to neigh
        return seed_set,neigh_set,nc_map

    def seed_selection(self,k,alpha,beta):
        print ("Finding top",k,"nodes")
        print ("No.\tNode_id")
        avg_degree = self.graph.number_of_edges()/ self.graph.number_of_nodes()  # 平均出度
        pairs = dict()

        r_arr = [1.0]*self.num_node #Initialize the reverse array

        tmp_set = set()
        for node in self.graph.nodes():
            if self.graph.degree(node)<avg_degree:
                continue
         #   tmp_set.add(node)
            score = self.get_inf(node,alpha,beta)
            print(node,score)
            tmp = sorted(pairs.items(), key=lambda item: item[1], reverse=False)  # 利用K值对paris进行升序排序

            if len(pairs) >= 10 * k and score <= tmp[0][1]:
                continue
            pairs[node] = score
            if len(pairs) > 10 * k:
                pairs = dict(sorted(pairs.items(), key=lambda item: item[1], reverse=False)[1:])
        pairs = dict(sorted(pairs.items(), key=lambda item: item[1], reverse=True))
        print("pairs：", pairs)

        updated=[True]*self.num_node   #检查是否更新
        seed_set=[] #种子集
        neigh_set=set() #种子的邻居集
        nc_map = {} #邻居社区map

        for i in range(0,k):
            best_pair = sorted(pairs.items(),key=lambda item:item[1],reverse=True)[0]
            pairs=dict(sorted(pairs.items(),key=lambda item:item[1],reverse=True)[1:])
         #Find the best candidate with CELF strategy
            while(updated[int(best_pair[0])] is not True):
                increase = self.marginal_gain(best_pair[0],r_arr,neigh_set,nc_map,alpha,beta)
                updated[best_pair[0]]=True
                pairs[best_pair[0]]=increase
                best_pair=sorted(pairs.items(),key=lambda item:item[1],reverse=True)[0]
                pairs=dict(sorted(pairs.items(),key=lambda item:item[1],reverse=True)[1:])
            seed_set,neigh_set,nc_map=self.add_seed(r_arr,seed_set,neigh_set,nc_map,best_pair[0])

            print(i+1,"\t",best_pair[0])  #
            updated=[False]*self.num_node
        return seed_set


if __name__ == '__main__':
    # network='../weighted_directed_nets/network.dat'
    # community='../weighted_directed_nets/community.dat'
    start =timeit.default_timer()
    network = '../LFR/5_5_weight.txt'
    community = '../LFR_community/community_5_5_nc0.01.txt'

   # community='../network/NetHEPT_com.txt'
    cofim = CoFIM(network,community)
    #print(cofim.compute_potential())
    seeds=cofim.seed_selection(50,0.5,0.5)
    #NetHEPT 0 0
    seed0 = [1719 ,17, 853 ,1442 ,60 ,799 ,48 ,84 ,3730 ,2115 ,446 ,502, 1160, 7611,689 ,405 ,13, 374 ,1780 ,1759, 1020 ,1062 ,6188, 1319, 5768, 58, 728, 1722 ,304 ,3351 ,5687 ,1583 ,1667 ,149, 3109 ,4151 ,250 ,3248 ,560, 191 ,1025, 319 ,156 ,569 ,4593 ,496, 2 ,654, 3687 ,1468]
    #NetHEPT 0.2 0.2
    seed1 = [17,1719 ,853 ,1442 ,799 ,60 ,84 ,48 ,2115 ,446 ,3730 ,502 ,1160 ,7611 ,405 ,689 ,374 ,13 ,1780, 1319 ,1759, 1020 ,304, 1062 ,58 ,728 ,5768 ,6188, 3351 ,1722, 1583, 149, 1667, 1025 ,250 ,5687 ,4151 ,191 ,3248 ,319 ,3109, 560, 496 ,2, 156, 654 ,569 ,1436 ,4474 ,1468]
    #NetHEPT 0.5 0.5
    seed2 = [1442 ,17, 853,1719,799, 60,446,84, 48,374, 405,2115,3730,1160, 1319,689,502, 304,7611, 13, 58,1780,728, 250, 1025,1759,1062, 319, 5768, 1020,191,1436, 1583,3351,285,5,496,149,1667,19,3654,9,1722,818,6188,654,114,1878, 4474, 22]
    # fcaebook 0.5 0.5
    seed3 = [107, 0, 3437, 1684, 1912, 348, 686, 414, 3980, 698, 483, 376, 563, 25, 917, 322, 428, 828, 119, 713, 475,
             1783, 56, 1888, 1505, 1730, 637, 1800, 1472, 277, 1431, 705, 1086, 412, 1352, 67, 136, 1663, 1768, 171,
             1536, 271, 896, 373, 805, 1277, 1584, 21, 484, 1827]
    #facebook 0.5 1
    seed4 = [107, 0, 3437, 1684, 1912, 348, 686, 414, 3980, 698, 483, 563, 376, 917, 428, 25, 1505, 322, 119, 828, 56,
             1352, 713, 1888, 136, 1085, 1730, 475, 1663, 637, 1783, 1768, 1472, 1800, 171, 1835, 1431, 1687, 1086, 67,
             1126, 1718, 705, 1536, 277, 1577, 412, 1360, 484, 21]
    #facebook 0.5 5
    seed5 =[107, 0 ,3437 ,1684 ,1912 ,348 ,414, 686, 3980 ,698 ,563 ,1593 ,1165 ,1465 ,1085 ,483 ,1687 ,1173 ,1577, 1505 ,1360 ,1029 ,1666 ,1555 ,1758, 1702, 1171 ,1369 ,1567 ,1327 ,1317, 1806 ,1835 ,917 ,1534 ,1718, 1077 ,1126, 1074 ,1803, 1274, 428, 1182, 1178, 951 ,1376 ,1088 ,136, 1852, 1283]
    a = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    #Facebook 0.5 2
    seed6 = [107, 0, 3437, 1684, 1912, 348, 414, 686, 3980, 698, 483, 563, 1505, 917, 428, 1085, 376, 1687, 1835, 322,
             1593, 119, 1577, 1165, 136, 1173, 1352, 1126, 1360, 1465, 1768, 25, 1663, 171, 1718, 56, 1666, 1555, 1029,
             1888, 637, 1702, 1730, 828, 1472, 1376, 1369, 1800, 1171, 1806]
        # Epinions 0.5 0.5
    seed7 = [763,18,634,645,5227,71399,143,737,7047,44,4415,790,136,1753,1720,751,637,1719,118,1179,1621,3924,791,3527,27,1533,2704,1619,4969,1029,4416,849,1440,770,725,1059,2239,1749,1596,1516,64,390,824,1,145,629,49,7040,77,1299]
    a=[1,5,10,15,20,25,30,35,40,45,50]
    #a = [1,2,3,4,5]

    #NetPHY 0.2 0.2
    seed8 = [4799,1372,7452,19304,1819,679,2191,9737,1692,5982,1211,1818,2178,9107,6222,2118,2268,1821,894,17374,2185,1396,632,1777,3825,879,2875,6648,1114,2182,688,2338,906,1395,633,567,681,1847,573,1456,1745,4326,740,985,1216,2925,3181,8902,11250,6089]

    #
    seed9 = [4929,4988,4992,4971,5000,4888,4928,4996,4975,4954,4961,4891,4980,4939,4986,4910,4998,4932,4951,4978,4999,4997,4882,4965,4987,4950,4970,4883,4972,4973,4974,4956,4864,4795,4958,4968,4930,4764,4917,4874,4849,4983,4873,4869,4967,4955,4817,4871,4976,4957]
    for num in a:
     # inf=Evaluation.mc_method1(cofim,seeds,num,1000)
        inf = Evaluation.monte_carlo1(cofim, seeds, num)
        print("seed number:", num, "Total influence:", inf)
    end = timeit.default_timer()
    print('Running time: %s Seconds' % (end - start))

import networkx as nx
import math
import Evaluation

class my():
    def __init__(self, graph_path, comm_path,com_avelen_path):
        self.graph,self.num_node,self.num_edge = self.load_graph(graph_path)
        self.comm,self.list_comm  = self.load_comm(comm_path) #存放节点的社区,存放社区列表
        self.plt_arr = self.compute_potential() #计算节点的邻居势
        self.com_size = self.get_com_size() # 存放社区的大小
        self.com_ave_short_len = self.load_com_avelen(com_avelen_path) #存放社区的平均最短路径

    def load_graph(self,graph_path):  # 读入图 无向无权图
        G = nx.DiGraph()
        with open(graph_path, 'r') as f:
            for i, line in enumerate(f):
                if i == 0:
                    num_node, num_edge = line.strip().split(' ')
                    continue
                node1, node2 ,wei= line.strip().split(' ')
                G.add_edge(int(node1), int(node2),weight = float(wei))
        print(G.number_of_edges())
        return G,int(num_node),int(num_edge)

    def load_comm(self,comm_path):  # 读入社区
        node2comm = dict()
        community_comm = dict()
        with open(comm_path, 'r') as f:
            for i, line in enumerate(f):
                nodes_in_comm = line.strip().split('\t')
                list = []

                for node in nodes_in_comm:
               #     print(node)
                    list.append(int(node))
                    list1 = []
                    if int(node) in node2comm.keys():
                        list1 = node2comm[int(node)]
                        list1.append(i)
                        node2comm[int(node)] = list1
                    else:
                        list1.append(i)
                        node2comm[int(node)] = list1
                community_comm[i] = list
    #    print(community_comm)
        return node2comm ,community_comm

    def load_com_avelen(self,com_avelen_path):
        com_avelen = dict()
        with open(com_avelen_path,'r') as f:
            for i,line in enumerate(f):
                com,len = line.strip().split('\t')
                com_avelen[int(com)] = float(len)
       # print(com_avelen)
        return com_avelen

    def compute_potential(self): #计算节点的邻居势
        plt_arr = {}
        for node in self.graph.nodes:
            score = 0.0
            for nei in self.graph.successors(node):
               score += float(self.graph.get_edge_data(node,nei).get('weight'))
            plt_arr[node] = score
      #  print(plt_arr)
     #   print(sorted(plt_arr.items(), key=lambda item: item[1], reverse=True))
        return plt_arr

    def get_out_com_inf(self,node,gamma):#对邻居社区的影响
        out_com_inf = 0.0
        nei_com = set()
        for nei in self.graph.successors(node):
            for com in self.comm[nei]:
                if com not in nei_com and com not in self.comm[node]:
                    nei_com.add(com)
                    out_com_inf += (gamma*(self.com_ave_short_len[com]) + (1-gamma)*(self.com_size[com]))
       # print(node,"out_com_inf",out_com_inf)
        return out_com_inf

    def get_in_com_inf(self,node,gamma):
        in_com_inf = 0.0
        for in_com_num in self.comm[node]:
            G = self.graph.subgraph(self.list_comm[in_com_num])
            in_com_inf += (gamma *(self.get_com_score(G,node))  + (1-gamma)*self.com_size[in_com_num])
        #    print(node,"in_com_inf",in_com_inf)
        return in_com_inf

    def get_com_score(self,G,node): #节点在所属社区中对其他节点的影响
        n = 0
        total_length = 1
        total = 1
        other_node = G.nodes()-G.successors(node)-set([node])
        if len(other_node) == 0:
            total_length = 0

        else:
            for node1 in other_node:
                if nx.has_path(G,source=node,target=node1):
                   # total =1
                    total += nx.shortest_path_length(G, source=node, target=node1)-1
                    n += 1
              #      print(total)
                total_length = n/total

        return total_length
      #  nx.connected_component_subgraphs
    def get_com_size(self):
        com_size ={}
        nor_com_size = {}
        for item in self.list_comm.items():
            com_size[item[0]] = len(item[1])
        max_size = float(max(com_size.values()))
        min_size = float(min(com_size.values()))
        for item in com_size.items():
            nor_com_size[item[0]] = (float(item[1])-min_size)/(max_size-min_size)
  #      print(nor_com_size)
        return nor_com_size

    def get_inf(self,node,alpha,beta,gamma):
        inf = 0.0
        for succ in self.graph.successors(node):
            inf_prob = float(self.graph.get_edge_data(node, succ).get('weight'))
            inf += inf_prob * self.plt_arr[succ]
        return self.plt_arr[node]+inf+alpha*self.get_in_com_inf(node,gamma)+beta*self.get_out_com_inf(node,gamma)

    def marginal_gain(self,r_arr,node,seed_set,neigh_set,in_com_set,out_com_set,alpha,beta,gamma):
        gain = self.plt_arr[node]#计算节点的邻居势
        if node in neigh_set: # if node is in the neighbor set of S
            gain -= (1-r_arr[node])*self.plt_arr[node] #its previously computed influence should be eliminated

        for succ in self.graph.successors(node):
      #      print(node)
            gain += r_arr[succ]*float(self.graph.get_edge_data(node,succ).get('weight'))*self.plt_arr[succ]

        for nei in set(self.graph.successors(node)).difference(seed_set):
            for nei_com in self.comm[nei]:
                if nei_com not in out_com_set and nei_com not in self.comm[node]:
                    gain += beta*(gamma * (self.com_ave_short_len[nei_com]) + (1 - gamma) * (self.com_size[nei_com]))
                if nei_com not in in_com_set and nei_com in self.comm[node]:
                    G = self.graph.subgraph(self.list_comm[nei_com])
                    gain += alpha*(gamma *(self.get_com_score(G,node))  + (1 - gamma) * self.com_size[nei_com])
        return gain

    def add_seed(self,r_arr,seed_set,neigh_set,in_com_set,out_com_set,node):
        seed_set.append(node)
        for nei in self.graph.successors(node):
            if r_arr[nei] == 1.0:
                neigh_set.add(nei)
            inf_prob = float( self.graph.get_edge_data(node, nei).get('weight'))  # the influence probability from node to neigh
            r_arr[nei] *= (1 - inf_prob)

        for in_com in self.comm[node]:
            in_com_set.add(in_com)
        for nei in self.graph.successors(node):
            if self.comm[nei] not in self.comm[node]:
                out_com_set.add(nei)

        return seed_set,neigh_set,in_com_set,out_com_set

    def seed_selection(self,k,alpha,beta,gamma):
        print ("Finding top",k,"nodes")
        print ("No.\tNode_id")
        avg_degree = self.graph.number_of_edges() / self.graph.number_of_nodes()  # 平均出度
        pairs = dict()
#        r_arr = [1.0]*self.num_node #Initialize the reverse array
        tmp_set = set()

        for node in self.graph.nodes():
            if self.graph.out_degree(node)<avg_degree:
                continue
            tmp_set.add(node)
            score = self.get_inf(node,alpha,beta,gamma)
            tmp = sorted(pairs.items(), key=lambda item: item[1], reverse=False)  # 利用K值对paris进行升序排序
            if len(pairs) >= 10 * k and score <= tmp[0][1]:
                continue
            pairs[node] = score
            if len(pairs) > 10 * k:
                pairs = dict(sorted(pairs.items(), key=lambda item: item[1], reverse=False)[1:])
        pairs = dict(sorted(pairs.items(), key=lambda item: item[1], reverse=True))
       # print("pairs：", pairs)

        updated = [True]*self.num_node#检查是否更新
        seed_set = []  #种子集
        neigh_set = set() #种子的邻居集
        in_com_set = set()#种子所属社区集
        out_com_set = set()#种子邻居社区集
        r_arr = [1.0] * self.num_node
        for i in range(0,k):
            best_pair = sorted(pairs.items(), key=lambda item:item[1],reverse=True)[0] #取影响力最大的那一项
            pairs = dict(sorted(pairs.items(), key=lambda item:item[1],reverse=True)[1:])  #去掉影响力最好的节点，剩余节点再排序
            while(updated[int(best_pair[0])] is not True):
                increase = self.marginal_gain(r_arr,best_pair[0],seed_set,neigh_set,in_com_set,out_com_set,alpha,beta,gamma)
                updated[best_pair[0]] = True
                pairs[best_pair[0]] = increase
                best_pair = sorted(pairs.items(),key=lambda item:item[1],reverse=True)[0]
                pairs = dict(sorted(pairs.items(),key=lambda item:item[1],reverse=True)[1:])
            seed_set,neigh_set,in_com_set,out_com_set = self.add_seed(r_arr,seed_set,neigh_set,in_com_set,out_com_set,best_pair[0])

            print(i+1,"\t",best_pair[0])
            updated = [False]*self.num_node
        return seed_set






if __name__ == '__main__':
    path="D:\\Users\\Administrator\\workspace2\\SpringNMF\\WebContent\\algorithm\\CCIM"
    network = path+'/LFR/100_3_0.01_weight.txt'
    community = path+'/LFR_community/community_100_3_c0.01.txt'
    com_avelen = path+'/LFR_community/100_3_0.01_com_avelen.txt'
    my = my(network,community,com_avelen)
    seeds = my.seed_selection(50,1,0.1,0.2)

    print(seeds)

    seed1 = [17, 1719, 853, 1442, 799, 60, 84, 48, 2115, 446, 3730, 502, 1160, 7611, 405, 689, 374, 13, 1780, 1319,
             1759, 1020, 304, 1062, 58, 728, 5768, 6188, 3351, 1722, 1583, 149, 1667, 1025, 250, 5687, 4151, 191, 3248,
             319, 3109, 560, 496, 2, 156, 654, 569, 1436, 4474, 1468]
    seed2 = [4799,1372,7452,1692,5982,1211,2178,9107,1819,679,2118,894,2191,2185,3825,632,9737,1818,2875,6648,1821,6222,2182,1395,633,567,1456,4326,2268,1777,985,879,2925,3181,1396,569,1745,906,5150,688,6844,681,573,1393,5004,1776,1037,1847,737,3593]
    seed3 = [4799,1372,7452,19304,1819,679,2191,9737,1692,5982,1211,1818,2178,9107,6222,2118,2268,1821,894,17374,2185,1396,632,1777,3825,879,2875,6648,1114,2182,688,2338,906,1395,633,567,681,1847,573,1456,1745,4326,740,985,1216,2925,3181,8902,11250,6089]

    a = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    a=[1]
    for num in a:
     # inf=Evaluati        inf = Evaluation.monte_carlo1(my, seeds, num)on.mc_method1(cofim,seeds,num,1000)
        inf = Evaluation.monte_carlo1(my, seeds, num)
        print("seed ncumber:", num, "Total influence:", inf)


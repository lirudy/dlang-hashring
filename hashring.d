/**
 *用到的技术有  md5 byte转long 位移操作
 *匿名函数，函数变量， lambda表达式
 *可变数组，关联数组（键值对）非hash的
 *数组排序，数组反转
 *
 */

import std.stdio;
import std.digest.md;
import std.math;
import std.conv;
import std.algorithm;

class HashRing{

    string[] nodes;
    long[] _sorted_keys;
    int[string] weights;
    string[long] ring;
    
    this(string[] tnodes, int[string] tweights){
    
        nodes = tnodes;
        
        weights = tweights;
        if (weights == null){
            weights[""] = 0;
        }
        
        generate_circle();
    }
    void generate_circle(){
        int total_weight = 0;
        foreach (v; this.nodes){
            if (v in this.weights){
                total_weight += this.weights[v];
            }else{
                total_weight += 1;
            }
        }
        string[long] sk;
        foreach (node; this.nodes){
            int weight = 1;
            if (node in this.weights)
                weight = this.weights[node];
            auto factor = floor((20 * this.nodes.length * weight) / total_weight);
            for(int i = 0; i < factor; i++){
                ubyte[] b_key = hash_digest(node ~ to!string(i));
                for(int j = 0; j < 3; j++){
                    /** another function usage.*/
                    //int func_lambda (int x){
                    //    return x + j*4;
                    //}
                    //auto n_key = hash_val(b_key, &func_lambda);
                    
                    auto n_key = hash_val(b_key, (int x) => x +j*4); //python lambda usage
                    
                    this.ring[n_key] = node;
                    sk[n_key] = node;
                }
            }
        }
        this._sorted_keys = sk.keys.sort;
    }

    
    string get_node(string key){
        int pos = get_node_pos(key);
        
        return this.ring[this._sorted_keys[pos]];
    
    }


    int get_node_pos(string key){
        if (this.ring.length < 1){
            return 0;
        }
        auto tkey = this.gen_key(key);
        auto rev_keys = this._sorted_keys.dup.reverse;
        auto pos = -1;
        foreach(idx, v; rev_keys){
            if (tkey > v) {
                pos = idx;
                break;
            }
        }
        
        if (pos < 1){
            return 0;
        }else{
            return rev_keys.length - pos;
        }
    }

    long hash_val(ubyte[] hash, int delegate(int) entry_fn){
        
        return to!long(( hash[entry_fn(3)] << 24)
                |(hash[entry_fn(2)] << 16)
                |(hash[entry_fn(1)] << 8)
                | hash[entry_fn(0)] );
    
    }
    ubyte[] hash_digest(string key){
        ubyte[] hash = md5Of(key);
        return hash;
    }
    long gen_key(string key){
        ubyte[] b_key = this.hash_digest(key);
        return this.hash_val(b_key, (int x) => x);
    
    }
}


void main (string[] args)
{   
    
    int[string] w;
    w["172.16.40.141"] = 1;
    w["172.16.40.142"] = 1;
    w["172.16.40.143"] = 1;
    w["172.16.40.144"] = 1;
    HashRing hr = new HashRing(w.keys,w);
    
    writeln(hr.get_node("232"));
    writeln(hr.get_node("3"));
    writeln(hr.get_node("fgsdfsd"));
    writeln(hr.get_node("4"));
    writeln(hr.get_node("23423432"));
    writeln(hr.get_node("33"));
    writeln(hr.get_node("333"));
    writeln(hr.get_node("3333"));
    writeln(hr.get_node("1"));
    writeln(hr.get_node("2"));
    writeln(hr.get_node("444"));
    writeln(hr.get_node("666"));
    
}

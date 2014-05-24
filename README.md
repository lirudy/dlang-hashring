dlang-hashring
==============

Hash Ring implemented by D language


Usage:
    import hashring
    int[string] w;
    w["172.16.40.141"] = 1;
    w["172.16.40.142"] = 1;
    w["172.16.40.143"] = 1;
    w["172.16.40.144"] = 1;
    HashRing hr = new HashRing(w.keys,w);
    
    writeln(hr.get_node("232"));
    writeln(hr.get_node("3"));
    writeln(hr.get_node("fgsdfsd"));
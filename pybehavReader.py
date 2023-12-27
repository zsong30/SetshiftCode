def get_protocol(file):
    fp = open(file, 'r')
    fp.readline()
    fp.readline()
    fp.readline()
    proto_string = fp.readline()
    protocol = None
    if "p40" in proto_string:
        protocol = "protocol40a"
    elif "p41" in proto_string:
        protocol = "protocol41"
    elif "p42" in proto_string:
        protocol = "protocol42"
    elif "p43" in proto_string:
        protocol = "protocol43"
    elif "p44" in proto_string:
        protocol = "protocol44"
    elif "p45" in proto_string:
        protocol = "protocol45"
    elif "p46" in proto_string:
        protocol = "protocol46"
    elif "p47" in proto_string:
        protocol = "protocol47"
    else:
        return file
    return protocol

proto = get_protocol(file)

def get_testdate(logfn):
    date = logfn[-10:]
    for i in range(len(date)):
        if date[i] == "-":
            date[i] = "/"
    return date
    

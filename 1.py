# jsonenv reads a json object as input and produces
# escaped shell commands for setting environment vars

import json
import pipes
import sys
import logging

logging.basicConfig(format='%(message)s')
str = sys.stdin.read().replace('\\n', '')
config = {}
try:
    for k, v in json.loads(str).items():
        try:
            k = pipes.quote(k)
            v = pipes.quote(v)
            config[k] = v
            print "%s=%s ;  export %s;" % (k, v, k)
        except:
            continue
    run_conf = config['extra_conf'].format(**config)
    print "%s=%s ; export %s" % ("run_conf", run_conf, "run_conf")
except:
    logging.error('bad/missing edge config json')

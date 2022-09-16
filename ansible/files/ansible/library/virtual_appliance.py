#!/usr/bin/env python

import subprocess
from ansible.module_utils.basic import *
#from ansible.inventory.host import *

def _agent(module):

    try:
        with open('/etc/agent-id', 'r') as f:
            data = f.read().strip()
        results = []
        results.append(data)
        return { 'ansible_facts': { 'virtual-appliance-id': results } }
    except:
        return { 'ansible_facts': { 'virtual-appliance-id': [''] } }

def main():
  module = AnsibleModule(
      argument_spec = dict(
    ),
    supports_check_mode = True,
  )
  data = _agent(module)
  module.exit_json(**data)


main()
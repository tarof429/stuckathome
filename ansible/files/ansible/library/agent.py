#!/usr/bin/env python

import subprocess
from ansible.module_utils.basic import *

def _agent(module):
    
    try:
        return ansible_facts['agent-id']
    except NameError: 
        try:
            with open('/etc/agent-id', 'r') as f:
                data = f.read().strip()
        except:
            data = ''
        
        results = []

        results.append(data)

        return { 'ansible_facts': { 'agent-id': results } }

def main():
  module = AnsibleModule(
      argument_spec = dict(
    ),
    supports_check_mode = True,
  )
  data = _agent(module)
  module.exit_json(**data)


main()
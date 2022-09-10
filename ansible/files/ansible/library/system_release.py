#!/usr/bin/env python

import subprocess
from ansible.module_utils.basic import *

def _system_release(module):
    
    # Try to read the contents of /etc/system-release
    # If it doesn't exist, set data to an empty string
    try:
      with open('/etc/system-release', 'r') as f:
        data = f.read().strip()
    except:
        data = ''
    
    results = []

    results.append(data)

    return { 'ansible_facts': { 'system-release': results } }

def main():
  module = AnsibleModule(
      argument_spec = dict(
    ),
    supports_check_mode = True,
  )
  data = _system_release(module)
  module.exit_json(**data)


main()
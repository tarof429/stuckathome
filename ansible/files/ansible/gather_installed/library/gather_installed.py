#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Note: only works on RedHat family
# This library should be saved to the 'library/' folder relative to your playbooks/inventory

import rpm

def _check_installed(module):
  ts = rpm.TransactionSet()
  mi = ts.dbMatch()

  results = []
  for h in mi:
    results.append(h['name'])

  return { 'ansible_facts': { 'packages_installed': results } }

def main():
  module = AnsibleModule(
      argument_spec = dict(
    ),
    supports_check_mode = True,
  )
  data = _check_installed(module)
  module.exit_json(**data)

from ansible.module_utils.basic import *
main()

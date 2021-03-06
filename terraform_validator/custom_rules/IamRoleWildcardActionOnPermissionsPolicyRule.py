from __future__ import absolute_import, division, print_function
import inspect
import sys
import json
from builtins import (str)
from terraform_validator.custom_rules.BaseRule import BaseRule

def lineno():
    """Returns the current line number in our program."""
    return str(' - IamRoleWildcardActionOnPermissionsPolicyRule- caller: '+str(inspect.stack()[1][3])+'  - line number: '+str(inspect.currentframe().f_back.f_lineno))


class IamRoleWildcardActionOnPermissionsPolicyRule(BaseRule):
  
  def __init__(self, cfn_model=None, debug=None):
    """
    Initialize
    :param cfn_model: 
    """
    BaseRule.__init__(self, cfn_model=cfn_model,debug=debug)
      
  def rule_text(self):
    """
    Get rule text
    :return: 
    """
    if self.debug:
      print('rule_text'+lineno())
    return 'IAM role should not allow * action on its permissions policy'


  def rule_type(self):
    """
    Get rule type
    :return: 
    """
    self.type= 'VIOLATION::FAILING_VIOLATION'
    return 'VIOLATION::FAILING_VIOLATION'


  def rule_id(self):
    """
    Get rule id
    :return: 
    """
    if self.debug:
      print('rule_id'+lineno())
    self.id ='F3'
    return 'F3'


  def audit_impl(self):
    """
    Audit
    :return: violations 
    """
    if self.debug:
      print("\n\n###############################################")
      print('IamRoleWildcardActionOnPermissionsPolicyRule - audit_impl'+lineno())
      print("###################################################\n")

    violating_roles = []


    resources = self.cfn_model.resources_by_type('AWS::IAM::Role')

    if len(resources)>0:

      if self.debug:
        print('there is a resource'+lineno())

      for resource in resources:
          if self.debug:
            print('resource: '+str(resources)+lineno())
            print('vars: '+str(vars(resource))+lineno())

          if hasattr(resource, 'policy_objects') and resource.policy_objects:
            if self.debug:
              print('has policy obects ' + lineno())

            for policy in resource.policy_objects:

              if self.debug:
                print('policy: '+str(policy.policy_objects)+lineno())

              if policy.policy_document.wildcard_allowed_actions():
                if self.debug:
                  print('has wildcard allowed actions')

                violating_roles.append(str(resource.logical_resource_id))
          elif hasattr(resource, 'policy') and resource.policy:
            if self.debug:
              print('has policy obects ' + lineno())
              print('policy: '+str(resource.policy)+lineno())
              print('type: '+str(type(resource.policy))+lineno())

            if type(resource.policy) == type(str()):
              json_acceptable_string = resource.policy.replace("'", "\"")
              resource.policy = json.loads(json_acceptable_string)

            for policy in resource.policy:

              if self.debug:
                print('policy: '+str(policy)+lineno())

              if policy.policy.wildcard_allowed_actions():
                if self.debug:
                  print('has wildcard allowed actions')

                violating_roles.append(str(resource.logical_resource_id))
          elif hasattr(resource, 'assume_role_policy_document') and resource.assume_role_policy_document:
            if self.debug:
              print('has policy obects ' + lineno())

              if resource.assume_role_policy_document.wildcard_allowed_actions():
                if self.debug:
                  print('has wildcard allowed actions')

                violating_roles.append(str(resource.logical_resource_id))

    else:
      if self.debug:
        print('no violating_roles' + lineno())


    return violating_roles
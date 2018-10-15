from __future__ import absolute_import, division, print_function
import copy
import sys
import inspect
from builtins import (str)
from terraform_validator.custom_rules.BaseRule import BaseRule


def lineno():
    """Returns the current line number in our program."""
    return str(' - SecurityGroupIngressPortRangeRule - caller: '+str(inspect.stack()[1][3])+' - line number: '+str(inspect.currentframe().f_back.f_lineno))



class SecurityGroupIngressPortRangeRule(BaseRule):

    def __init__(self, cfn_model=None, debug=None):
        """
        Initialize
        :param cfn_model:
        """
        BaseRule.__init__(self, cfn_model, debug=debug)

    def rule_text(self):
        """
        Get rule text
        :return:
        """
        if self.debug:
            print('rule_text'+lineno())
        return 'Security Groups found ingress with port range instead of just a single port'


    def rule_type(self):
        """
        Get rule type
        :return:
        """
        self.type= 'VIOLATION::WARNING'
        return 'VIOLATION::WARNING'


    def rule_id(self):
        """
        Get rule id
        :return:
        """
        if self.debug:
            print('rule_id'+lineno())
        self.id ='W27'
        return 'W27'



    def audit_impl(self):
        """
        Audit
        :return: violations
        """
        if self.debug:
            print('SecurityGroupIngressPortRangeRule - audit_impl'+lineno())

        violating_ingresses = []

        for groups in self.cfn_model.security_groups():

            if self.debug:
                print("\n#######################################")
                print('group: '+str(groups)+lineno())
                print('vars: '+str(vars(groups))+lineno())
                if groups.ingresses:
                    print('ingresses: '+str(groups.ingresses)+lineno())
                    for ingres in groups.ingresses:
                        print('vars: '+str(vars(ingres))+lineno())
                print("#########################################\n")


            for ingress in groups.ingresses:
                if ingress.from_port and ingress.to_port:
                    if self.debug:
                        print('has from port and to port'+lineno())

                if str(ingress.from_port) != str(ingress.to_port):
                    violating_ingresses.append(ingress.logical_resource_id)


        if self.debug:
            print('violations: '+str(list(set(violating_ingresses))))


        return violating_ingresses
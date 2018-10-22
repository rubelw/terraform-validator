from __future__ import absolute_import, division, print_function
import inspect
import sys
from terraform_model.model.IAMPolicy import IAMPolicy
from terraform_model.model.PolicyDocument import PolicyDocument
from terraform_model.parser.PolicyDocumentParser import PolicyDocumentParser


def lineno():
    """Returns the current line number in our program."""
    return str(' -  WithPolicyDocumentParser- line number: '+str(inspect.currentframe().f_back.f_lineno))

class WithPolicyDocumentParser:
    """
    With policy document parser
    """
    @staticmethod
    def parse(cfn_model, resource, debug=False):
        """
        Parse with policy document parser
        :param resource:
        :param debug:
        :return:
        """
        if debug:
            print("\n######################################")
            print('parse'+lineno())
            print('resource: '+str(resource)+lineno())
            print('vars: '+str(vars(resource))+lineno())
            print("######################################\n")


        if hasattr(resource,'policy') and resource.policy:
            parser = PolicyDocumentParser(debug)
            resource.policy_document = parser.parse(cfn_model, resource.policy)

        return resource

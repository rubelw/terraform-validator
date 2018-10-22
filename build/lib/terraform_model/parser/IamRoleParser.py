from __future__ import absolute_import, division, print_function
import sys
import inspect
from terraform_model.parser.PolicyDocumentParser import PolicyDocumentParser
from terraform_model.model.Policy import Policy


def lineno():
    """Returns the current line number in our program."""
    return str(' -  IamRoleParser- line number: '+str(inspect.currentframe().f_back.f_lineno))

class IamRoleParser:
    """
    IAM Role Parser
    """
    
    @staticmethod
    def parse(cfn_model, resource, debug=False):
        """
        Parse iam role
        :param resource: 
        :param debug: 
        :return: 
        """
        if debug:
            print('IAMRoleParser - parse'+lineno())
            print('resource: '+str(resource)+lineno())
            print('debug is: '+str(debug)+lineno())
            print('cfn_model: '+str(cfn_model)+lineno())
            print('policies: '+str(resource.policies)+lineno())
            print('managed policy arn: '+str(resource.managedPolicyArns)+lineno())
            print('policy objects: '+str(resource.policy_objects)+lineno())
            print('assume role policy document: '+str(resource.assume_role_policy_document)+lineno())
            print('raw model: '+str(resource.raw_model)+lineno())

        iam_role = resource

        document_parser =  PolicyDocumentParser(debug=debug)


        if debug:
            print('iam_role: '+str(iam_role)+lineno())
            print('vars: '+str(vars(iam_role)))

        if iam_role.assume_role_policy:
            iam_role.assume_role_policy_document  =document_parser.parse(cfn_model, iam_role.assume_role_policy)


        if debug:
            print('Done parsing assume role policy with policy document parser '+lineno())

        for policy in iam_role.policies:
            if debug:
                print('policy: '+str(policy)+lineno())

            if 'PolicyName' in policy:
                if debug:
                    print('has policy name: '+str(policy['PolicyName']))

                new_policy = Policy(debug=debug)
                new_policy.policy_name = policy['PolicyName']
                new_policy.policy_document = document_parser.parse(policy['PolicyDocument'])
                iam_role.policy_objects.append(new_policy)


        return iam_role
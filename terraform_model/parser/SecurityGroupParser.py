from __future__ import absolute_import, division, print_function
import copy
import sys
import inspect
import re
import sys
import json
from terraform_model.model.EC2SecurityGroupIngress import EC2SecurityGroupIngress
from terraform_model.model.EC2SecurityGroupEgress import EC2SecurityGroupEgress
from terraform_model.model.References import References
from builtins import (str)


def lineno():
    """Returns the current line number in our program."""
    return str(' -  SecurityGroupParser- line number: '+str(inspect.currentframe().f_back.f_lineno))

class SecurityGroupParser:
    """
    Security group parser
    """
    
    @staticmethod
    def parse(cfn_model, resource, debug=False):
        """
        Parse security group
        :param resource:
        :param debug:
        :return:
        """
        if debug:
            print('parse'+lineno())

        security_group = copy.copy(resource)

        if debug:
            print("\n############################")
            print('Trying to objectify egress')
            print("###############################\n")
        security_group = SecurityGroupParser.objectify_egress(cfn_model, security_group, debug=debug)

        if debug:
            print("\n############################")
            print('Trying to objectify ingress')
            print("###############################\n")
        security_group = SecurityGroupParser.objectify_ingress(cfn_model, security_group, debug=debug)


        if debug:
            print("\n###############################")
            print('objectified egress and ingress'+lineno())
            print('staring to wire ingress rules to security group'+lineno())
            print("#################################\n")

        security_group = SecurityGroupParser.wire_ingress_rules_to_security_group(cfn_model, security_group, debug=debug)
        security_group = SecurityGroupParser.wire_egress_rules_to_security_group(cfn_model, security_group, debug=debug)


        return security_group

    @staticmethod
    def objectify_ingress(cfn_model, security_group, debug=False):
        """
        Objectivy ingress statment
        :param security_group:
        :param debug:
        :return:
        """
        if debug:
            print("\n\n#########################")
            print('objectify_ingress'+lineno())

        if security_group:
            if debug:
                print('there is a security group'+lineno())
                print('security group: '+str(security_group)+lineno())
                print('type: '+str(type(security_group))+lineno())
                print('vars: '+str(vars(security_group))+lineno())
                print('security group raw model: '+str(security_group.raw_model)+lineno())
                print('###########################\n\n')


            # If there is a ingress in properties
            if hasattr(security_group,'ingress') and security_group.ingress:

                if debug:
                    print('has securitygroupingress property'+lineno())
                    print('type: '+str(type(security_group.ingress))+lineno())


                if type(security_group.ingress) == type(str()):
                    json_acceptable_string = security_group.ingress.replace("'", "\"")
                    security_group.ingress= json.loads(json_acceptable_string)


                if debug:
                    print('security group ingress is now: '+str(security_group.ingress)+lineno())

                # if the ingress is a list
                if type(security_group.ingress) == type(list()):
                    if debug:
                        print('is a list'+lineno())

                    if debug:
                        print('Iterating over each list in array'+lineno())
                    # Iterate over each sg in array
                    for sg in security_group.ingress:
                        if debug:
                            print(str(sg)+lineno())

                        ingress_object = EC2SecurityGroupIngress(cfn_model,debug=debug)
                        ingress_object.logical_resource_id = security_group.logical_resource_id

                        for key in sg:
                            if debug:
                                print('key: '+str(key)+lineno())
                                print('value: '+str(sg[key])+lineno())

                            if '::' in key:
                                if debug:
                                    print(':: in key'+lineno())
                                continue
                            else:
                                if debug:
                                    print(':: not in key '+lineno())
                                new_key_name = SecurityGroupParser.initialLower(key)

                                if debug:
                                    print('new key name: '+str(new_key_name)+lineno())
                                setattr(ingress_object,SecurityGroupParser.initialLower(key),sg[key])

                        if debug:
                            print(str(vars(ingress_object))+lineno())

                        security_group.ingresses.append(ingress_object)

                    if debug:
                        print('Done iterating of list - returning security group to caller '+lineno())

                    return security_group

                # If the ingress routes is a dictionary
                elif type(security_group.ingress) == type(dict()):

                    # example: security_group.ingress
                    # example: {'from_port': 0, 'to_port': 65535, 'protocol': 'TCP', 'cidr_blocks': ['${var.cidr_blocks}']}

                    if debug:
                        print('is a dict'+lineno())
                        print(str(security_group.ingress)+lineno())


                    ingress_object = EC2SecurityGroupIngress(cfn_model)
                    ingress_object.logical_resource_id = security_group.logical_resource_id

                    # Iterate over each key-value pair in dictionary and associate
                    # to an object attribute
                    for key in security_group.ingress:
                        if debug:
                            print('key: ' + str(key) + lineno())
                            print('value: ' + str(security_group.ingress[key]) + lineno())

                        setattr(ingress_object, SecurityGroupParser.initialLower(key), security_group.ingress[key])

                    security_group.ingresses.append(ingress_object)
                    return security_group

                # if the ingress is a list
                else:
                    print('security group ingress is not a list or dict')
                    print(str('type: ')+str(type(security_group.ingress)+lineno()))
                    sys.exit(1)

            else:
                if debug:
                    print('there is no security group ingress '+lineno())

        return security_group

    @staticmethod
    def objectify_egress(cfn_model, security_group, debug=False):
        """
        Trying to convert a security group egress in to an egress object
        :param security_group:
        :param debug:
        :return:
        """
        if debug:
            print("\n\n###############")
            print('objectify_egress'+lineno())
            print('security group type: '+str(type(security_group))+lineno())
            print(str(vars(security_group))+lineno())
            print('##################\n\n')

        if security_group:
            if debug:
                print("\n\n#######################################")
                print('Details regarding security group')
                print('there is a security group'+lineno())
                print('security group: '+str(security_group)+lineno())
                print('vars: '+str(vars(security_group))+lineno())
                print('model: '+str(security_group.cfn_model)+lineno())
                print("###########################################\n")
                input('Press Enter to continue: '+lineno())


            if debug:
                print(str(security_group.logical_resource_id)+lineno())
                if hasattr(security_group,'egress'):
                    print(str(security_group.egress)+lineno())
                    if security_group.egress:
                        print(str(security_group.egress)+lineno())


            # If there is a egress property
            if hasattr(security_group,'egress') and security_group.egress:

                if type(security_group.egress) == type(str()):
                    json_acceptable_string = security_group.egress.replace("'", "\"")
                    security_group.egress= json.loads(json_acceptable_string)

                if debug:
                    print('has securitygroupegress property'+lineno())
                    print('type: '+str(type(security_group.egress))+lineno())

                # If the egress is an array
                if type(security_group.egress) == type(list()):
                    if debug:
                        print('is a list'+lineno())

                    for sg in security_group.egress:
                        if debug:
                            print(str(sg)+lineno())

                        egress_object = EC2SecurityGroupEgress(cfn_model,debug=debug)
                        egress_object.logical_resource_id = security_group.logical_resource_id

                        for key in sg:
                            if debug:
                                print('key: '+str(key)+lineno())
                                print('value: '+str(sg[key])+lineno())

                            if '::' in key:
                                continue

                            else:
                                if debug:
                                    print(':: not in key '+lineno())
                                new_key_name = SecurityGroupParser.initialLower(key)

                                if debug:
                                    print('new key name: '+str(new_key_name)+lineno())

                                setattr(egress_object,SecurityGroupParser.initialLower(key),sg[key])

                        if debug:
                            print(str(vars(egress_object))+lineno())

                    security_group.egresses.append(egress_object)

                    return security_group

                # If the egress is a dictionary
                elif type(security_group.egress) == type(dict()):

                    if debug:
                        print('is a dict'+lineno())
                        print(str(security_group.egress)+lineno())
                    # {'CidrIp': '10.1.2.3/32', 'FromPort': 34, 'ToPort': 36, 'IpProtocol': 'tcp'}

                    egress_object = EC2SecurityGroupEgress(cfn_model)
                    egress_object.logical_resource_id = security_group.logical_resource_id

                    # Iterate over each key-value pair in the dictionary and create
                    # an object attribute
                    for key in security_group.egress:
                        if debug:
                            print('key: ' + str(key) + lineno())
                            print('value: ' + str(security_group.egress[key]) + lineno())

                        matchObj = re.match(r'::', key, re.M | re.I)

                        if matchObj:
                            if debug:
                                print("matchObj.group() : ", matchObj.group() + lineno())
                            continue
                        else:
                            if debug:
                                print("No match!!" + lineno())

                            setattr(egress_object, SecurityGroupParser.initialLower(key), security_group.egress[key])

                    if debug:
                        print(str(vars(egress_object)) + lineno())

                    security_group.egresses.append(egress_object)
                    return security_group

                else:
                    print("\n#############################")
                    print('Security group is not egress')
                    print("################################\n")

            else:
                if debug:
                    print('does not have egress attribute: '+lineno())
        else:
            if debug:
                print('no security group'+lineno())

        return security_group

    @staticmethod
    def initialLower(key_name):
        """
        First character to lower case
        :return:
        """
        first_character = str(key_name)[:1]
        remaining_characters = str(key_name)[1:]
        new_property_name = str(first_character.lower()) + str(remaining_characters)

        return new_property_name

    @staticmethod
    def wire_ingress_rules_to_security_group(cfn_model, security_group, debug=False):
        """
        Wires a standalone ingress rule to a security group
        :param security_group:
        :param debug:
        :return:
        """
        if debug:
            print("\n\n###############")
            print('wire_ingress_rules_to_security_group'+lineno())
            print('##################\n\n')

            print('sg: '+str(security_group)+lineno())
            print('cfn_model: '+str(cfn_model)+lineno())
            print('vars: '+str(vars(cfn_model))+lineno())

        if not security_group:

            if debug:
                print('there is not a security group returning'+lineno())

            return security_group

        # Get all the EC2::SecurityGroupIngress resources
        ingress_rules = cfn_model.resources_by_type('AWS::EC2::SecurityGroupIngress')

        # Iterate over each of the ingress resources
        for security_group_ingress in ingress_rules:

            if debug:
                print("\n\n###########################################################")
                print('Standalone ingress resource')
                print('security_group_ingress: '+str(security_group_ingress)+lineno())
                print('vars: '+str(vars(security_group_ingress))+lineno())
                print('dirs: '+str(dir(security_group_ingress))+lineno())
                if hasattr(security_group_ingress,'ingress') and security_group.ingress:
                    print('ingress: '+str(security_groupingress.ingress)+lineno())
                print("##############################################################\n")

            if hasattr(security_group_ingress,'type'):
                if debug:
                    print('type is: '+str(security_group_ingress.type)+lineno())

                if security_group_ingress.type == 'ingress':
                    if debug:
                        print('security group ingress cfn model has properties'+lineno())
                    if security_group_ingress.logical_resource_id:
                        if debug:
                            print('security group ingress has groupid '+str(security_group_ingress.logical_resource_id)+lineno())

                        group_id = References.resolve_security_group_id(security_group_ingress.logical_resource_id,debug=debug)
                        if debug:
                            print('group id: '+str(group_id)+lineno())
                            print('security group logical resource id: '+str(security_group_ingress.logical_resource_id)+lineno())

                        # standalone ingress rules are legal - referencing an external security group
                        if not group_id:
                            continue

                        # If the group id in the standalone ingress matches the logical resource id
                        # of the actual security group
                        #FIXME
                        if hasattr(security_group_ingress,'ingress') and security_group_ingress.ingress:
                            security_group.ingresses.append(security_group_ingress)


                    else:
                        print('Security group ingress has no groupid')
                        sys.exit(1)
            else:
                if debug:
                    print('does not have type'+lineno())

        if debug:
            print('done wiring_ingress_rules_to_security_group '+lineno())

        return security_group

    @staticmethod
    def wire_egress_rules_to_security_group(cfn_model, security_group, debug=False):
        """
        Wire egress rule to a security group
        :param security_group:
        :param debug:
        :return:
        """
        if debug:
            print("\n\n###############")
            print('wire_egress_rules_to_security_group'+lineno())
            print('##################\n\n')
            print('sg: '+str(security_group)+lineno())
            print('cfn_model: '+str(cfn_model)+lineno())
            print('vars: '+str(vars(cfn_model))+lineno())

        if not security_group:
            return security_group
        else:
            if debug:
                print("\n#############################")
                print('There is a security group')
                print("###############################\n")

        #egress_rules = cfn_model.resources_by_type('AWS::EC2::SecurityGroupEgress')
        egress_rules = cfn_model.resources_by_type('AWS::EC2::SecurityGroupEgress')

        if debug:
            print('egress rules: '+str(egress_rules)+lineno())

        # Iterate over each of the egress resources
        for security_group_egress in egress_rules:

            if debug:
                print("\n\n###########################################################")
                print('Standalone egress resource')
                print('vars: ' + str(vars(security_group_egress)) + lineno())

                if hasattr(security_group_egress,'egress'):
                    print('security_group_egress: '+str(security_group_egress)+lineno())
                    print('vars: '+str(vars(security_group_egress))+lineno())
                    print('dirs: '+str(dir(security_group_egress))+lineno())

                    if hasattr(security_group_egress,'egress') and security_group.egress:
                        print('egress: '+str(security_group.egress)+lineno())
                print("##############################################################\n")

            if hasattr(security_group_egress,'type'):
                if debug:
                    print('type is: '+str(security_group_egress.type)+lineno())

                if security_group_egress.type == 'egress':

                    if security_group_egress.logical_resource_id:
                        print('security group ingress has groupid '+str(security_group_egress.logical_resource_id)+lineno())

                        group_id = References.resolve_security_group_id(security_group_egress.logical_resource_id,debug=debug)
                        if debug:
                            print('group id: '+str(group_id)+lineno())
                            print('security group logical resource id: '+str(security_group_egress.logical_resource_id)+lineno())

                        # standalone egress rules are legal - referencing an external security group
                        if not group_id:
                            continue

                        # If the group id in the standalone egress matches the logical resource id
                        # of the actual security group
                        if hasattr(security_group_egress,'egress') and security_group_egress.egress:
                            security_group.egresses.append(security_group_egress)

                    else:
                        print('Security group ingress has no groupid')
                        sys.exit(1)
            else:
                if debug:
                    print('does not have type'+lineno())

        return security_group
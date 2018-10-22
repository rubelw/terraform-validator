from __future__ import absolute_import, division, print_function
import inspect
import sys
import copy
import json

def lineno():
    """Returns the current line number in our program."""
    return str(' -  Ec2NetworkInterfaceParser- line number: '+str(inspect.currentframe().f_back.f_lineno))


class Ec2NetworkInterfaceParser:
    """
    Ec2 network interface parser
    """
    @staticmethod
    def parse(cfn_model, resource, debug=False):
        print('Ec2NetworkInterfaceParser - parse'+lineno())
        # FIXME

        network_interface = copy.copy(resource)

        if debug:
            print('vars: '+str(vars(network_interface))+lineno())

        if hasattr(network_interface,'security_groups'):

            if debug:
                print('there is a security_group '+lineno())
                print('type: '+str(type(network_interface.security_groups))+lineno())
                print('group: '+str(network_interface.security_groups)+lineno())

            if type(network_interface.security_groups) == type(str()):
                json_acceptable_string = str(network_interface.security_groups).replace("'", "\"")
                network_interface.security_groups = json.loads(json_acceptable_string)


            if type(network_interface.security_groups) == type(list()):

                for gs in network_interface.security_groups:

                    if debug:
                        print('group set: '+str(gs)+lineno())
                        print('type: '+str(type(gs))+lineno())
        else:
            setattr(network_interface,'security_groups',[])

        return network_interface

    #network_interface = resource

    #if network_interface.groupSet.is_a? Array
    #  network_interface.security_groups = network_interface.groupSet.map do |security_group_reference|
    #    cfn_model.find_security_group_by_group_id(security_group_reference)
    #  end
    #else
    #  network_interface.security_groups = []
    #end

    #network_interface
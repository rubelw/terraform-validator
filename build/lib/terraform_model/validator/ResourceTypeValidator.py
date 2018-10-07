from __future__ import absolute_import, division, print_function
import inspect
import json
from terraform_model.parser import ParserError

def lineno():
    """Returns the current line number in our program."""
    return str(' -  ResourceTypeValidator- line number: '+str(inspect.currentframe().f_back.f_lineno))


class ResourceTypeValidator:
    """
    Resource Type Validator
    """

    def __init__(self, debug=False):
        """
        Initialize
        :param debug:
        """
        self.debug=debug
        if self.debug:
            print('ResourceTypeValidator - init'+lineno())

    def validate(self, cloudformation_yml):
        """
        validate cloud formation
        :param cloudformation_yml:
        :return:
        """

        if self.debug:
            print("\n\n########################################")
            print('ResourceTypeValidator - validate'+lineno())
            print('Iterating through each of the resources and validating them')
            print('cloudformation template: '+str(cloudformation_yml))
            print("############################################\n\n")

        if type(cloudformation_yml) == type(str()):
            json_acceptable_string = cloudformation_yml.replace("'", "\"")
            cloudformation_yml= json.loads(json_acceptable_string)


        if 'resource' not in cloudformation_yml:
            raise ParserError.ParserError('Illegal cfn - no resources')
        else:
            if self.debug:
                print('cloudformation has resource'+str(cloudformation_yml['resource'])+lineno())
                print('type:'+str(type(cloudformation_yml['resource'])))


        # Don't need a type because the resource is the type
        #for resource in cloudformation_yml['resource']:

        #    if self.debug:
        #        print('resource: '+str(resource))

        #    if 'type' not in cloudformation_yml[resource]:
        #        raise ParserError.ParserError('Illegal cfn - missing type: id: '+str(resource))
        #    else:
        #        if self.debug:
        #            print('resource: '+str(resource)+' has type'+lineno())

        if  'variable' in cloudformation_yml:

            if self.debug:
                print('there is a variable in template: '+lineno())

        if self.debug:
            print('returning '+str(cloudformation_yml)+lineno())

        return cloudformation_yml
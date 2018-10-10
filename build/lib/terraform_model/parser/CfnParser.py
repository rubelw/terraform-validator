from __future__ import absolute_import, division, print_function
import sys
import inspect
import json
import traceback
from dill.source import getname
from terraform_model.validator import CloudformationValidator
from terraform_model.parser import TransformRegistry
from terraform_model.validator import ReferenceValidator
from terraform_model.model import CfnModel
from terraform_model.model import IAMManagedPolicy
from terraform_model.model import IAMRole
from terraform_model.model import IAMUser
from terraform_model.model import IAMGroup
from terraform_model.model import IAMPolicy
from terraform_model.model import EC2Instance
from terraform_model.model import EC2SecurityGroup
from terraform_model.model import EC2SecurityGroupEgress
from terraform_model.model import EC2SecurityGroupIngress
from terraform_model.model import ElasticLoadBalancingLoadBalancer
from terraform_model.model import ElasticLoadBalancingV2LoadBalancer
from terraform_model.model import S3BucketPolicy
from terraform_model.model import SNSTopicPolicy
from terraform_model.model import SQSQueuePolicy
from terraform_model.model import ModelElement
from terraform_model.model.Parameter import Parameter
from terraform_model.model.Data import Data
from terraform_model.model.Locals import Locals
from terraform_model.model.Output import Output
from terraform_model.model.Provider import Provider
from terraform_model.parser.ParserRegistry import ParserRegistry
from terraform_model.parser.SecurityGroupParser import SecurityGroupParser
from terraform_model.parser.Ec2NetworkInterfaceParser import Ec2NetworkInterfaceParser
from terraform_model.parser.Ec2InstanceParser import Ec2InstanceParser
from terraform_model.parser.LoadBalancerParser import LoadBalancerParser
from terraform_model.parser.LoadBalancerV2Parser import LoadBalancerV2Parser
from terraform_model.parser.IamGroupParser import IamGroupParser
from terraform_model.parser.IamUserParser import IamUserParser
from terraform_model.parser.IamRoleParser import IamRoleParser
from terraform_model.parser.WithPolicyDocumentParser import WithPolicyDocumentParser
from terraform_model.model.Policy import Policy
from terraform_model.model.PolicyDocument import PolicyDocument
from terraform_model.parser.PolicyDocumentParser import PolicyDocumentParser
from terraform_model.parser.ParserError import ParserError


def lineno():
    """Returns the current line number in our program."""
    return str(' - CfnParser - line number: '+str(inspect.currentframe().f_back.f_lineno))


class CfnParser:
    """
    Cloudformation parser
    """
    def __init__(self, debug=False):
        """
        Initialize
        :param debug: 
        """
        self.debug = debug

        if self.debug:
            print('CfnParser - init'+lineno())


    # Given raw json/tf CloudFormation template, returns a CfnModel object
    # or raise ParserErrors if something is amiss with the format
    def parse(self,cloudformation_yml, parameter_values_json=None):

        if self.debug:
            print("\n\n#######################################################")
            print('CfnParser - parse'+lineno())
            print('Beginning to parse cloudformation template')
            print('cloudformation type: '+str(type(cloudformation_yml)))
            print("##########################################################\n\n")
        try:
            self.pre_validate_model(cloudformation_yml)

            if self.debug:
                print('successful pre_validate_model: '+lineno())

        except ParserError as e:
            tb = sys.exc_info()[-1]
            if self.debug:
                print('tb: ' + str(tb) + lineno())
            stk = traceback.extract_tb(tb, 1)
            if self.debug:
                print('stk: ' + str(stk) + lineno())
            fname = stk[0][2]
            if self.debug:
                print('The failing function was', fname,lineno())
            raise

        if self.debug:
            print("\n\n#########################################")
            print('cloudformation template pre_validated'+lineno())
            print('Prevalidating cloudformation template')
            print("#############################################\n\n")


        # Transform raw resources in template as performed by
        # transforms
        #transformer = TransformRegistry.TransformRegistry(debug=self.debug)
        #cloudformation_yml = transformer.perform_transforms(cloudformation_yml)

        #if self.debug:
        #    print("\n\n#################################################")
        #    print('Done prevalidating cloudformation template')
        #    print('cloudformation_yml type: '+str(type(cloudformation_yml))+lineno())
        #    print('Begin to validate referenses'+lineno())
        #    print("#####################################################\n\n")


        # Not validating references, because I believe terraform will do this internally
        #self.validate_references(cloudformation_yml)


        if self.debug:
            print("\n\n##########################################")
            print('Begin transform_hash_into_model elements'+lineno())
            print('Creating the cfn_model objects')
            print("#############################################\n")

        cfn_model = CfnModel.CfnModel(debug=self.debug)
        cfn_model.raw_model=cloudformation_yml


        # pass 1: wire properties into ModelElement objects
        cfn_model = self.transform_hash_into_model_elements(cloudformation_yml, cfn_model)

        if self.debug:
            print("\n\n#################################################")
            print("Iterate through each resource in the model"+lineno())
            print("######################################################\n")

            for r in cfn_model.resources:
                print("############### RESOURCE INFO ###################")
                print(r)
                print('resource_type: '+str(cfn_model.resources[r].resource_type)+lineno())
                print('logical_resource_id: '+str(cfn_model.resources[r].logical_resource_id)+lineno())
                print('metadata: '+str(cfn_model.resources[r].metadata)+lineno())
                print('vars: '+str(vars(cfn_model.resources[r]))+lineno())
                print('raw model: '+str(cfn_model.resources[r].raw_model.raw_model)+lineno())
                print("##################################################\n")

            print("\n##################################################")
            print('properties wired into model element objects'+lineno())
            print("##################################################\n")


        if self.debug:
            print("\n##################################################")
            print('Transforming hash into parameters'+lineno())
            print("##################################################\n")

        # Transform cloudformation parameters into parameters object
        cfn_model = self.transform_hash_into_parameters(cloudformation_yml,cfn_model)

        if self.debug:
            print("\n##################################################")
            print('Done transforming hash into parameters' + lineno())
            print('parameters: '+str(cfn_model.parameters)+lineno())
            print('resources: '+str(cfn_model.resources)+lineno())
            print('providers: '+str(cfn_model.providers)+lineno())
            print('locals: '+str(cfn_model.locals)+lineno())
            print('outputs: '+str(cfn_model.outputs)+lineno())
            print('data: '+str(cfn_model.data)+lineno())
            print('raw model: '+str(cfn_model.raw_model)+lineno())
            print('Beginning post process resource model elements' + lineno())
            print("##################################################\n")

        # pass 2: tie together separate resources only where necessary to make life easier for rule logic
        cfn_model = self.post_process_resource_model_elements(cfn_model)

        if self.debug:
            print("\n##################################################")
            print('Done Post processing resource model elements' + lineno())
            print('Beginning to apply parameter values to model' + lineno())
            print("##################################################\n")

        cfn_model = self.apply_parameter_values(cfn_model, parameter_values_json)

        if self.debug:
            print("\n##################################################")
            print('Done applying parameter values to model' + lineno())
            print("##################################################\n")


        return cfn_model


    def apply_parameter_values(self, cfn_model, parameter_values_json):
        """
        ???
        :param cfn_model: 
        :param parameter_values_json: 
        :return: 
        """
        if self.debug:
            print('CfnParser - apply_parameter_values'+lineno())
            print('parameter_values_json: '+str(parameter_values_json)+lineno())

            if parameter_values_json:
                print('parameter values json: '+str(parameter_values_json)+lineno())

        return cfn_model

    def post_process_resource_model_elements(self, cfn_model):
        """
        Post process the resource model elements
        :param cfn_model: 
        :return: 
        """
        if self.debug:
            print("\n\n#######################################################")
            print('CfnParser - post_process_resource_model_elements'+lineno())
            print('parameters: '+str(cfn_model.parameters)+lineno())
            print('resources: '+str(cfn_model.resources)+lineno())
            print('raw model: '+str(cfn_model.raw_model)+lineno())
            print("##########################################################\n\n")

        resource_parser_class = ParserRegistry(debug=self.debug)

        resource_map = {
            'aws_elb':'AWS::ElasticLoadBalancing::LoadBalancer',
            'aws_security_group':'AWS::EC2::SecurityGroup',
            'egress':'AWS::EC2::SecurityGroupEgress',
            'ingress':'AWS::EC2::SecurityGroupIngress',
            'aws_instance':'AWS::EC2::Instance',
            'aws_iam_role':'AWS::IAM::Role'
        }


        for r in cfn_model.resources:

            if cfn_model.resources[r].resource_type not in resource_map:
                print('fix cfnparser model map: '+lineno())
                sys.exit(1)

            if self.debug:
                print("\n\n#######################################")
                print("Processing cfn_model.resource: "+str(r)+lineno())
                print("########################################\n")

                print('resource type: '+str(type(cfn_model.resources[r].resource_type))+lineno())
                print('cfn_model type: '+str(cfn_model.resources[r].resource_type)+lineno())

                print('parser registry:'+str(resource_parser_class.registry)+lineno())

            # if there is a resource parser in the registry
            if resource_map[cfn_model.resources[r].resource_type] in resource_parser_class.registry:

                if self.debug:
                    print('found it the resource parser we were looking for '+lineno())
                    print('type: '+str(cfn_model.resources[r].resource_type)+lineno())
                    #print('class: '+str(resource_parser_class.registry[cfn_model.resources[r].resource_type])+lineno())

                    print("\n\n############################")
                    print('Parsing resource: '+str(r)+lineno())
                    print('type: '+str(resource_parser_class.registry[resource_map[cfn_model.resources[r].resource_type]])+lineno())
                    print("################################\n")

                resource_parser = resource_parser_class.registry[resource_map[cfn_model.resources[r].resource_type]]

                if self.debug:
                    print('sending resource to parser: '+str(cfn_model.resources[r])+lineno())


                resource_parser.parse(cfn_model, cfn_model.resources[r], debug=self.debug)

        if self.debug:
            print('done parsing the cfn model')

        return cfn_model


    def transform_hash_into_model_elements(self, cfn_hash, cfn_model):
        """
        We are iterating the the resources in the cloudformation template
        and trying to create objects out of each resource, and then putting
        the objects in to the model object
        :param cfn_hash: 
        :param cfn_model: 
        :return: 
        """
        if self.debug:
            print('CfnParser - transform_hash_into_model_elements'+lineno())
            print('hash: '+str(cfn_hash)+lineno())
            print('cfn_model: '+str(cfn_model)+lineno())

        if type(cfn_hash) == type(str()):
            json_acceptable_string = cfn_hash.replace("'", "\"")
            cfn_hash= json.loads(json_acceptable_string)

        # Iterate through each of the resources
        for resource_type in cfn_hash['resource']:

            if self.debug:
                print('resource_type: '+str(resource_type)+lineno())

            for resource_name in cfn_hash['resource'][resource_type]:

                if self.debug:
                    print('resource type: '+str(resource_type)+lineno())
                    print('resource name: '+str(resource_name)+lineno())
                    input('enter'+lineno())

                # Create a new resource class based on the name of the resource
                # Does this by getting the resource type, and creating object based on resource type
                resource_class = self.class_from_type_name(resource_type,resource_name)

                if self.debug:
                    print('resource class: '+str(resource_class)+lineno())
                    input('enter'+lineno())

                # This is the original model
                resource_class.raw_model= cfn_model

                if self.debug:
                    print('Setting logical resource id to: '+str(resource_name)+lineno())

                resource_class.logical_resource_id = resource_name

                resource_class.resource_type = resource_type
                if 'metadata' in cfn_hash['resource'][resource_type][resource_name]:
                    resource_class.metadata = cfn_hash['resource'][resource_type][resource_name]['metadata']

                if self.debug:
                    print("\n#############################################")
                    print("Assigning fields based upon properties"+lineno())
                    print("###############################################\n")

                resource_class = self.assign_fields_based_upon_properties(resource_class, cfn_hash['resource'][resource_type][resource_name])

                if self.debug:
                    print('There fields are no assigned to properties'+lineno())
                    input('enter: '+lineno())

                cfn_model.resources[resource_name]=resource_class

                if self.debug:
                    print("\n\n################################################")
                    print('The new resource object which is being added to cfn_model.resources has the following properties'+lineno())
                    print(type(resource_class))
                    print(vars(resource_class))
                    print(dir(resource_class))
                    print('resource_type: '+str(resource_class.resource_type)+lineno())
                    print('logical_resource_id: '+str(resource_class.logical_resource_id)+lineno())
                    print("##############################################################\n")


        return cfn_model

    def transform_hash_into_parameters(self, cfn_hash, cfn_model):
        """
        Transform hash into parameters
        :param cfn_hash: 
        :param cfn_model: 
        :return: 
        """

        if self.debug:
            print('CfnParser - transform_hash_into_parameters'+lineno())
            print('cfn_hash: '+str(cfn_hash)+lineno())
            print('type hash: '+str(type(cfn_hash))+lineno())
            print('cfn_model: '+str(cfn_model)+lineno())

        if type(cfn_hash) == type(str()):
            json_acceptable_string = cfn_hash.replace("'", "\"")
            cfn_hash= json.loads(json_acceptable_string)

        if 'variable' in cfn_hash and cfn_hash['variable']:

            if self.debug:
                print('variable in hash: '+str(cfn_hash['variable'])+lineno())

            for variable in cfn_hash['variable']:

                parameter = Parameter(debug=self.debug)
                parameter.id = variable

                if self.debug:
                    print('parameter id: ' + str(parameter.id) + lineno())

                if cfn_hash['variable'][variable]:

                    if self.debug:
                        print('variable is: '+str(cfn_hash['variable'][variable])+lineno())

                    for param in cfn_hash['variable'][variable]:

                        if self.debug:
                            print("\n###############################")
                            print('param: '+str(param)+lineno())
                            print('value: '+str(cfn_hash['variable'][variable][param])+lineno())
                            print("##################################\n")

                        if param == 'default':
                            parameter.type = str(type(cfn_hash['variable'][variable][param]))
                        else:
                            if self.debug:
                                print('no default parameter'+lineno())

                        if self.debug:
                            print('adding parameter: '+str(param)+'='+str(cfn_hash['variable'][variable][param])+lineno())

                        parameter.instance_variables.append(param+'='+str(cfn_hash['variable'][variable][param]))

                    cfn_model.parameters[param] = parameter


        if 'data' in cfn_hash and cfn_hash['data']:

            if self.debug:
                print('data in hash: '+str(cfn_hash['data'])+lineno())

            for cfdata in cfn_hash['data']:

                data = Data(debug=self.debug)
                data.id = cfdata

                if self.debug:
                    print('data is: '+str(cfdata)+lineno())
                    print('data id: ' + str(data.id) + lineno())

                if cfn_hash['data'][cfdata]:

                    if self.debug:
                        print('data is: '+str(cfn_hash['data'][cfdata])+lineno())

                    for param in cfn_hash['data'][cfdata]:

                        if self.debug:
                            print("\n###############################")
                            print('data: '+str(param)+lineno())
                            print('param: '+str(param)+lineno())
                            print('value: '+str(cfn_hash['data'][cfdata][param])+lineno())
                            print("##################################\n")

                        if param == 'default':
                            data.type = str(type(cfn_hash['data'][cfdata][param]))
                        else:
                            if self.debug:
                                print('no default data'+lineno())

                        if self.debug:
                            print('adding data: '+str(param)+'='+str(cfn_hash['data'][cfdata][param])+lineno())

                        data.instance_data.append(param+'='+str(cfn_hash['data'][cfdata][param]))

                    cfn_model.data[param] = cfdata



        if 'local' in cfn_hash and cfn_hash['local']:

            if self.debug:
                print('locals in hash: '+str(cfn_hash['local'])+lineno())

            for cflocal in cfn_hash['local']:

                locals = Locals(debug=self.debug)
                locals.id = cflocal

                if self.debug:
                    print('locals id: ' + str(locals.id) + lineno())

                if cfn_hash['local'][cflocal]:

                    if self.debug:
                        print('local is: '+str(cfn_hash['local'][cflocal])+lineno())

                    for param in cfn_hash['local'][cflocal]:

                        if self.debug:
                            print("\n###############################")
                            print('local: '+str(param)+lineno())
                            print('value: '+str(cfn_hash['local'][cflocal][param])+lineno())
                            print("##################################\n")

                        if param == 'default':
                            locals.type = str(type(cfn_hash['local'][cflocal][param]))
                        else:
                            if self.debug:
                                print('no default local'+lineno())

                        if self.debug:
                            print('adding local: '+str(param)+'='+str(cfn_hash['local'][cflocal][param])+lineno())

                        locals.instance_locals.append(param+'='+str(cfn_hash['local'][cflocal][param]))

                    cfn_model.locals[param] = locals


        if 'output' in cfn_hash and cfn_hash['output']:

            if self.debug:
                print('outputs in hash: '+str(cfn_hash['output'])+lineno())

            for output in cfn_hash['output']:

                outputs = Output(debug=self.debug)
                outputs.id = output

                if self.debug:
                    print('outputs id: ' + str(outputs.id) + lineno())

                if cfn_hash['output'][output]:

                    if self.debug:
                        print('output is: '+str(cfn_hash['output'][output])+lineno())

                    for param in cfn_hash['output'][output]:

                        if self.debug:
                            print("\n###############################")
                            print('local: '+str(param)+lineno())
                            print('value: '+str(cfn_hash['output'][output][param])+lineno())
                            print("##################################\n")

                        if param == 'default':
                            outputs.type = str(type(cfn_hash['output'][output][param]))
                        else:
                            if self.debug:
                                print('no default output'+lineno())

                        if self.debug:
                            print('adding output: '+str(param)+'='+str(cfn_hash['output'][output][param])+lineno())

                        outputs.instance_outputs.append(param+'='+str(cfn_hash['output'][output][param]))

                    cfn_model.outputs[param] = outputs



        if 'provider' in cfn_hash and cfn_hash['provider']:

            if self.debug:
                print('providers in hash: '+str(cfn_hash['provider'])+lineno())

            for provider in cfn_hash['provider']:

                providers = Provider(debug=self.debug)
                providers.id = provider

                if self.debug:
                    print('providers id: ' + str(providers.id) + lineno())

                if cfn_hash['provider'][provider]:

                    if self.debug:
                        print('provider is: '+str(cfn_hash['provider'][provider])+lineno())

                    for param in cfn_hash['provider'][provider]:

                        if self.debug:
                            print("\n###############################")
                            print('local: '+str(param)+lineno())
                            print('value: '+str(cfn_hash['provider'][provider][param])+lineno())
                            print("##################################\n")

                        if param == 'default':
                            providers.type = str(type(cfn_hash['provider'][provider][param]))
                        else:
                            if self.debug:
                                print('no default provider'+lineno())

                        if self.debug:
                            print('adding provider: '+str(param)+'='+str(cfn_hash['provider'][provider][param])+lineno())

                        providers.instance_providers.append(param+'='+str(cfn_hash['provider'][provider][param]))

                    cfn_model.providers[param] = providers



        return cfn_model


    def pre_validate_model(self, cloudformation_yml):
        """
        Prevalidate the cloudformation template
        :param cloudformation_yml: 
        :return: 
        """

        if self.debug:
            print("\n\n######################################")
            print('CfnParser - pre_validate_model'+lineno())
            print('########################################\n\n')
            print('cloudformation_yml: '+str(cloudformation_yml)+lineno())

        validator = CloudformationValidator.CloudformationValidator(debug=self.debug)

        errors = validator.validate(cloudformation_yml)

        if errors and len(errors)>0:

            try:

                raise ParserError('Basic CloudFormation syntax error', errors,debug=self.debug)
            except ParserError as e:
                tb = sys.exc_info()[-1]
                if self.debug:
                    print('tb: '+str(tb)+lineno())
                    print('to hash: '+str(e.to_hash())+lineno())
                stk = traceback.extract_tb(tb, 1)
                if self.debug:
                    print('stk: '+str(stk)+lineno())
                fname = stk[0][2]
                if self.debug:
                    print('The failing function was', fname,lineno())
                    print('parser error '+lineno())
                # FIXME
                raise ParserError('Basic CloudFormation syntax error', errors,debug=self.debug)


    def validate_references(self, cfn_hash):
        """
        Validate references in the cloudformation template
        :param cfn_hash: 
        :return: 
        """
        if self.debug:
            print("\n\n###########################################")
            print('CfnParser - validate_references'+lineno())
            print('Looking for unresolved references')
            print('cfn_hash len: '+str(len(cfn_hash))+lineno())
            print("################################################\\n\n")

        ref_validator = ReferenceValidator.ReferenceValidator(debug=self.debug)
        unresolved_refs = ref_validator.unresolved_references(cfn_hash)

        if unresolved_refs and len(unresolved_refs)>0:
            raise ParserError("Unresolved logical resource ids: "+str(unresolved_refs))

    def assign_fields_based_upon_properties(self, resource_object, resource):
        """
        Assign fields in the object based on properties in the resource
        :param resource_object: 
        :param resource: 
        :return: 
        """

        if self.debug:
            print("\n\n#######################################################")
            print('CfnParser - assign_fields_based_upon_properties'+lineno())
            print("#########################################################\n\n")

            print('resource_object: '+str(resource_object)+lineno())
            print('resource: '+str(resource)+lineno())
            print('resource_type:'+str(resource))

        resource_type = str(resource)

        if self.debug:
            print('resource_object dir: '+str(dir(resource_object))+lineno())
            print('resource_object vars: '+str(vars(resource_object))+lineno())


        for p in resource:

            if self.debug:
                print('property: '+str(p)+lineno())
            #new_property_name = self.map_property_name_to_attribute(p)

            if self.debug:
                print("\n\n###########################################")
                print('Creating object attribute during mapping'+lineno())
                print('property: '+str(p))
                #print('property details: '+str(resource['Properties'][p]))
                #print('dir:'+str(dir(resource_object))+lineno())
                #print('new property name'+str(new_property_name)+lineno())
                print('property name: '+str(p)+lineno())
                print('property value: '+str(resource[p])+lineno())
                print("###############################################\n")

            setattr(resource_object, p, str(resource[p]) )

        if self.debug:
            print("\n\n#############################################")
            print('The new resource object now has the following properties'+lineno())
            if hasattr(resource_object, 'policies'):
                print('policies: '+str(resource_object.policies))

            if hasattr(resource_object, 'policy_objects'):
                print('policy objects: '+str(resource_object.policy_objects))
            if hasattr(resource_object, 'group_names'):
                print('group names: '+str(resource_object.group_names))
            if hasattr(resource_object, 'groups'):
                print('groups: '+str(resource_object.groups))
            if hasattr(resource_object, 'resource_type'):
                print('resource type: '+str(resource_object.resource_type))
            if hasattr(resource_object, 'policy_document'):
                print('policy document: '+str(resource_object.policy_document))
            print(vars(resource_object))
            print("##################################################\n")

        if self.debug:
            print('resource_object dir: '+str(dir(resource_object))+lineno())
            print('resource_object vars: '+str(vars(resource_object))+lineno())



        return resource_object

    def map_property_name_to_attribute(self, string):
        """
        Mapp properties to attributes
        :param string: 
        :return: 
        """

        if self.debug:
            print('property name: '+str(string)+lineno())

        #first_character = str(string)[:1]

        #if self.debug:
        #    print('first character: '+str(first_character)+lineno())

        #first_character=first_character.lower()
        #remaining_characters = string[1:]

        #new_property_name = str(first_character)+str(remaining_characters)
        #new_property_name.replace('-','_')

        #if self.debug:
        #    print('new_property_name: '+str(new_property_name)+lineno())

        #return new_property_name

        return string

    def class_from_type_name(self, type_name, cfn_model):
        """
        Create class from type name
        :param type_name: 
        :param cfn_model: 
        :return: 
        """

        if self.debug:
            print('CfnParser - class_from_type_name'+lineno())
            print('type_name: '+str(type_name)+lineno())

        resource_class = self.generate_resource_class_from_type(type_name,cfn_model)

        return resource_class

    def generate_resource_class_from_type(self, type_name, cfn_model):
        """
        Generate resource class from type
        :param type_name: 
        :param cfn_model: 
        :return: 
        """

        if self.debug:
            print('generate_resource_class_from_type'+lineno())
            print('cfn model: '+str(cfn_model)+lineno())
            print('type name: '+str(type_name)+lineno())


        models = [
            'S3BucketPolicy',
            'EC2Instance',
            'EC2NetworkInterface',
            'IAMGroup',
            'IAMManagedPolicy',
            'IAMPolicy',
            'IAMRole',
            'IAMUser',
            'ElasticLoadBalancingLoadBalancer',
            'ElasticLoadBalancingV2LoadBalancer',
            'SQSQueuePolicy',
            'EC2SecurityGroup',
            'EC2SecurityGroupEgress',
            'EC2SecurityGroupIngress',
            'SNSTopicPolicy'
        ]

        models2= [
            'aws_instance',
            'aws_elb',
            'aws_security_group',
            'aws_security_group_rule',
            'aws_iam_role'
        ]
        module_name = 'AWS'

        if type_name == 'aws_instance':
            short_name ='EC2Instance'
        if type_name == 'aws_elb':
            short_name = 'ElasticLoadBalancingLoadBalancer'
        if type_name == 'aws_security_group':
            short_name = 'EC2SecurityGroup'
        if type_name == 'aws_iam_role':
            short_name = 'IAMRole'
        if type_name == 'aws_security_group_rule':
            if type == 'x':
                short_name = 'EC2SecurityGroupEgress'
            else:
                short_name = 'EC2SecurityGroupIngress'

        #module_names = type_name.split('::')
        if module_name == 'Custom':

            if self.debug:
                print('module is custom: '+lineno())


            custom_resource_class_name = self.initial_upper(short_name)
            resource_class = ModelElement.ModelElement(debug=self.debug)
            setattr(resource_class,'__name__',custom_resource_class_name)
            setattr(resource_class,'debug',self.debug)
        elif module_name == 'AWS':

            if self.debug:
                print('module is AWS: '+lineno())


            if str(type_name) in models2:

                if self.debug:
                    print('short_name: ' + str(short_name) + lineno())
                    print('sys modules __name__: '+str(sys.modules[__name__])+lineno())

                resource_class = getattr(sys.modules[__name__], short_name).__getattribute__(short_name)(cfn_model)
                setattr(resource_class,'debug',self.debug)

            else:
                resource_class = ModelElement.ModelElement(cfn_model)
                setattr(resource_class, '__name__', type_name)
                setattr(resource_class,'debug',self.debug)
        else:
            print('unknown namespace in resource type'+lineno())
            sys.exit(1)

        if self.debug:
            print('vars: '+str(vars(resource_class))+lineno())

        return resource_class


    def initial_upper(self, string):
        """
        First character to upper case
        :param string: 
        :return: 
        """
        if self.debug:
            print('CfnParser - initial_upper'+lineno())

        first_character = str(string)[:1]
        remaining_characters = string[1:]

        new_property_name = str(first_character.upper())+str(remaining_characters)

        return new_property_name
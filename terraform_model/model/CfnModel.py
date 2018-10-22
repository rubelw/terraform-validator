from __future__ import absolute_import, division, print_function
import copy
import inspect
from builtins import (str)
from terraform_model.model.References import References
from terraform_model.model.Parameter import Parameter
from terraform_model.model.Data import Data
from terraform_model.model.Output import Output
from terraform_model.model.Locals import Locals
from terraform_model.model.Provider import Provider




def lineno():
    """Returns the current line number in our program."""
    return str(' - CfnModel - caller: '+str(inspect.stack()[1][3])+' - line number: '+str(inspect.currentframe().f_back.f_lineno))


class CfnModel:
    """
    Cloudformation model
    """

    def __init__(self, debug=False):
        """
        Initialize
        :param debug: 
        """
        # attr_accessor :raw_model
        self.outputs = {}
        self.locals = {}
        self.providers = {}
        self.parameters={}
        self.data = {}
        self.resources = {}
        self.raw_model = None
        self.debug = debug
        if self.debug:
            print('CfnModel - init'+lineno())

    def copy(self):
        """
        copy the model
        :return: copy of model
        """
        if self.debug:
            print('CfnModel - copy'+lineno())

        return copy.copy(self.raw_model)

    def security_groups(self):
        """
        Get security groups
        :return: 
        """
        if self.debug:
            print("\n\n################################################################")
            print('CfnModel - security_groups - getting security group resources'+lineno())
            print("####################################################################\n")

        return self.resources_by_type('AWS::EC2::SecurityGroup')

    def iam_users(self):
        """
        Get iam users
        :return: 
        """
        if self.debug:
            print("\n\n################################################################")
            print('CfnModel - iam_users - getting iam users resources'+lineno())
            print("####################################################################\n")

        return self.resources_by_type('AWS::IAM::User')

    def standalone_ingress(self):
        """
        Get standalone ingress resources
        :return: 
        """
        if self.debug:
            print("\n\n################################################################")
            print('CfnModel - standalone_ingress - getting security group ingress resources'+lineno())
            print("####################################################################\n")

        security_group_ingresses = []

        resources = self.resources_by_type('AWS::EC2::SecurityGroupIngress')

        for resource in resources:
            if self.debug:
                print("\n\n#############################################")
                print('Stand alone ingress'+lineno())
                print(str(resource) + lineno())
                print("################################################\n")

            if 'Properties' in resource.cfn_model:
                if self.debug:
                    print('properties in cfn_model: '+lineno())
                if 'GroupId' in resource.cfn_model['Properties']:
                    if self.debug:
                        print('groupid in properties: '+lineno())

                    if References.is_security_group_id_external(str(resource.cfn_model['Properties']['GroupId']) ,debug=self.debug):
                        security_group_ingresses.append(resource)
        if self.debug:
            print("\n############################################")
            print('These are the standalone security_group_ingresses: '+str(security_group_ingresses)+lineno())
            print("##############################################\n")

        return security_group_ingresses

    def standalone_egress(self):
        """
        Get standalone egress resources
        :return: 
        """
        if self.debug:
            print("\n\n################################################################")
            print('CfnModel - standalone_egress - getting security group egress resources'+lineno())
            print("####################################################################\n")

        security_group_egresses = []

        resources = self.resources_by_type('AWS::EC2::SecurityGroupEgress')

        for resource in resources:
            if self.debug:
                print(str(resource) + lineno())

            if 'variable' in resource.cfn_model:

                if self.debug:
                    print('variables in cfn_model '+lineno())

                if 'GroupId' in resource.cfn_model['variable']:
                    if self.debug:
                        print('GroupId in properties'+lineno())

                    if References.is_security_group_id_external(
                            resource.cfn_model['Properties']['GroupId'],
                            debug=self.debug):

                        security_group_egresses.append(resource)

                if 'groupId' in resource.cfn_model['Properties']:
                    if self.debug:
                        print('groupId in properties'+lineno())

                    if References.is_security_group_id_external(
                            resource.cfn_model['Properties']['groupId'],
                            debug=self.debug):

                        security_group_egresses.append(resource)

        if self.debug:
            print('security_group_egresses: '+str(security_group_egresses)+lineno())

        return security_group_egresses

    def resources_by_type(self, resource_type):
        """
        Get cfn resources by type
        :param resource_type: 
        :return: 
        """
        if self.debug:

            print('CfnModel - resource_by_type'+lineno())
            print("\n\n####################################")
            print('#### Looking for resource_type: '+str(resource_type)+' in raw_model'+lineno())
            print('#### raw model: '+str(self.raw_model)+lineno())
            print("####################################\n\n")

        original_resource_type = resource_type

        resource_map = {
            'AWS::ElasticLoadBalancing::LoadBalancer':'aws_elb',
            'AWS::EC2::SecurityGroup':'aws_security_group',
            'AWS::EC2::Instance':'aws_instance',
            'AWS::IAM::Role': 'aws_iam_role',
            "AWS::IAM::Policy": 'aws_iam_policy',
            "AWS::IAM::User": 'aws_iam_user',
            "AWS::EC2::NetworkInterface": 'aws_network_interface',
            "AWS::IAM::Group": 'aws_iam_group',
            "AWS::S3::BucketPolicy": 'aws_s3_bucket_policy',
            "AWS::SQS::QueuePolicy":'aws_sqs_queue_policy',
            "AWS::IAM::ManagedPolicy":'aws_iam_policy_attachment',
            "AWS::SNS::TopicPolicy": 'aws_sns_topic_policy',
            "AWS::EC2::SecurityGroupIngress": 'aws_security_group_rule',
            "AWS::EC2::SecurityGroupEgress": 'aws_security_group_rule',
            "AWS::S3::Bucket":'aws_s3_bucket',
            "AWS::RDS::DBInstance":'aws_db_instance',
            "AWS::CloudFront::Distribution": 'aws_cloudfront_distribution',
            "AWS::IAM::UserToGroupAddition":'aws_iam_policy_attachment'
        }

        if resource_type in resource_map:
            resource_type = resource_map[resource_type]

        if self.debug:
            print('trying to find: '+str(resource_type)+lineno())

        resources = []

        if self.debug:
            print(str(self.resources)+lineno())

        # Iterating through the resources in the raw_model
        for resource in self.resources:
            if self.debug:
                print("\n################# Resource Details ########################")
                print('resource: '+str(resource)+lineno())
                print('resource object: '+str(self.resources[resource])+lineno())

                print('type: '+str(self.resources[resource].resource_type)+lineno())
                print('vars: '+str(vars(self.resources[resource]))+lineno())
                print('resource type is: '+str(self.resources[resource].resource_type)+lineno())
                print("############################################################\n")

            if str(self.resources[resource].resource_type) == str(resource_type):

                if resource_type == 'aws_security_group_rule':
                    if str(original_resource_type) =='AWS::EC2::SecurityGroupIngress':

                        resources.append(self.resources[resource])
                        if self.debug:
                            print(' ### FOUND MATCHING RESOURCE TYPE - type: ' + str(resource_type) + lineno())

                    elif str(original_resource_type) == 'AWS::EC2::SecurityGroupEgress':

                        resources.append(self.resources[resource])
                        if self.debug:
                            print(' ### FOUND MATCHING RESOURCE TYPE - type: ' + str(resource_type) + lineno())

                else:
                    if self.debug:
                        print(' ### FOUND MATCHING RESOURCE TYPE - type: '+str(resource_type)+lineno())

                    resources.append(self.resources[resource])

        if self.debug:
            print('CfnModel - resources_by_type - returning resource'+lineno())

        if len(resources)<1:
            if self.debug:
                print('### Could not find matching type for: '+str(resource_type)+lineno())
        else:
            if self.debug:
                print("\n\n########################################")
                print('### found '+str(len(resources))+' '+str(resource_type)+' resources'+lineno())
                print("########################################\n\n")


        return resources

    def find_security_group_by_group_id(self, security_group_reference):
        """
        Get security group by security group id
        :param security_group_reference: 
        :return: 
        """
        if self.debug:
            print('CfnModel - find_security_group_by_group_id'+lineno())
            print('security_group_reference: '+str(security_group_reference)+lineno())

        security_group_id = References.resolve_security_group_id(security_group_reference)

        if not security_group_id:
            # # leave it alone since external ref or something we don't grok
            return security_group_reference
        else:

            security_groups = self.security_groups()

            for sg in security_groups:
                if self.debug:
                    print('sg: '+str(sg)+lineno())
                    print('vars: '+str(vars(sg))+lineno())

                if sg.logical_resource_id == sg:
                    return sg

            # leave it alone since external ref or something we don't grok
            return security_group_reference

    def transform_hash_into_parameters(self, cfn_hash):
        """
        Transform hash into parameters
        :param cfn_hash:
        :return:
        """

        if self.debug:
            print('CfnParser - transform_hash_into_parameters'+lineno())
            print('cfn_hash: '+str(cfn_hash)+lineno())


        if 'variable' in cfn_hash and cfn_hash['variable']:

            for param in cfn_hash['variable']:

                if self.debug:
                    print(param+lineno())
                    print(str(cfn_hash['Parameters'][param])+lineno())

                parameter = Parameter(debug=self.debug)
                parameter.id = param
                parameter.type = cfn_hash['variable'][param]['Type']

                parameter.instance_variables.append(param+'='+cfn_hash['variable'][param]['Type'].lower().replace('-','_'))

                self.parameters[param] = parameter

        if 'data' in cfn_hash and cfn_hash['data']:

            for param in cfn_hash['data']:

                if self.debug:
                    print(param+lineno())
                    print(str(cfn_hash['data'][param])+lineno())

                data = Data(debug=self.debug)
                data.id = param
                data.type = cfn_hash['data'][param]['Type']

                data.instance_variables.append(param+'='+cfn_hash['data'][param]['Type'].lower().replace('-','_'))

                self.data[param] = data

        if 'output' in cfn_hash and cfn_hash['output']:

            for param in cfn_hash['output']:

                if self.debug:
                    print(param+lineno())
                    print(str(cfn_hash['output'][param])+lineno())

                output = Output(debug=self.debug)
                output.id = param
                output.type = cfn_hash['output'][param]['Type']

                output.instance_variables.append(param+'='+cfn_hash['output'][param]['Type'].lower().replace('-','_'))

                self.outputs[param] = output

        if 'locals' in cfn_hash and cfn_hash['locals']:

            for param in cfn_hash['locals']:

                if self.debug:
                    print(param+lineno())
                    print(str(cfn_hash['output'][param])+lineno())

                locals = Locals(debug=self.debug)
                locals.id = param
                locals.type = cfn_hash['locals'][param]['Type']

                locals.instance_variables.append(param+'='+cfn_hash['locals'][param]['Type'].lower().replace('-','_'))

                self.locals[param] = locals

        if 'provider' in cfn_hash and cfn_hash['provider']:

            for param in cfn_hash['provider']:

                if self.debug:
                    print(param+lineno())
                    print(str(cfn_hash['output'][param])+lineno())

                locals = Locals(debug=self.debug)
                locals.id = param
                locals.type = cfn_hash['provider'][param]['Type']

                locals.instance_variables.append(param+'='+cfn_hash['provider'][param]['Type'].lower().replace('-','_'))

                self.locals[param] = locals
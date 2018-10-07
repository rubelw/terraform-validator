from __future__ import absolute_import, division, print_function
import yaml
import sys
import os
import json
from terraform_model.validator.ResourceTypeValidator import ResourceTypeValidator
import inspect
from builtins import (str)

def lineno():
    """Returns the current line number in our program."""
    return str(' -  SchemaGenerator- line number: '+str(inspect.currentframe().f_back.f_lineno))

class SchemaGenerator:
    """
    # This generator is a bit of hacking to trick kwalify into validating yaml for a cfn template.
    #
    # because cfn uses open-ended key names for the resources.... a static schema can't be used
    # with kwalify.  so first we make sure there is a basic structure of resources with Type values
    # then we generate the schema from the document for the keys and cross-reference with schema
    # files per resource type
    """
    def __init__(self, debug=False):
        """
        Initialize
        :param debug:
        """

        self.debug= debug

        if self.debug:
            print(' __init__' + lineno())

    def generate(self, cloudformation_yml):
        """
        Generate schema
        :param cloudformation_yml:
        :return:
        """

        # make sure structure of Resources is decent and that every record has a Type at least
        validator = ResourceTypeValidator(debug=self.debug)
        cloudformation_hash = validator.validate(cloudformation_yml)

        parameters_schema = self.generate_schema_for_parameter_keys(cloudformation_hash)

        if self.debug:
            print('getting resources schema: '+lineno())

        resources_schema = self.generate_schema_for_resource_keys(cloudformation_hash)

        with open(os.path.dirname(os.path.dirname(__file__)) + '/schema/schema.yml.erb', 'r') as stream:
            main_schema = yaml.load(stream)

        if not parameters_schema or len(parameters_schema)<1:
            if self.debug:
                print('not variables in variable schema'+lineno())

            main_schema.pop('mapping', 'variable')
            #main_schema['mapping'].delete 'Parameters'
        else:
            if self.debug:
                print('there are variables'+lineno())
            main_schema['mapping']['variable']['mapping'] = parameters_schema

        main_schema['mapping']['resource']['mapping'] = resources_schema

        if self.debug:
            print("\n###parameter schema: "+str(parameters_schema)+lineno())
            print("\n###main_schema"+str(main_schema)+lineno())

        return main_schema



    ##
    # this is fairly superfluous.  there's not much structure here
    # except that Types are Strings.... anything else is up to a rule
    # to wade through all the optional crap (like looking for NoEcho)
    def generate_schema_for_parameter_keys(self, cloudformation_hash):
          """
          Generate schema for parameter keys
          :param cloudformation_hash:
          :return:
          """
          if self.debug:
            print('generate_schema_for_parameter_keys '+lineno())
            print('cloudformation_hash '+str(cloudformation_hash)+lineno())

          if not cloudformation_hash:
              return {}

          if self.debug:
              print('cloudformation is a hash: '+lineno())

          parameters_schema = {
            '=' : { 'type' : 'any'}
          }

          if 'variable' in cloudformation_hash:

              if self.debug:
                  print('variable in cloudformation hash: '+lineno())

              for parameter in cloudformation_hash['variable']:
                  for parameter in cloudformation_hash['variable'][parameter]:
                      parameters_schema[parameter]= {
                      'type' : 'map',
                      'mapping' : {
                        'Type' : {
                          'type' : 'str'
                        },
                        '=' : {
                          'type' : 'any'
                        }
                      }
                    }

          if self.debug:
              print('parameters_schema: '+str(parameters_schema))

          return parameters_schema


    def generate_schema_for_resource_keys(self, cloudformation_hash):
        """
        Generate schema for resource keys
        :param cloudformation_hash:
        :return:
        """

        if type(cloudformation_hash) == type(str()):
            json_acceptable_string = cloudformation_hash.replace("'", "\"")
            cloudformation_hash= json.loads(json_acceptable_string)

        resources_schema = {
          '=' : { 'type' : 'any'}
        }

        for resources in cloudformation_hash['resource']:

            if self.debug:
                print('resource: '+str(resources)+lineno())


            schema_hash=self.schema_for_type(resources)

            if schema_hash:

                if self.debug:
                    print('schema_hash:'+str(schema_hash)+lineno())

                resources_schema['resource'][resource]= schema_hash

        if self.debug:
            print('resoures_schema: '+str(resources_schema)+lineno())

        return resources_schema


    def schema_file(self, file):
         """
         ???
         :param file:
         :return:
         """
         if self.debug:
            print('schema_file '+lineno())

         file = file.replace('::','_')+'.yml'

         if self.debug:
             print('file: '+str(file)+lineno())
             print('path: '+str(os.path.dirname(os.path.dirname(__file__))))

         path = os.path.dirname(os.path.dirname(__file__))+'/schema'

         file = str(path)+'/'+str(file)
         if os.path.exists(file):

             if self.debug:
                 print('found file: '+str(file)+lineno())
             return file
         return None


    def schema_for_type(self, type):
         """
         ???
         :param type:
         :return:
         """
         if self.debug:
            print('schema_for_type:'+lineno())
            print('type: '+str(type)+lineno())

         yaml_file = self.schema_file(type)

         if yaml_file:

             # Read YAML file
             with open(yaml_file, 'r') as stream:
                 data_loaded = yaml.load(stream)

                 if self.debug:
                     print('data: '+str(data_loaded)+lineno())

                 return data_loaded

         return None
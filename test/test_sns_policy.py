import os
import sys
import unittest
from collections import OrderedDict
from terraform_validator.ValidateUtility import ValidateUtility as class_to_test

def pretty(value, htchar='\t', lfchar='\n', indent=0):
    """
    Prints pretty json
    :param value:
    :param htchar:
    :param lfchar:
    :param indent:
    :return: pretty json
    """


    nlch = lfchar + htchar * (indent + 1)
    if type(value) == type(dict()) or type(value) == type(OrderedDict()):
        items = [
            nlch + repr(key) + ': ' + pretty(value[key], htchar, lfchar, indent + 1)
            for key in value
        ]
        return '{%s}' % (','.join(items) + lfchar + htchar * indent)

    elif type(value) == type(list()):
        items = [
            nlch + pretty(item, htchar, lfchar, indent + 1)
            for item in value
        ]

        if items:
            items = sorted(items)
        [str(item) for item in items]
        return '[%s]' % (','.join(items) + lfchar + htchar * indent)

    elif type(value) is tuple:
        items = [
            nlch + pretty(item, htchar, lfchar, indent + 1)
            for item in value
        ]
        return '(%s)' % (','.join(items) + lfchar + htchar * indent)

    else:
        return repr(str(value))

class TestSnsPolicy(unittest.TestCase):
    """
    Test sns policy
    """
    def test_sns_policy(self):

        expected_result =  [
            {
                'failure_count': '4',
                'filename': '/tf/sns_topic_policy/sns_topic_with_wildcard_principal.tf',
                'file_results': [
                    {
                        'id': 'F18',
                        'type': 'VIOLATION::FAILING_VIOLATION',
                        'message': 'SNS topic policy should not allow * principal',
                        'logical_resource_ids': "['mysnspolicy0', 'mysnspolicy1', 'mysnspolicy2', 'mysnspolicy3']"
                    },
                    {
                        'id': 'W1',
                        'type': 'VIOLATION::WARNING',
                        'message': 'Specifying credentials in the template itself is probably not the safest thing',
                        'logical_resource_ids': ['provider']
                    }
                ]
            }
        ]

        if sys.version_info[0] < 3:

            expected_result = [
                    {
                        'failure_count': '4',
                        'filename': '/tf/sns_topic_policy/sns_topic_with_wildcard_principal.tf',
                        'file_results': [
                            {
                                'id': 'F18',
                                'type': 'VIOLATION::FAILING_VIOLATION',
                                'message': 'SNS topic policy should not allow * principal',
                                'logical_resource_ids': "['mysnspolicy0', 'mysnspolicy1', 'mysnspolicy2', 'mysnspolicy3']"
                            },
                            {
                                'id': 'W1',
                                'type': 'VIOLATION::WARNING',
                                'message': 'Specifying credentials in the template itself is probably not the safest thing',
                                'logical_resource_ids': ['provider']
                            }
                        ]
                    }
            ]
            new_file_results = []


            for info in expected_result[0]['file_results']:
              print('info: '+str(info))
              print('type: '+str(type(info)))
              order_of_keys = ["id", "type", "message","logical_resource_ids"]

              new_results = OrderedDict()
              for key in order_of_keys:
                  new_results[key]=info[key]

              new_file_results.append(new_results)
              print('new file results: '+str(new_file_results))

              expected_result[0]['file_results']=new_file_results


            order_of_keys = ["failure_count", "filename", "file_results"]
            list_of_tuples = [(key, expected_result[0][key]) for key in order_of_keys]
            expected_result = [OrderedDict(list_of_tuples)]


        expected_result = pretty(expected_result)

        template_name = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+'/terraform_validator/test_templates/tf/sns_topic_policy/sns_topic_with_wildcard_principal.tf'
        debug = True

        config_dict = {}
        config_dict['template_file'] = template_name
        config_dict['debug'] = debug
        config_dict['profile'] = None
        config_dict['rules_directory'] = None
        config_dict['input_path'] = None
        config_dict['profile'] = None
        config_dict['allow_suppression'] = False
        config_dict['print_suppression'] = False
        config_dict['parameter_values_path'] = None
        config_dict['isolate_custom_rule_exceptions'] = None
        validator = class_to_test(config_dict)

        real_result =  validator.validate()
        self.maxDiff = None

        print('expected results: ' + str(expected_result))
        print('real results: ' + str(real_result))

        self.assertEqual(json.loads(expected_result), json.loads(real_result))

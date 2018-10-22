from __future__ import absolute_import, division, print_function
import sys
import inspect
import json
import re
from terraform_model.model.PolicyDocument import PolicyDocument
from terraform_model.model.Statement import Statement


def lineno():
    """Returns the current line number in our program."""
    return str(' - PolicyDocumentParser - line number: '+str(inspect.currentframe().f_back.f_lineno))


class PolicyDocumentParser:
    """
    Policy document parser
    """

    def __init__(self, debug=False):
        """
        Initialize
        :param debug: 
        """
        self.debug = debug

        if self.debug:
            print('ParserError - init'+lineno())

    def parse(self, cfn_model, raw_policy_document):

        if self.debug:
            print("\n\n################################")
            print('PolicyDocumentParser - parse'+lineno())
            print("####################################\n\n")

            print('raw_policy_document: '+str(raw_policy_document)+lineno())

        policy_document = PolicyDocument(debug=self.debug)

        if self.debug:
            print('have policy document: '+lineno())
            print('type: '+str(type(raw_policy_document))+lineno())


        if type(raw_policy_document) == type(str()):

            if self.debug:
                print('raw policy: '+str(raw_policy_document)+lineno())

            matchObj = re.match(r'(.*)(\${)([^}]+)(})(.*)', raw_policy_document, re.M | re.I)

            if matchObj:
                prefix = str(matchObj.group(1))
                lookup = str(matchObj.group(3))
                suffix = str(matchObj.group(5))

                if self.debug:
                    print('prefix: ' + str(prefix) + lineno())
                    print('lookup: ' + str(lookup) + lineno())
                    print('suffix: ' + str(suffix) + lineno())

                parts = lookup.split('.')

                if self.debug:
                    print('parts: ' + str(parts) + lineno())
                    print('cfn model - raw model: ' + str(cfn_model.raw_model) + lineno())


                for i in range(len(parts)):

                    if parts[i] in cfn_model.raw_model:
                        if self.debug:
                            print('part '+str(i)+' '+str(parts[i])+' in cfn model'+lineno())

                        if parts[i+1] in cfn_model.raw_model[parts[i]]:
                            if self.debug:
                                print('part ' + str(i+1) + ' ' + str(parts[i+1]) + ' in cfn model'+lineno())

                            if parts[i+2] in cfn_model.raw_model[parts[i]][parts[i+1]]:
                                if self.debug:
                                    print('part ' + str(i + 2) + ' ' + str(parts[i + 2]) + ' in cfn model'+lineno())

                                raw_policy_document= str(prefix)+str(cfn_model.raw_model[parts[i]][parts[i+1]][parts[i+2]])+str(suffix)

                                if self.debug:
                                    print('new raw policy is: '+str(raw_policy_document)+lineno())

                                break

            else:
                if self.debug:
                    print('no match object '+lineno())

                json_acceptable_string = raw_policy_document.replace("'", "\"")

                if self.debug:
                    print('json acceptable string is: '+str(json_acceptable_string)+lineno())

                raw_policy_document= json.loads(json_acceptable_string)



        if type(policy_document) == type(str()):
            if self.debug:
                print('policy document is a string: '+lineno())

            json_acceptable_string = policy_document.replace("'", "\"")
            policy_document= json.loads(json_acceptable_string)


        if type(raw_policy_document) == type(str()):
            if self.debug:
                print('raw policy document is a string: '+lineno())

            matchObj = re.match(r'(.*)(\${)([^}]+)(})(.*)', raw_policy_document, re.M | re.I)

            if matchObj:
                prefix = str(matchObj.group(1))
                lookup = str(matchObj.group(3))
                suffix=str(matchObj.group(5))

                if self.debug:
                    print('prefix: '+str(prefix)+lineno())
                    print('lookup: '+str(lookup)+lineno())
                    print('suffix: '+str(suffix)+lineno())

                parts = lookup.split('.')

                if self.debug:
                    print('parts: '+str(parts)+lineno())
                    print('cfn model - raw model: '+str(cfn_model.raw_model)+lineno())

                for i in range(len(parts)):

                    if parts[i] in cfn_model.raw_model:
                        if self.debug:
                            print('part '+str(i)+' '+str(parts[i])+' in cfn model'+lineno())

                        if parts[i+1] in cfn_model.raw_model[parts[i]]:
                            if self.debug:
                                print('part ' + str(i+1) + ' ' + str(parts[i+1]) + ' in cfn model'+lineno())

                            if parts[i+2] in cfn_model.raw_model[parts[i]][parts[i+1]]:
                                if self.debug:
                                    print('part ' + str(i + 2) + ' ' + str(parts[i + 2]) + ' in cfn model'+lineno())

                                raw_policy_document= str(prefix)+str(cfn_model.raw_model[parts[i]][parts[i+1]][parts[i+2]])+str(suffix)

                                if self.debug:
                                    print('new raw policy is: '+str(raw_policy_document)+lineno())

                                break



            json_acceptable_string = raw_policy_document.replace("'", "\"")
            raw_policy_document= json.loads(json_acceptable_string)

        if 'version' in raw_policy_document:
            if self.debug:
                print('version in policy document: '+lineno())
                print('type: '+str(type(raw_policy_document)))

                print('version: '+str(raw_policy_document['version'])+lineno())

            policy_document.version = raw_policy_document['version']

        if 'Version' in raw_policy_document:
            if self.debug:
                print('Version in policy document: '+lineno())
                print('type: '+str(type(raw_policy_document)))

                print('version: '+str(raw_policy_document['Version'])+lineno())

            policy_document.version = raw_policy_document['Version']


        if 'statement' in raw_policy_document:
            if self.debug:
                print('has statement in raw policy document'+lineno())
                print('statement: '+str(raw_policy_document['statement'])+lineno())

            if type(raw_policy_document['statement'])==type(list()):

                if len(raw_policy_document['statement'])>1:
                    if self.debug:
                        print('more than one statement')

                for statement in raw_policy_document['statement']:
                    if self.debug:
                        print('statement: '+str(statement)+lineno())
                    streamlined_array = self.streamline_array(statement)
                    parsed_statement = self.parse_statement(streamlined_array)
                    if self.debug:
                        print('parsed_statement: '+str(parsed_statement)+lineno())
                        print('actions: '+str(parsed_statement.actions)+lineno())
                        print('not_actions: '+str(parsed_statement.not_actions)+lineno())
                        print('resources: '+str(parsed_statement.resources)+lineno())
                        print('not_resources: '+str(parsed_statement.not_resources)+lineno())
                        print('sid: '+str(parsed_statement.sid)+lineno())
                        print('effect: '+str(parsed_statement.effect)+lineno())
                        print('condition: '+str(parsed_statement.condition)+lineno())
                        print('principal: '+str(parsed_statement.principal)+lineno())
                        print('non principal: '+str(parsed_statement.not_principal)+lineno())


                    policy_document.statements.append(parsed_statement)

            elif type(raw_policy_document['statement'])== type(dict()):

                if self.debug:
                    print('statement: ' + str(raw_policy_document['statement'])+lineno())

                parsed_statement = self.parse_statement(raw_policy_document['statement'])
                if self.debug:
                    print('parsed_statement: ' + str(parsed_statement) + lineno())
                policy_document.statements.append(parsed_statement)


            elif type(raw_policy_document['statement']) == type(str()):
                if self.debug:
                    print('statement: ' + str(raw_policy_document['statement'])+lineno())

                parsed_statement = self.parse_statement(raw_policy_document['statement'])
                if self.debug:
                    print('parsed_statement: ' + str(parsed_statement) + lineno())
                policy_document.statements.append(parsed_statement)


            else:
                if self.debug:
                    print('unknown type: '+lineno())
                sys.exit(1)

            if self.debug:
                print('policy_document: '+str(vars(policy_document))+lineno())
                print('statments'+str(policy_document.statements)+lineno())
                print('statement types: '+str(type(policy_document.statements))+lineno())
                print('type: '+str(type(policy_document))+lineno())

        if 'Statement' in raw_policy_document:
            if self.debug:
                print('has statement in raw policy document'+lineno())
                print('statement: '+str(raw_policy_document['Statement'])+lineno())

            if type(raw_policy_document['Statement'])==type(list()):

                if len(raw_policy_document['Statement'])>1:
                    if self.debug:
                        print('more than one Statemnt')

                for statement in raw_policy_document['Statement']:
                    if self.debug:
                        print('Statement: '+str(statement)+lineno())
                    streamlined_array = self.streamline_array(statement)
                    parsed_statement = self.parse_statement(streamlined_array)
                    if self.debug:
                        print('parsed_statement: '+str(parsed_statement)+lineno())
                    policy_document.statements.append(parsed_statement)

            elif type(raw_policy_document['Statement'])== type(dict()):

                if self.debug:
                    print('Statement: ' + str(raw_policy_document['Statement'])+lineno())

                parsed_statement = self.parse_statement(raw_policy_document['Statement'])
                if self.debug:
                    print('parsed_statement: ' + str(parsed_statement) + lineno())
                policy_document.statements.append(parsed_statement)


            elif type(raw_policy_document['Statement']) == type(str()):
                if self.debug:
                    print('Statement: ' + str(raw_policy_document['Statement'])+lineno())

                parsed_statement = self.parse_statement(raw_policy_document['Statement'])
                if self.debug:
                    print('parsed_statement: ' + str(parsed_statement) + lineno())
                policy_document.statements.append(parsed_statement)


            else:
                if self.debug:
                    print('unknown type: '+lineno())
                sys.exit(1)

            if self.debug:
                print('policy_document: '+str(vars(policy_document))+lineno())
                print('statments'+str(policy_document.statements)+lineno())
                print('statement types: '+str(type(policy_document.statements))+lineno())
                print('type: '+str(type(policy_document))+lineno())


        if self.debug:
            print('returning a policy document to caller '+lineno())


        return policy_document



    def parse_statement(self, raw_statement):
        """
        Parse statement
        :param vraw_statement: 
        :return: 
        """
        if self.debug:
            print('parse_statement'+lineno())
            print('raw_statement: '+str(raw_statement)+lineno())
            print('raw statement type is: '+str(type(raw_statement))+lineno())


        statement = Statement(self.debug)
        if 'effect' in raw_statement:
            if self.debug:
                print('effect in raw_statement '+lineno())

            statement.effect = raw_statement['effect']
        if 'Effect' in raw_statement:
            statement.effect = raw_statement['Effect']

        if 'sid' in raw_statement:
            if self.debug:
                print('sid in raw_statement '+lineno())
            statement.sid = raw_statement['sid']
        if 'Sid' in raw_statement:
            statement.sid = raw_statement['Sid']

        if 'condition' in raw_statement:
            if self.debug:
                print('condition in raw_statement '+lineno())
            statement.condition = raw_statement['condition']
        if 'Condition' in raw_statement:
            statement.condition = raw_statement['Condition']

        if 'action' in raw_statement:
            if self.debug:
                print('action in raw_statement '+lineno())
            statement.actions.append(raw_statement['action'])
        if 'Action' in raw_statement:
            statement.actions.append(raw_statement['Action'])

        if 'NotAction' in raw_statement:
            statement.not_actions.append(raw_statement['NotAction'])
        if 'not_actions' in raw_statement:
            if self.debug:
                print('not_actions in raw_statement '+lineno())
            statement.not_actions.append(raw_statement['not_actions'])

        if 'resources' in raw_statement:
            if self.debug:
                print('resources in raw_statement '+lineno())
            statement.resources.append(raw_statement['resources'])
        if 'Resource' in raw_statement:
            statement.resources.append(raw_statement['Resource'])

        if 'not_resources' in raw_statement:
            if self.debug:
                print('not_resources in raw_statement '+lineno())
            statement.not_resources.append(raw_statement['not_resources'])
        if 'NotResource' in raw_statement:
            statement.not_resources.append(raw_statement['NotResource'])

        if 'principals' in raw_statement:
            if self.debug:
                print('principals in raw_statement '+lineno())
            statement.principal = raw_statement['principals']
        if 'Principal' in raw_statement:
            statement.principal = raw_statement['Principal']

        if 'not_principals' in raw_statement:
            if self.debug:
                print('not_principals in raw_statement '+lineno())
            statement.not_principal = raw_statement['not_principals']
        if 'NotPrincipal' in raw_statement:
            statement.not_principal = raw_statement['NotPrincipal']

        if self.debug:
            print('raw_statement: '+str(raw_statement)+lineno())
            if statement.condition:
                print('condition: '+str(statement.condition)+lineno())
            if statement.actions:
                print('actions: '+str(statement.actions)+lineno())
            if statement.sid:
                print('sid: '+str(statement.sid)+lineno())
            if statement.effect:
                print('effect: '+str(statement.effect)+lineno())
            if statement.resources:
                print('resources: '+str(statement.resources)+lineno())
            if statement.principal:
                print('principal: '+str(statement.principal)+lineno())
            if statement.not_principal:
                print('not_principal: '+str(statement.not_principal)+lineno())


            print("\n\n###############################################")
            print("statement: "+str(vars(statement))+lineno())
            print(' wildcard_actions:'+str(statement. wildcard_actions())+lineno())
            print('wildcard_principal: '+str(statement.wildcard_principal())+lineno())
            print('wildcard_resources: '+str(statement.wildcard_resources())+lineno())
            print("#####################################################\n")

        return statement

    def streamline_array(self, one_or_more):
        """
        ???
        :param one_or_more: 
        :return: 
        """

        if one_or_more:
            if self.debug:
                print('one_or_more: '+str(one_or_more)+lineno())


            if type(one_or_more) == type(str()):
                if self.debug:
                    print('is a string '+lineno())
                return one_or_more
            elif type(one_or_more)==type(dict()):
                if self.debug:
                    print('is a dict: '+lineno())


                return one_or_more
            elif type(one_or_more)==type(list()):
                if self.debug:
                    print('is an array: '+lineno())
                return one_or_more

            else:
                raise "unexpected object in streamline_array "+str(one_or_more)
        # FIXME
        sys.exit(1)
        return None



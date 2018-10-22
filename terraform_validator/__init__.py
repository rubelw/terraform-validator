from __future__ import absolute_import, division, print_function
import pkg_resources
from terraform_validator.ValidateUtility import ValidateUtility #noqa

__version__ = pkg_resources.get_distribution('terraform_validator').version

__all__ = [
    'schema_registry',
    'rules_set_registry'
]
__title__ = 'terraform_validator'
__version__ = '0.6.42'
__author__ = 'Will Rubel'
__author_email__ = 'willrubel@gmail.com'


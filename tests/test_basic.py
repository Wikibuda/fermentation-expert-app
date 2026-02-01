#!/usr/bin/env python3
"""Basic tests for Fermentation Expert App"""

import unittest
import os

class TestProjectStructure(unittest.TestCase):
    """Test project structure and basic files"""
    
    def test_requirements_file(self):
        """Test that requirements.txt exists"""
        self.assertTrue(os.path.exists('requirements.txt'))
    
    def test_readme_file(self):
        """Test that README.md exists"""
        self.assertTrue(os.path.exists('README.md'))
    
    def test_license_file(self):
        """Test that LICENSE exists"""
        self.assertTrue(os.path.exists('LICENSE'))

if __name__ == '__main__':
    unittest.main()

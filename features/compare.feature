 #coding: utf-8
 Feature:Compare

   Scenario: Compare screenshots
     Given Im on main qasquad page
     When I take screenshot
     And Compare screenshots
     Then I should see difference not more than "3" percent
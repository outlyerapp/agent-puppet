Dataloop-agent Puppet Module
============================
This is a puppet module that installs the dataloop-agent on a host. It makes use of the puppetlabs apt module and the dataloop.io public yum and apt repositories.

Requirements
------------
* Tested on puppet 3.7.3
* Puppetlabs-apt module

Platforms
---------
* Ubuntu 10.04, 12.04, 14.04
* Rhel/Centos >= 6

Usage
-----
If you don't already have it, import the puppetlabs-apt module to your puppet repository

`#> puppet module install puppetlabs-apt --version 1.7.0`

And import this dataloop-agent module

`#> puppet module install --module_repository https://github.com/dataloop/dataloop-puppet dataloop-agent`

Add the dataloop-agent module to your node's run list and pass in the api_key for your dataloop.io account so that your servers can communicate back.

```
class { 'dataloop_agent': 
  api_key => 'fa970ce7-de56-4b98-915f-bb7d828c68d2'
}
```

Tags
---
After the agent has run once (to generate a fingerprint) you can run the following command to add tags.

```
#> /usr/bin/dataloop-agent -a [api key] -s https://www.dataloop.io --add-tags [tag1,tag2,tag3]
```

You can sprinkle these around your various modules so that dataloop dynamically updates on puppet runs. You can also use --remove-tags to take tags away.

Testing
-------
Testing for this module has been setup with Librarian-puppet and Test-Kitchen utilising vagrant as the machine provider.

Clone the repository, install the Gems (gem file to come), update the api_key in _manifests/test_site.pp_ and run kitchen test.

```
#> bundle install
#> kitchen test
```

Contributing
------------
Pull requests welcome.

License and Authors
-------------------
Author: Tom Ashley <tom.ashley@dataloop.io>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

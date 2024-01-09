Project Templates
=================

Usage
-----

To install a given template:

.. code-block:: bash

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ \
        -t <TEMPLATE_NAME> \
        -s <SUBSTITUTE_CONTENT>

For example, to create a CocoaPods plugin named `cocoapods-foo`:

.. code-block:: bash

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ \
        -t cocoapods-plugin \
        -s '{"name": "cocoapods-foo"}'

Available Templates
-------------------

.. list-table::
    :header-rows: 1

    * -  Template
      -  Code

    * -  py-package
      -  .. code-block:: bash

            bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ \
                -t py-package \
                -s '{"name": "foo"}'

    * - rb-gem
      - .. code-block:: bash

            bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ \
                -t rb-gem \
                -s '{"name": "foo"}'

    * - cocoapods-plugin
      - .. code-block:: bash

            bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ \
                -t cocoapods-plugin \
                -s '{"name": "foo"}'

    * - linters
      - .. code-block:: bash

            bash -c "$(curl -fsSL https://raw.githubusercontent.com/trinhngocthuyen/templates/HEAD/install.sh)" _ \
                -t linters

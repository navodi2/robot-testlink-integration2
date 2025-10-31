from testlink import TestlinkAPIClient
import xml.etree.ElementTree as ET
import re

# --- CONFIGURE THESE ---
tl_url = "http://localhost/testlink/lib/api/xmlrpc/v1/xmlrpc.php"
tl_devkey = "6cff669b0e50b188554ab6c7bde7c5d5"
test_plan = "Login Functionality Regression"
build_name = "Build 1.0"

tlc = TestlinkAPIClient(tl_url, tl_devkey)

tree = ET.parse('results/output.xml')
root = tree.getroot()

for test in root.findall('.//test'):
    name = test.get('name')
    status = test.find('.//status').get('status')
    match = re.search(r'WALP-(\d+)', name)
    if match:
        external_id = "TC-" + match.group(1)
        print(f"Reporting {external_id} → {status}")
        tlc.reportTCResult(
            external_id,
            test_plan,
            'p' if status == 'PASS' else 'f',
            buildname=build_name,
            notes="Automated Robot Framework test result"
        )

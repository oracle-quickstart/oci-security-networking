# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

import io
import json
import logging
import oci
import requests

from fdk import response


def handler(ctx, data: io.BytesIO = None):
    try:
        logging.getLogger().info("Function executing...")
        signer = oci.auth.signers.get_resource_principals_signer()
        config = dict(ctx.Config())
        if "SECRET_OCID" not in config.keys():
            logging.getLogger().error("Function was not able to retrieve secret. SECRET_OCID is not provided.")
            return response.Response(ctx, response_data=json.dumps({"Outcome": "FAILURE - SECRET_OCID is not provided."}), headers={"Content-Type": "application/json"})
        if "REGION" in config.keys():
            logging.getLogger().info("Invoking function in region: " + config["REGION"])
            secret_value = get_secret_value_from_provided_region(signer, config["SECRET_OCID"], config["REGION"])
        else:    
            secret_value = get_secret_value(signer, config["SECRET_OCID"])
        logging.getLogger().info("Function was able to retrieve secret.")
        return response.Response(ctx, response_data=json.dumps({"Outcome": "SUCCESS"}), headers={"Content-Type": "application/json"})
    except Exception as e:
        logging.getLogger().error("Exception: unexpected: " + str(e))  
        return response.Response(ctx, response_data=json.dumps({"Outcome": "FAILURE - {0}".format(str(e))}), headers={"Content-Type": "application/json"})   
    

def get_secret_value(signer,secret_ocid):
    secrets_client = oci.secrets.SecretsClient({}, signer=signer)
    response = secrets_client.get_secret_bundle(secret_id=secret_ocid)
    secret_content = response.data.secret_bundle_content.content
    return secret_content

def get_secret_value_from_provided_region(signer, secret_ocid, region):
    endpoint = f"https://secrets.vaults.{region}.oci.oraclecloud.com/20190301/secretbundles/{secret_ocid}"
    logging.getLogger().info("Invoking endpoint: " + endpoint)
    response = requests.get(endpoint, auth=signer)
    if response.status_code == 200:
        secret_content = response.json().get("secretBundleContent", {}).get("content")
        return secret_content  
    else:
        raise Exception(f"Failed to retrieve secret: {response.status_code} - {response.text}")
      
    


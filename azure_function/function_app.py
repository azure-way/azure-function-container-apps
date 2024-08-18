import azure.functions as func
import datetime
import json
import logging

app = func.FunctionApp()

@app.blob_trigger(arg_name="myblob", path="data", connection="IndexDataStorageConnection") 

def BlobTrigger(myblob: func.InputStream):
    logging.info(f"Python blob trigger function processed blob"
                f"Name: {myblob.name}"
                f"Blob Size: {myblob.length} bytes")
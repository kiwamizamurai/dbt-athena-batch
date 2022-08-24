{{
    config(
        materialized='table',
        format='textfile',
        external_location='s3://hogehoge-bucket/athena_output_location/interface/sample/'
    )
}}


select col1 from {{source('raw', 'sample')}}
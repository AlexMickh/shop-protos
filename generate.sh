#!/bin/bash

PROTO_DIR="./proto"

FILES=$(find "$PROTO_DIR" -name "*.proto")

for file in $FILES
do
    IFS='/'
    read -ra path_array <<< "$file"
    folder=${path_array[2]}
    file_name=${path_array[3]}

    rm -rf ./gen/go/$folder
    mkdir -p ./gen/go/$folder

    protoc --go_out=./gen/go/$folder --go_opt=paths=source_relative --go-grpc_out=./gen/go/$folder --go-grpc_opt=paths=source_relative ./proto/$folder/$file_name
    mv ./gen/go/$folder/proto/$folder/${folder}_grpc.pb.go ./gen/go/$folder/${folder}_grpc.pb.go
    mv ./gen/go/$folder/proto/$folder/$folder.pb.go ./gen/go/$folder/$folder.pb.go
    rm -rf ./gen/go/$folder/proto

    echo "generate for $file_name"
done

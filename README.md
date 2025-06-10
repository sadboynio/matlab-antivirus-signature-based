# Signature-Based Antivirus in MATLAB

This project implements a basic signature-based antivirus system in MATLAB, leveraging TLSH (Trend Micro Locality Sensitive Hash) for similarity-based threat detection.

## Features

* Signature-based detection using TLSH hashes, and analyze HEX inside each file.
* Modular and extensible hash list.
* JSON-based threat database structure for easy integration and modification.

## Getting Started

1. Clone the repository.
2. Open the project in MATLAB.
3. Provide the folder path you want to scan.
4. Add your own TLSH or hex signatures to enhance detection capabilities.

> **Note**: Both TLSH and hex detection use the same signature list. You can modify or replace the list with your own as needed.

## TLSH Tool Installation

This project uses TLSH from Trend Micro. To install:

```bash
wget https://github.com/trendmicro/tlsh/archive/master.zip -O master.zip
unzip master.zip
cd tlsh-master
./make.sh
```

## Sample Malware Signatures

For testing, you can use this sample database of TLSH signatures:

* [Open Threat Database](https://github.com/VISWESWARAN1998/open-threat-database/tree/master/threat_db)

Or, feel free to create your own TLSH signature set.

## TLSH Hash Format

Each signature should be structured in JSON format as shown below:

```json
{
  "tlsh": "YOUR_TLSH_HASH_HERE"
}

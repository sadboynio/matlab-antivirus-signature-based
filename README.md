# Signature-based Antivirus in MATLAB

This project implements a basic signature-based antivirus system using MATLAB. It leverages TLSH (Trend Micro Locality Sensitive Hash) to detect known threats based on similarity hashing.

## Features

- Signature-based detection using TLSH hashes.
- Modular hash list for easy extension.
- JSON-based threat database structure.

## Getting Started

1. Clone the repository.
2. Open the project in MATLAB.
3. Write folder path for AV to detect
4. Add your own TLSH hashes to enhance detection capabilities.

### TLSH Hash Format

All hashes should follow the format below and be added inside a JSON file:

```json
{
  "tlsh": "YOUR_TLSH_HASH_HERE"
}

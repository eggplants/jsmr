# jsmr

Analyze [Japanese ASMR](https://japaneseasmr.com) - a site that illegally uploads DLSite voice works.

## Motivation

All files uploaded there are apparently illegal.
So, I am going to report collected infomation to DLSite.
Report form is [here](https://www.dlsite.com/home/opinion/illegal/upload).

## Requirement

- curl

## Run

```bash
./get_info.sh -y
< zippy_lis ./get_dl.sh z
< anon_lis ./get_dl.sh a
```

## Description of files

- `get_info.sh`: Analyze [Japanese ASMR](https://japaneseasmr.com) and get download links on [Zippyshare](https://www.zippyshare.com/) & [AnonFiles](https://anonfiles.com/)

  - `ar_lis_nums`: Indexes of each page on [Japanese ASMR](https://japaneseasmr.com)
  - `RJ_lis`: WORK IDs (`RJXXXXX`) of the DLSite work uploaded on [Japanese ASMR](https://japaneseasmr.com)
  - `zippy_lis`: Links of the download page on [Zippyshare](https://www.zippyshare.com/)
  - `anon_lis`: Links of the download page on [AnonFiles](https://anonfiles.com/)

- `get_dl.sh`: Get links to download the content directly
  - `zippy_dl_lis`: Links of the contents on [Zippyshare](https://www.zippyshare.com/)
    - Note: After obtaining, these links will be changed and disabled immediately
  - `anon_dl_lis`: Links of the contents on [AnonFiles](https://anonfiles.com/)

#!/usr/bin/env bash

marco() {
  echo "$PWD" > /tmp/work_dic
}

polo() {
  cd $(cat /tmp/work_dic)
}

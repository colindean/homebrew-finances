#!/usr/bin/env bash

set -eux -o pipefail

for collective in brew homebrew; do
    output_file="${collective}.csv"
    if [[ ! -f "${output_file}" ]]; then
        curl -o "${output_file}" "https://rest.opencollective.com/v2/${collective}/transactions.csv?fetchAll=1&includeGiftCardTransactions=1&includeIncognitoTransactions=1&includeChildrenTransactions=1&kind=ADDED_FUNDS%2CCONTRIBUTION%2CEXPENSE%2CHOST_FEE%2CPAYMENT_PROCESSOR_FEE%2CPAYMENT_PROCESSOR_COVER&fields=datetime%2CshortId%2CshortGroup%2Cdescription%2Ctype%2Ckind%2CisRefund%2CisRefunded%2CshortRefundId%2CdisplayAmount%2Camount%2CpaymentProcessorFee%2CnetAmount%2Cbalance%2Ccurrency%2CaccountSlug%2CaccountName%2CoppositeAccountSlug%2CoppositeAccountName%2CpaymentMethodService%2CpaymentMethodType%2CexpenseType%2CexpenseTags%2CpayoutMethodType%2CmerchantId%2CorderMemo"
    fi
done

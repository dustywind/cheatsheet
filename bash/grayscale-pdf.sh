

gs \
    -sDEVICE=pdfwrite \
    -sColorConversionStrategy=Gray \
    -dProcessColorModel=/DeviceGray \
    -dNOPAUSE \
    -o "$1"-bw.pdf \
    $1


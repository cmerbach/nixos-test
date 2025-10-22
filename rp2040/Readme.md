go mod init rp2040

(go mod tidy rp2040)

tinygo build -target=pico -o pico.uf2 .

tinygo flash -target=pico .

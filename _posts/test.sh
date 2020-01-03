ssh -p 8022 u0_a213@10.0.0.244 << EOF
    termux-camera-photo -c 0 test.jpg
EOF
sftp -P 8022 u0-a213@10.0.0.244 << EOF
    get test.jpg
EOF

function base64-md5 -d "base64 encode the MD5 from a file"

openssl dgst -md5 -binary $argv | openssl enc -base64

end

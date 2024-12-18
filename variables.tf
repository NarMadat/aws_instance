variable "vpc_cidr" {
  type = string
  default = "10.127.0.0/16"
}

variable "public_cidrs" {
  type = list(string)
  default = [ 
    "10.127.1.0/24",
    "10.127.3.0/24" 
  ]
}

variable "private_cidrs" {
  type = list(string)
  default = [ 
    "10.127.2.0/24",
    "10.127.4.0/24"
   ]
}

variable "main_vol_size" {
  type = number
  default = "8"
}

variable "key_name" {
  type=string
}

variable "public_key_path" {
  type=string 
}
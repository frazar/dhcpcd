# Lookup the hostname in DNS if not set

lookup_hostname()
{
	local h=
	# Silly ISC programs love to send error text to stdout
	if type dig >/dev/null 2>&1; then
		h=`dig +short -x ${new_ip_address}`
		if [ $? = 0 ]; then
			echo "${h}" | sed 's/\.$//'
			return 0
		fi
	elif type host >/dev/null 2>&1; then
		h=`host ${new_ip_address}`
		if [ $? = 0 ]; then 
			echo "${h}" \
			| sed 's/.* domain name pointer \(.*\)./\1/'
			return 0
		fi
	fi
	return 1
}

set_hostname()
{
	if [ -z "${new_host_name}" ]; then
		export new_host_name="$(lookup_hostname)"
	fi
}

case "${reason}" in
	BOUND|INFORM|REBIND|REBOOT|RENEW|TIMEOUT)	set_hostname;;
esac

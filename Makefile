# Copyright (c) 2015-2023 Franco Fichtner <franco@opnsense.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

STEPS=		audit arm base boot chroot clean clone compress confirm \
		connect core distfiles download dvd fingerprint info \
		kernel list make.conf nano options packages plugins ports \
		prefetch print rebase release rename serial sign \
		skim test update upload verify vga vm xtools
SCRIPTS=	custom distribution factory hotfix nightly watch

.PHONY:		${STEPS} ${SCRIPTS}

PAGER?=		less

.MAKE.JOB.PREFIX?=	# tampers with some of our make invokes

all:
	@cat ${.CURDIR}/README.md | ${PAGER}

lint-steps:
.for STEP in common ${STEPS}
	@sh -n ${.CURDIR}/build/${STEP}.sh
.endfor

lint-composite:
.for SCRIPT in ${SCRIPTS}
	@sh -n ${.CURDIR}/composite/${SCRIPT}.sh
.endfor

lint: lint-steps lint-composite

# Special vars to load early build.conf settings:

ROOTDIR?=	/usr

TOOLSDIR?=	${ROOTDIR}/tools
TOOLSBRANCH?=	main

.if defined(CONFIGDIR)
_CONFIGDIR=	${CONFIGDIR}
.elif defined(SETTINGS)
_CONFIGDIR=	${TOOLSDIR}/config/${SETTINGS}
.elif !defined(CONFIGDIR)
__CONFIGDIR!=	find -s ${TOOLSDIR}/config -name "build.conf" -type f
.for DIR in ${__CONFIGDIR}
. if exists(${DIR}) && empty(_CONFIGDIR)
_CONFIGDIR=	${DIR:C/\/build\.conf$//}
. endif
.endfor
.endif

.-include "${_CONFIGDIR}/build.conf.local"
.include "${_CONFIGDIR}/build.conf"

# Bootstrap the build options if not set:

NAME?=		Veritawall
PUBKEY?=\
-----BEGIN PUBLIC KEY-----\n\
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4vZ5BI/r93Kuhmehz9//\n\
2LCiFUNw7HFN3q9BlDaUHvf0dCC0MIWCHT+OuCdM1+odHhk7BMmCQacIApa+7RA4\n\
qMmNQ3cjput5KSrF/DnyFiHGadbRFb2K/KlSljsB4Ky1X7qicmsQEuGHgceatw7Z\n\
u8mDsp5Zz+xRrQVfPHBQeBq4TGeENVqp2oKPIbtnd1TKZOGhGpEMT5KxXx0IUl8N\n\
1H9ywiaL0r3saUBLYUEmpBnd0B1xetFpn9FpLT9B85uW0yWWkiUO9Kt0Q2+6MD82\n\
RJjgBGaB3scXhW/WUCMU4UF/VL5D03AVnfi8ctJmODp9vmU97UTFEA+kHbvZZbcG\n\
+QIDAQAB\n\
-----END PUBLIC KEY-----\n\

PRIVKEY?=\
-----BEGIN RSA PRIVATE KEY-----\n\
MIIEpAIBAAKCAQEA4vZ5BI/r93Kuhmehz9//2LCiFUNw7HFN3q9BlDaUHvf0dCC0\n\
MIWCHT+OuCdM1+odHhk7BMmCQacIApa+7RA4qMmNQ3cjput5KSrF/DnyFiHGadbR\n\
Fb2K/KlSljsB4Ky1X7qicmsQEuGHgceatw7Zu8mDsp5Zz+xRrQVfPHBQeBq4TGeE\n\
NVqp2oKPIbtnd1TKZOGhGpEMT5KxXx0IUl8N1H9ywiaL0r3saUBLYUEmpBnd0B1x\n\
etFpn9FpLT9B85uW0yWWkiUO9Kt0Q2+6MD82RJjgBGaB3scXhW/WUCMU4UF/VL5D\n\
03AVnfi8ctJmODp9vmU97UTFEA+kHbvZZbcG+QIDAQABAoIBAQDU9+Jm3YXWE86g\n\
X+3+WXqBonz05uu3cjpXkqw+n1guFw1TSrzKKv0E5PbO5lG86PmZnKM8wrlvUYS6\n\
qSlO2cHQ4A+mFs1le9+dOX2+R8FZ8ydzeReJBuq8W0YbohMI+AbZZQ+5vay/itDU\n\
frA2xcCZ7WWe3ef4qw+ZA0lyNRHNH8D8dGc6KYeH4GR4oDb9pTIC3ZuifqbJGw/t\n\
8J/1zmXjpc/jWmT6YbUsZFfObkcNDrlp8Tk7f94CqKJJkxFs/48kSk7Arv8zZdmC\n\
v7hYLQvJfz8avDyLkqG+j8BSRzZHm1CMU8vkZm1Fg82NmfWL8XMECWPfq71B0V4g\n\
vY+s3YQBAoGBAPc04X/5mpI5nqQOcqauNTmH+mXvk6QNMSbvXwALLxhfbM9nCwRf\n\
WuysJ2/ZdlWcLTJ35HDeW9yAIwP+2GoihyVauNte7UhfiKfK2FhIgI/JcCZXhb6u\n\
FhMzHois2uCJDEod2imBg+waHqJO/lVmvSHOqJmdOVVBT5oHpKZKwC1xAoGBAOsJ\n\
P1UQ0dXy+4MQ3eswcezyBNf9wUG6kFO/s1FI5IMeotvMscpvupZxSw+a0PRrCx1W\n\
g2NVuBWWvrn2IXXfVFWc87qWke1nY9Gp8PRfR6zyq7yZA/d6By7Pqe1Zt7vb+yj+\n\
ZB5ZTl2eKCbKC6snLrOqv4GbRxhdOdym+f2+bU4JAoGBAIWORVJNuQvNI39A6wJQ\n\
ViMZ6tdNwzc7hVWit3GfmTcSvweihRo8pjP9omTUWRFRij2c9odgKsMLW1+aPLPC\n\
qb8tr3edZpbWPk9g0NeJfCOy0et1F6X4Cacf1BxFPw9WG5SjYi1QcsSJLAnGobPk\n\
CMSOERrFDaeY3He8L2FEO2WRAoGAPVYxd/KmwC3kI0UwlOMUqCBU0UVAvPWCGskJ\n\
c+oQ8IL7P19A+rKDwCUa0Jy3cUHKKcLdEPxayQ+JAKDSBJ/es2T9WjFXLdxweVPf\n\
NPb0jpbZ6KMKHPh0jWvWTcG/KEB1YDJbUGw//kB6+/x4ZRcZofuqdJlgSWRy6DmP\n\
PgAHKHkCgYAVqDIxT7H260snwSbeyvbj8Z7T7ELm25qqWj5e1y+w2OQV5V6GuBke\n\
rrnia6U9s9Rb6o+uNbxryxRxrMF7AcfL63ZRruHnMrnx7XG3C6L851km8ky1UXTy\n\
plzPDIEUTbo0O8PqBZMPH4wCdz52RA2L0QsFAV3fy4eJ7N1pPAPXNA==\n\
-----END RSA PRIVATE KEY-----\n\

TYPE?=		${NAME:tl}
SUFFIX?=	# empty
_ARCH!=		uname -p
ARCH?=		${_ARCH}
ABI?=		${_CONFIGDIR:C/^.*\///}
KERNEL?=	SMP
ADDITIONS?=	# empty
DEBUG?=		# empty
DEVICE?=	A10
COMSPEED?=	115200
UEFI?=		arm dvd serial vga vm
ZFS?=		# empty
GITBASE?=	https://github.com/vw-fw
MIRRORS?=	no #https://opnsense.c0urier.net \
		#https://mirrors.nycbug.org/pub/opnsense \
		#https://mirror.wdc1.us.leaseweb.net/opnsense \
		#https://mirror.sfo12.us.leaseweb.net/opnsense \
		#https://mirror.fra10.de.leaseweb.net/opnsense \
		#https://mirror.ams1.nl.leaseweb.net/opnsense
SERVER?=	user@does.not.exist
UPLOADDIR?=	.
_VERSION!=	date '+%Y%m%d%H%M'
VERSION?=	${_VERSION}
STAGEDIRPREFIX?=/usr/obj

EXTRABRANCH?=	# empty

COREBRANCH?=	main
COREVERSION?=	# empty
COREDIR?=	${ROOTDIR}/core
COREENV?=	CORE_PHP=${PHP} CORE_ABI=${ABI} CORE_PYTHON=${PYTHON}

PLUGINSBRANCH?=	main
PLUGINSDIR?=	${ROOTDIR}/plugins
PLUGINSENV?=	PLUGIN_PHP=${PHP} PLUGIN_ABI=${ABI} PLUGIN_PYTHON=${PYTHON}

PORTSBRANCH?=	main
PORTSDIR?=	${ROOTDIR}/ports
PORTSENV?=	# empty

PORTSREFURL?=	https://git.FreeBSD.org/ports.git
PORTSREFDIR?=	${ROOTDIR}/freebsd-ports
PORTSREFBRANCH?=main

SRCBRANCH?=	main
SRCDIR?=	${ROOTDIR}/src

# A couple of meta-targets for easy use and ordering:

kernel ports distfiles: base
audit plugins: ports
core: plugins
packages test: core
arm dvd nano serial vga vm: kernel core
sets: kernel distfiles packages
images: dvd nano serial vga vm
release: dvd nano serial vga

# Expand target arguments for the script append:

.for TARGET in ${.TARGETS}
_TARGET=	${TARGET:C/\-.*//}
.if ${_TARGET} != ${TARGET}
.if ${SCRIPTS:M${_TARGET}}
${_TARGET}_ARGS+=	${TARGET:C/^[^\-]*(\-|\$)//}
.else
${_TARGET}_ARGS+=	${TARGET:C/^[^\-]*(\-|\$)//:S/,/ /g}
.endif
${TARGET}: ${_TARGET}
.endif
.endfor

.if "${VERBOSE}" != ""
VERBOSE_FLAGS=	-x
.else
VERBOSE_HIDDEN=	@
.endif

.for _VERSION in ABI DEBUG LUA PERL PHP PYTHON RUBY SSL VERSION ZFS
VERSIONS+=	PRODUCT_${_VERSION}=${${_VERSION}}
.endfor

# Expand build steps to launch into the selected
# script with the proper build options set:

.for STEP in ${STEPS}
${STEP}: lint-steps
	${VERBOSE_HIDDEN} cd ${.CURDIR}/build && \
	    sh ${VERBOSE_FLAGS} ./${.TARGET}.sh -a ${ARCH} -F ${KERNEL} \
	    -n ${NAME} -v "${VERSIONS}" -s ${_CONFIGDIR} \
	    -S ${SRCDIR} -P ${PORTSDIR} -p ${PLUGINSDIR} -T ${TOOLSDIR} \
	    -C ${COREDIR} -R ${PORTSREFDIR} -t ${TYPE} -k "${PRIVKEY}" \
	    -K "${PUBKEY}" -l "${SIGNCHK}" -L "${SIGNCMD}" -d ${DEVICE} \
	    -m ${MIRRORS:Ox:[1]} -o "${STAGEDIRPREFIX}" -c ${COMSPEED} \
	    -b ${SRCBRANCH} -B ${PORTSBRANCH} -e ${PLUGINSBRANCH} \
	    -g ${TOOLSBRANCH} -E ${COREBRANCH} -G ${PORTSREFBRANCH} \
	    -H "${COREENV}" -u "${UEFI:tl}" -U "${SUFFIX}" \
	    -V "${ADDITIONS}" -O "${GITBASE}"  -r "${SERVER}" \
	    -h "${PLUGINSENV}" -I "${UPLOADDIR}" -D "${EXTRABRANCH}" \
	    -A "${PORTSREFURL}" -J "${PORTSENV}" ${${STEP}_ARGS}
.endfor

.for SCRIPT in ${SCRIPTS}
${SCRIPT}: lint-composite
	${VERBOSE_HIDDEN} cd ${.CURDIR} && \
	    sh ${VERBOSE_FLAGS} ./composite/${SCRIPT}.sh ${${SCRIPT}_ARGS}
.endfor

_OS!=	uname -r
_OS:=	${_OS:C/-.*//}
.if "${_OS}" != "${OS}"
.error Expected OS version ${OS} for ${_CONFIGDIR}; to continue anyway set OS=${_OS}
.endif

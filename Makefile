STEPS=		base kernel ports core iso memstick nano \
		regress clean release
.PHONY:		${STEPS}

PAGER?=		less

all:
	@cat ${.CURDIR}/README.md | ${PAGER}

# Load the custom options from a file:

.if defined(CONFIG)
.include "${CONFIG}"
.endif

# Bootstrap the build options if not set:

NAME?=		OPNsense
FLAVOUR?=	OpenSSL
_VERSION!=	date '+%Y%m%d%H%M'
VERSION?=	${_VERSION}

# A couple of meta-targets for easy use:

source: base kernel
packages: ports core
sets: source packages
images: iso memstick nano
everything: sets images

# Expand target arguments for the script append:

.for TARGET in ${.TARGETS}
_TARGET=	${TARGET:C/\-.*//}
.if ${_TARGET} != ${TARGET}
${_TARGET}_ARGS+=	${TARGET:C/^[^\-]*(\-|\$)//:S/,/ /g}
${TARGET}: ${_TARGET}
.endif
.endfor

# Expand build steps to launch into the selected
# script with the proper build options set:

.for STEP in ${STEPS}
${STEP}:
	@cd build && sh ./${.TARGET}.sh \
	    -f ${FLAVOUR} -n ${NAME} -v ${VERSION} ${${STEP}_ARGS}
.endfor

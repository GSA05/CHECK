#-------------------------------------------------
#
# Project created by QtCreator 2015-03-10T14:58:44
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = CHECK
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += main.cpp \
    rpcalc.cpp \
    lex.macsin.c

OTHER_FILES += \
    rpcalc.y \
    calc.y \
    ltcalc.y \
    mfcalc.y \
    macsin.l

HEADERS += \
    rpcalc.hpp \
    calc.h

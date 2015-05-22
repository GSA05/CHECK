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
    lex.macsin.c \
    macsin.tab.c

OTHER_FILES += \
    macsin.l \
    macsin.y

HEADERS += \
    macsin.tab.h \
    main.h

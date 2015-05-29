TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += main.cpp \
    controller.cpp \
    model.cpp \
    macsin/macsin_controller.cpp \
    macsin/macsin_parser.tab.cc \
    macsin/lex.macsin.cc

HEADERS += \
    controller.h \
    model.h \
    macsin_controller.h \
    macsin/macsin_controller.h \
    macsin/location.hh \
    macsin/macsin_parser.tab.hh \
    macsin/position.hh \
    macsin/stack.hh

OTHER_FILES += \
    macsin/macsin_parser.yy \
    macsin/macsin_scanner.ll

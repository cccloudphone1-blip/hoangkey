#pragma once
#define IDI_APP 101
#define IDR_SOUND_VI 201
#define IDR_SOUND_EN 202
#define IDR_EMOJI_JSON 203
#ifndef VIKEY_VERSION
#define VIKEY_VERSION "1.0.31"
#endif
#ifndef VIKEY_BUILD
#define VIKEY_BUILD "31"
#endif
#ifndef _MSC_VER
#define VIKEY_W2(x) L"" x
#else
#define VIKEY_W2(x) L##x
#endif
#define VIKEY_W(x) VIKEY_W2(x)
#define VIKEY_VERSION_W VIKEY_W(VIKEY_VERSION)

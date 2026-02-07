/**
 * AfkPreventer - Native DLL for WoW 1.12.1 / Turtle WoW
 * Loads via dlls.txt (VanillaFixes, Turtle WoW loader).
 * When loaded into WoW's process, writes GetTickCount() to the AFK timer
 * address every 10 seconds to prevent AFK kicks.
 *
 * Memory address 0x00CF0BC8: AFK timer (1.12.1 engine, used by Turtle WoW 1.17.x)
 */

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>

namespace {

const DWORD AFK_TIMER_ADDRESS = 0x00CF0BC8;
const DWORD RESET_INTERVAL_MS = 10000;

DWORD WINAPI AfkPreventerThread(LPVOID)
{
    while (true)
    {
        Sleep(RESET_INTERVAL_MS);
#ifdef _MSC_VER
        __try
        {
#endif
            volatile DWORD* pAfkTimer = reinterpret_cast<volatile DWORD*>(AFK_TIMER_ADDRESS);
            *pAfkTimer = GetTickCount();
#ifdef _MSC_VER
        }
        __except (EXCEPTION_EXECUTE_HANDLER)
        {
            break;
        }
#endif
    }
    return 0;
}

} // namespace

BOOL APIENTRY DllMain(HMODULE hModule, DWORD reason, LPVOID lpReserved)
{
    (void)hModule;
    (void)lpReserved;

    if (reason == DLL_PROCESS_ATTACH)
    {
        DisableThreadLibraryCalls(hModule);
        CreateThread(nullptr, 0, AfkPreventerThread, nullptr, 0, nullptr);
    }
    return TRUE;
}

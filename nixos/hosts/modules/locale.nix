{ hostSettings, ... }:
{
    time.timeZone = hostSettings.timezone;

    console.keyMap = hostSettings.consoleKeymap;

    i18n.defaultLocale = hostSettings.locale;

    i18n.extraLocaleSettings = {
        LC_ADDRESS = hostSettings.locale;
        LC_IDENTIFICATION = hostSettings.locale;
        LC_MEASUREMENT = hostSettings.locale;
        LC_MONETARY = hostSettings.locale;
        LC_NAME = hostSettings.locale;
        LC_NUMERIC = hostSettings.locale;
        LC_PAPER = hostSettings.locale;
        LC_TELEPHONE = hostSettings.locale;
        LC_TIME = hostSettings.locale;
    };
}

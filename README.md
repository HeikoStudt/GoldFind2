# GoldFind 2
GoldFind 2 - Hamster search and statistic tool

I originally programmed this software around the year 2000 basing upon AgtFind
(by Juergen Haible). This version does use OLE calling the Hamster API.
Therefore, this util is very(!) slow and very reliant on Hamster.

In those years I've compiled with Delphi 5 having some Extensions (RxLib, Tx, perhaps more).

There is a newer version GoldFind 3.1.* I will upload as well.


# Old ToDo-List (German)

Bug:
last days nicht gespeichert/geladen?

Stimmt. Jetzt wäre es schön, wenn nicht nur die Spalten, sondern auch 
dieses Panel die eingestellte Größe behalten würde.

Mail-Daten durchsuchen

Farben der Graphen: In einem Array festlegen.

Message-ID/Mail abfragen Popup-Menu ToDo: OnClick

Net-DDE: http://www.delphi3000.com/articles/article_371.asp

DSF (didi's standard-floskeln) // ROFL/LOL/AFAIK
> Die Übersetzungen sollten nur ein Spass am Rande rein. Bei mir werden sie
> bei Shift+MouseLeft aber wirklich übersetzt.

Spaces statt Tabs  Todo: DAU, Header, Path (rel|Feed|Of)

Graph nach CSV exportieren
Graph als "Torte"

Größenverhältnisse des Gruppen-Fensters.
Such-Paramter von Configuration wieder in's Such-Panel
Configuration ohne Reiter?
Font der Richedits direkt erreichbar, oder zumindestens Fix-Pitch (2 Fonts?)
Datum umgekehrt richtig interpretieren. Von 1.4 bis 1.3 > Er könnte aber erkennen, dass April 2002 in der Zukunft liegt!!
> Jetzt habe ich aus versehen Statistik gedrückt... Stop klappt nicht...

Alle-Postings werden durchsucht:
> Ein Index, welches im Hintergrund erstellt würde, wäre auch
> hilfreich und würde kaum Speicher verbrauchen.

> Neue Suche: 01.04.20002 bis ... - Setzt von und bis auf Now und fängt am Anfang an.
Vielleicht sollte er mit einfachem Beep und Messagebox "Datum flashc"
abbrechen? ACK.

"*"/"?" etc pp in das Suchparsing einbauen.

zum senden einer E-Mail: 
  ShellExecute(Application.MainForm.Handle, NIL, 'mailto:Name@domain','','', SW_SHOWNORMAL);



Stati: Zeilen/Bytes (pro Person.)
Original/Zitiert
F'up2: wohin; von wem; wieviel


Announces:
<forward@cawgod.com>
Holger Kremb
Mathias Behrle <exp311201@gmx.de>
Wolfgang Krietsch <xwoffi@gmx.de>



Wishes:
> könntest Du noch einbauen, daß es zu jedem Poster den verwendeten 
> Newsreader ausgeben kann?

---
[RegEx-Fragen]

Dann hätte ich auch noch eine Frage:
Bei den Statistiken kann ja beim DAU sowohl für alle als auch für einen
einzelnen Poster eine Statistik erstellt werden. Wäre so etwas auch für
die anderen möglich? So daß man eine Liste der Threads einer oder
bestimmbarer Personen bekommt oder eine Übersicht über messages per xy
_einer_ Person? Falls das doch möglich ist, war ich bisher unfähig, das
zu finden...
Und wenn ich schon dabei bin ;) interessant wäre auch eine Übersicht
nicht über Messages per User sondern über bytes per User; man könnte die
Viel-Schreiber besser von den Häufig-Schreibern unterscheiden (NEIN, ich
denke an niemand bestimmten ;-) )


Anja



Doku:

Halli Hallo,

ich habe da eine kleine COM-Server-DLL geschrieben, die lokal auch
funktioniert. Jetzt habe ich diesen Server auf einem zweiten Rechner
installiert (und natürlich auch registriert) und wollte diesen Server mit
dem Aufruf : "MeinServer := CoMeinServer.CreateRemote('ZweiterPC')"
instantiieren. Dabei wird allerdings die Exception "Klasse nicht
registriert" ausgelöst.

Bei dem Programm "DCOMCNFG" taucht dieser Server auch nicht in der Liste der
Anwendungen auf, was mich vermuten lässt, daß dort irgendwo der Fehler
liegt. Scheinbar reicht es nicht den Server mir "REGSVR32" in die Regisrty
einzutragen, kann das sein?

Grundsätzlich scheint DCOM richtig konfiguriert zu sein, da sich
beispielsweise Word über das Netzwerk auf dem jeweils anderen Rechner
ansprechen und auch verwenden lässt. Also scheinen zumindest die
Sicherheitseinstellungen für DCOM korrekt zu sein.

Kann mir jemand (schematisch) erklären, was man tun muss, damit ein
COM-Server über das Netz benutzbar wird? Muss eventuell schon beim erstellen
des Server etwas beachtet werden (Threading-Modell?) oder muss der
Server anders registriert werden?

Der Server wurde mit D5 Ent. erstellt und läuft auf beiden Rechnern auf
Win2K + SP 2. Auf beiden Rechnern wurde der Server mit "REGSVR32"
registriert und läuft jeweils lokal ohne Probleme.

Danke im voraus,
Ralf




VB-Runtime muß für DLL installiert sein.


# Original License (AgtFind & GoldFind Binaries)

============================================================================
AgtFind.
Copyright (c) 1996-2001, Juergen Haible (<juergen.haible@t-online.de>).
GoldFind
Copyright (c) 2002,      Heiko Studt (<Heiko.Studt@goldpool.org>).


Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
============================================================================

!  9"��2�!�!] ~� ���0+���)>2��F!e ~� �=��F���)\ � ���a:���n���!�"��4��g1�!�~�:��*���͛1�����}�*�����͊��@Gʨұ��Â�Ҩ*~��#��Â~#����
�����#~�:ʹ����Â*~͕#��~����n���� ����͊������_� ��������	� ����~�#�)�\ � �*�� ���)�"���~��a�
�b�#�O##͊:�=2���������A�n��}͕͊�>�>
��>2��!�͕>A2}l� ~�:����}:}�<2}>.�> ��Oî"~�͕�O~���:��������:�G��c����͊:�=2��-�����}͕�HELP V1.1
$   ++ EOI ++	Type CTRL-C to return to CP/M, <CR> to continue -$
  HELP File Selections are --
$ HELP    HLP   Type "A"=Abort, CTRL-C=CP/M, <CR>=Cont -$
HELP FATAL ERROR -- File not Found$
HELP ERROR -- Invalid Response
$
HELP ERROR -- EOF on HELP File
$
  Type CTRL-C to return to CP/M, "*" to select all, or enter selection - $ections are --
$ HELP    HLP   Type "A"=Abort, CTRL-C=CP/M, <CR>=Cont -$
HELP FATAL ERR:The HELP Subsystem for Online Documentation
     This is HELP, the Online Documentation Subsystem.
The purpose of HELP is to allow the user to interactively
query the *.HLP files of the system in order to receive
information summaries on various aspects of the user's
working environment, such as the language systems he is
using and certain subsystems available to him.

     When the user types 'HELP', a search is done
for the file 'HELP.HLP'.  If found, the contents of
this HELP File is displayed to the user; if not found,
the HELP Information you are now reading is displayed.

     If the user desires information on a specific
topic and he has a HELP File of that name (ie, CPM.HLP
is a HELP File on CP/M), he may issue of HELP Command
of the form --
               HELP d:topic
where "d:" is the disk the HELP File resides on (optional)
and "topic" is the name of the HELP File (topic.HLP,
like CPM.HLP).
     Please refer to the HELP File "HELP.HLP" for more information.
                                                             
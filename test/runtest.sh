let exit_rc=0

echo Test 1: Create and verify an archive
rm archive.yata 2>/dev/null
let my_rc=0
./yata -c -d ./in_data
let my_rc=$my_rc+$?
diff -u in_data/archive.yata archive.yata
let my_rc=$my_rc+$?
if [[ $my_rc != 0 ]] ; then echo Test failed
else echo Test passed
fi
let exit_rc=$exit_rc+$my_rc
rm archive.yata 2>/dev/null

echo Test 2: Extract and verify an archive
rm -rf out_data 2>/dev/null
mkdir out_data
let my_rc=0
./yata -x -f in_data/archive.yata -d ./out_data
let my_rc=$my_rc+$?
files=$(ls in_data/*.exec out_data/*.exec)
let my_rc=$my_rc+$?
for f in $files ; do
	f=`basename $f`
	diff -u in_data/$f out_data/$f
	let my_rc=$my_rc+$?
done
if [[ $my_rc != 0 ]] ; then echo Test failed
else echo Test passed
fi
let exit_rc=$exit_rc+$my_rc
rm -rf out_data 2>/dev/null

exit $exit_rc
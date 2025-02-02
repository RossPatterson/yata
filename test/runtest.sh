let exit_rc=0

echo Test 1: Create and verify an archive
rm archive.yata 2>/dev/null
./yata -c -d ./in_data
let rc=$?
if [[ $rc != 0 ]] ; then echo Test failed
fi
let exit_rc=$exit_rc+$rc
cmp in_data/archive.yata archive.yata
let rc=$?
if [[ $rc != 0 ]] ; then echo Test failed
fi
let exit_rc=$exit_rc+$rc
rm archive.yata 2>/dev/null

echo Test 2: Extract and verify an archive
rm -rf out_data 2>/dev/null
mkdir out_data
./yata -x -f in_data/archive.yata -d ./out_data
let rc=$?
if [[ $rc != 0 ]] ; then echo Test failed
fi
let exit_rc=$exit_rc+$rc
files=$(ls in_data/*.exec out_data/*.exec)
if [[ $rc != 0 ]] ; then echo Test failed
fi
let exit_rc=$exit_rc+$rc
for f in $files ; do
	f=`basename $f`
	cmp in_data/$f out_data/$f
	let rc=$?
	if [[ $rc != 0 ]] ; then echo Test failed
	fi
	let exit_rc=$exit_rc+$rc
done
rm -rf out_data 2>/dev/null

exit $exit_rc
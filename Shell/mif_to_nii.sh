
filenamesD=`ls *.mif`
for eachfile in $filenamesD
do
echo "${eachfile%%.*}"

mrconvert ${eachfile%%.*}".mif" ${eachfile%%.*}".nii"

done



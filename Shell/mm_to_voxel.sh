
filenamesD='ls *.tck'
for eachfile in $filenamesD
do
echo "${eachfile%%.*}"

tckconvert -scanner2voxel fod.mif ${eachfile%%.*}".tck" ${eachfile%%.*}"_vox.tck" -force

done

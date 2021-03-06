echo "type:"
read type
echo "arg1:"
read arg1
echo "arg2:"
read arg2
echo "arg3:"
read arg3
echo "vertices edges iter_count elapsed_time" > "experiment-range-$arg1-$arg2-$arg3-all"
for ((i = 1; i <= 100; i++))
do
  for ((j = 0; j < 10; j++))
  do
    echo "Execution $j"
    range=$(echo "$arg3 * $i / 100" | bc)
    ./gengraph $type $arg1 $arg2 $range "test-range-$type-$arg1-$arg2-$arg3.gr"
    ./ford-fulkerson < "test-range-$type-$arg1-$arg2-$arg3.gr" 2>> "run.tmp"
    rm "test-range-$type-$arg1-$arg2-$arg3.gr"
  done
  limU=$(awk '{x+=$1;next}END{print x/NR}' "run.tmp")
  total_edges=$(awk '{x+=$2;next}END{print x/NR}' "run.tmp")
  total_vertices=$(awk '{x+=$5;next}END{print x/NR}' "run.tmp")
  count_iter=$(awk '{x+=$3;next}END{print x/NR}' "run.tmp")
  elapsed_time=$(awk '{x+=$4;next}END{print x/NR}' "run.tmp")
  max_count_iter=$(awk '{if (x<=$3) x=$3; next}END{print x}' "run.tmp")
  min_count_iter=$(awk 'BEGIN{x=9999999999}{if (x>=$3) x=$3; next}END{print x}' "run.tmp")
  max_time=$(awk '{if (x<=$4) x=$4; next}END{print x}' "run.tmp")
  min_time=$(awk 'BEGIN{x=9999999999}{if (x>=$4) x=$4; next}END{print x}' "run.tmp")
  cat run.tmp >> "experiment-range-$arg1-$arg2-$arg3-all"
  rm run.tmp
  echo $total_edges $min_time $elapsed_time $max_time $range $total_vertices >> "experiment-range-$arg1-$arg2-$arg3-time"
  echo $range $min_count_iter $count_iter $max_count_iter $limU >> "experiment-range-$arg1-$arg2-$arg3-iter"
done   

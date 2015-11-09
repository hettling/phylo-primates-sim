for i in {1..5}; do sbatch -o primates-sim-$i.out -J primates-sim-$i run.sh `date +%Y-%m-%d`-sim-$i; done

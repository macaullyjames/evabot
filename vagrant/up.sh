logfile="/evabot/up.log"
rm -f $logfile

function silent() {
  "$@" >> $logfile 2>&1
  if [ $? -ne 0 ]; then 
    echo "Oops, something bad happened!" 1>&2
    echo "See up.log for more info." 1>&2
    exit 1
  fi
}

cd /evabot/rails

echo "Starting rails server..."
silent rails db:create db:migrate
silent rails server --daemon -b 0.0.0.0
echo "Rails server running at http://localhost:3000"
echo "Good job everybody!"

rm -f $logfile

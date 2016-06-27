echo "Starting rails server..."
cd /evabot/rails && rails server --daemon -b 0.0.0.0 > /dev/null
echo "Rails server running at http://localhost:3000"
echo "Good job everybody!"


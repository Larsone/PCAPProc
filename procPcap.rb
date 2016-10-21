require 'json'

dir = Dir.entries(ARGV[0])
pcapFilenames = ARGV[1].split('/')
$pcapFilename = pcapFilenames[pcapFilenames.length-1].to_s.gsub(/.pcap.*/,'').gsub('.','_').gsub('-','_')


fields = []
jsonArray = Array.new
values = false
indexName = "pcap"


def lineParser(line)
	if line.start_with? '#fields'
		fieldParser(line)
	elsif line.start_with? '#types'
		$values = true
	elsif line.start_with? '#'
		$values = false
	elsif $values
		valuesParser(line)	
	end
end

def valuesParser(line)
	local_hash = {}
	values = line.split(/\t/)
	values.each_with_index do |value,i|
		local_hash[$fields[i+1].strip] = value.strip
	end
	local_hash["pcap_file"] = $pcapFilename
	s = JSON.generate(local_hash)
	$jsonArray << s
end

def fieldParser(line)
	fields = line.split(/\t/)
	fields.each do |field|
		$fields.push(field.strip.gsub('.','_'))
	end
end

def fileHandler(fileName)
	file = File.open("#{ARGV[0]}/#{fileName}")
	file.each do |line|

		lineParser(line)
	end
end

def printer(fileName, indexName)
	if $jsonArray.length > 0

		type = fileName.gsub('.log', '').strip
		#type = "app"
		$jsonArray.each do |json|
			puts "{ \"index\" : { \"_index\" : \"#{indexName}\", \"_type\" : \"#{type}\"} }"

			puts json
		end
	end

end

dir.each do |fileName|
	# Clear fields array
	$fields = []
	$jsonArray = Array.new
	$values = false
	if (fileName.end_with?('.log') && fileName != "reporter.log" && fileName != 'packet_filter.log')
		fileHandler(fileName)
	end
	printer(fileName, indexName)
end

require 'csv'
# Translates a list of ASNs into a list of subnets
Puppet::Functions.create_function(:'milter_greylist::asn2subnets') do
  # Translates a list of ASNs into a list of subnets
  # @param   asns List of ASNs
  # @param   asnfile path to asn csv file
  # @return  [Array] Returns a list of subnets
  # @example milter_greylist::asn2subnets(['12200','36248']) => ["146.177.20.0/23", "166.86.4.0/22", "208.95.156.0/22"]
  dispatch :a2s do
    param 'Array', :asns
    param 'String', :asnfile
  end

  def a2s(asns, asnfile)
    subnets = []
    hsubnets = {}
    unless asns.empty? || asnfile.empty? # || File.file?(asnfile)
      # Run through full list and build a hash with ASN number as a key and a list of its subnets as a value
      CSV.foreach(asnfile) do |row|
        if hsubnets[row[1]].nil?
          hsubnets[row[1]] = []
        end
        hsubnets[row[1]].push(row[0])
      end
      # Loop through ASNs of interest and add IPs to a result
      asns.each do |asn|
        unless hsubnets[asn].nil?
          subnets.push(hsubnets[asn])
        end
      end
    end
    subnets.flatten
  end
end

module Hubspot
  #
  # HubSpot Contacts API
  #
  # {https://developers.hubspot.com/docs/methods/companies/companies-overview}
  class Company
    CREATE_COMPANY_PATH = "/companies/v2/companies"
    UPDATE_COMPANY_PATH = "/companies/v2/companies/:company_id"
    GET_COMPANY_BY_ID_PATH = "/companies/v2/companies/:company_id"

    class << self
      def create!(params={})
        post_data = {properties: Hubspot::Utils.hash_to_properties(params, {key_name: 'name'})}
        response = Hubspot::Connection.post_json(CREATE_COMPANY_PATH, params: {}, body: post_data )
        new(response)
      end

      # {https://developers.hubspot.com/docs/methods/contacts/get_contact}
      def find_by_id(company_id)
        response = Hubspot::Connection.get_json(GET_COMPANY_BY_ID_PATH, { company_id: company_id })
        new(response)
      end
    end

    attr_reader :properties
    attr_reader :company_id

    def initialize(response_hash)
      @properties = Hubspot::Utils.properties_to_hash(response_hash["properties"])
      @company_id = response_hash["companyId"]
    end

    def [](property)
      @properties[property]
    end

    # Updates the properties of a company
    # {https://developers.hubspot.com/docs/methods/contacts/update_contact}
    # @param params [Hash] hash of properties to update
    # @return [Hubspot::Contact] self
    def update!(params)
      query = {"properties" => Hubspot::Utils.hash_to_properties(params.stringify_keys!, {key_name: 'name'})}
      response = Hubspot::Connection.put_json(UPDATE_COMPANY_PATH, params: { company_id: company_id }, body: query)
      @properties.merge!(params)
      self
    end

  end
end

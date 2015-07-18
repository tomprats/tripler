module AdminApp
  class PackagesController < AdminApplicationController
    layout false

    def show
      @package = Package.find(params[:id])
    end
  end
end

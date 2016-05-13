require "http"
class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params)

    #Create Request Address
    external = "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol="
    external_request_address = external << stock_params["symbol"]

    #Retrive from External API
    variable = HTTP.get(external_request_address)
    @decodedJson = ActiveSupport::JSON.decode(variable)


    #Create Stocastic Model
    Stocastic.create(:symbol=>@decodedJson["Symbol"],
                      :price=>@decodedJson["LastPrice"],
                      :marketTime=>@decodedJson["Timestamp"])

=begin
    puts @decodedJson["Symbol"]
    puts @decodedJson["LastPrice"]
    puts @decodedJson["Timestamp"]
=end

    # multiple request via certain intevals
=begin
    begin
      # create HTTP client with persistent connection to api.icndb.com:
      http = HTTP.persistent "http://api.icndb.com"

      # issue multiple requests using same connection:
      100.times.map {
         jokes = http.get("/jokes/random").to_s
         puts jokes
         sleep 2
         puts "it acutually sleeps"
      }

    ensure
      # close underlying connection when you don't need it anymore
      http.close if http
    end
=end
    #Create HTTP Call
    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'Stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:symbol, :score)
    end
end

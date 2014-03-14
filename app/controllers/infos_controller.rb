class InfosController < ApplicationController
  before_filter :authenticate_login!
  before_action :set_info, only: [:show, :edit, :update, :destroy]

  def chart
    render "chart"
  end

  def recharge
    puts params
    user_id = params["user_id"]
    if(params["money"])
      money = params["money"].to_i
      if(money.to_s.include?("-"))
        money *= -1
      end
      info = Info.new
      info.user_id = user_id
      info.money = money
      info.date = Time.now
      info.save
      redirect_to "/users"
    else
      @user = User.find user_id
      render "recharge"
    end
  end

  def collective_consumption
    puts "==================="
    puts "==================="
    puts current_login
    puts current_login.id
    puts params
    puts "==================="
    puts "==================="
    if(!params["user_ids"])
      puts "1"
      @users = User.find(:all)
      render "collective_consumption"
    else
      user_ids = params["user_ids"]
      money = params["money"].to_f
      if(!money.to_s.include?("-"))
        money *= -1
      end
      percentmoney = (money/user_ids.count).round(2)
      user_ids.each do |user_id|
        info = Info.new
        info.user_id = user_id.to_i
        info.money = percentmoney
        info.date = Time.now
        info.address = "test" + user_id
        info.save
      end
      redirect_to "/users"
    end
  end

  # GET /infos
  # GET /infos.json
  def index
    @infos = Info.all
  end

  # GET /infos/1
  # GET /infos/1.json
  def show
  end

  # GET /infos/new
  def new
    @info = Info.new
  end

  # GET /infos/1/edit
  def edit
  end

  # POST /infos
  # POST /infos.json
  def create
    @user= User.find(params[:user_id])
    @info = Info.new()
    @info.user_id = params[:user_id]
    @info.money = params[:info][:money]
    @info.date = params[:info][:date]
    @info.address = params[:info][:address]
    @info.save
    redirect_to @user

    #respond_to do |format|
    #  if @info.save
    #    format.html { redirect_to @info, notice: 'Info was successfully created.' }
    #    format.json { render action: 'show', status: :created, location: @info }
    #  else
    #    format.html { render action: 'new' }
    #    format.json { render json: @info.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /infos/1
  # PATCH/PUT /infos/1.json
  def update
    respond_to do |format|
      if @info.update(info_params)
        format.html { redirect_to @info, notice: 'Info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /infos/1
  # DELETE /infos/1.json
  def destroy
    @info.destroy
    respond_to do |format|
      format.html { redirect_to infos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_info
      @info = Info.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def info_params
      params.require(:info).permit(:user_id, :money, :date, :address)
    end
end

# encoding: utf-8
class InfosController < ApplicationController
  before_filter :authenticate_login!
  before_action :set_info, only: [:show, :edit, :update, :destroy]

  def transfer
    if(!params["from"] && !params["to"])
      @all_users = ""
      users = User.find(:all)
      users.each do |user|
        @all_users += "<option>#{user.name}</option>"
      end
      render "transfer"
    else
      from = params["from"]
      to = params["to"]
      from_money = ("-" + params["money"]).to_f
      to_money =  params["money"].to_f
      condiditon = "('" + from + "','" + to + "')"
      users = User.find_by_sql ["select * from users where name in #{condiditon}"]
      users.each do |user|
        info = Info.new
        info.user_id = user.id
        if(user.name == from)
          info.money = from_money
        else
          info.money = to_money
        end
        info.date = Time.now
        info.address = "由#{from}转账给#{to}"
        info.save
      end
      redirect_to "/users"
    end
  end

  def search_by_date
    result = {}
    date = []
    money = []
    start_time = (Time.now.utc - 30.days).to_s.split(" ")[0]
    end_time = Time.now.utc.to_s.split(" ")[0]
    infos = Info.find_by_sql ["select sum(money) as money,date(date) as date from infos where date > ? and date < ? and money < ? and address != '转账' group by date(date)",start_time,end_time,0]
    infos.each do |info|
      date << info.date.to_s.gsub("-",".")
      money << info.money.to_s.gsub("-","").to_i
    end
    result["date"] = date
    result["money"] = money
    puts result
    respond_to do |format|
      format.js { render :json => result }
    end
  end

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
    if(!params["user_ids"])
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
        info.address = params["address"]
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

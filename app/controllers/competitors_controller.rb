class CompetitorsController < ApplicationController
  before_filter :check_login, :except => [:index, :show]
  # GET /competitors
  # GET /competitors.json
  def index
    # i know the if and else are the same
    # but just to be sure so I don't have to do it again
    if(params[:sort].nil?)
      @competitors = Competitor.by_elo
    elsif params[:sort].eql?("name")
      @competitors = Competitor.alphabetical
    elsif params[:sort].eql?("wins")
      @competitors = Competitor.by_wins
    elsif params[:sort].eql?("times")
      @competitors = Competitor.by_times_played
    else
      @competitors = Competitor.by_elo
    end
        
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @competitors }
    end
  end

  # GET /competitors/1
  # GET /competitors/1.json
  def show
    @competitor = Competitor.find(params[:id])
    @competitors = Competitor.by_elo.limit(10)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @competitor }
    end
  end

  # GET /competitors/new
  # GET /competitors/new.json
  def new
    @competitor = Competitor.new
    authorize! :new, @competitor
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @competitor }
    end
  end

  # GET /competitors/1/edit
  def edit
    @competitor = Competitor.find(params[:id])
    authorize! :update, @competitor
  end

  # POST /competitors
  # POST /competitors.json
  def create
    @competitor = Competitor.new(params[:competitor])
    authorize! :new, @competitor

    respond_to do |format|
      if @competitor.save
        format.html { redirect_to @competitor, notice: 'Competitor was successfully created.' }
        format.json { render json: @competitor, status: :created, location: @competitor }
      else
        format.html { render action: "new" }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /competitors/1
  # PUT /competitors/1.json
  def update
    @competitor = Competitor.find(params[:id])
    authorize! :update, @competitor

    respond_to do |format|
      if @competitor.update_attributes(params[:competitor])
        format.html { redirect_to @competitor, notice: 'Competitor was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitors/1
  # DELETE /competitors/1.json
  def destroy
    @competitor = Competitor.find(params[:id])
    authorize! :destroy, @competitor
    @competitor.destroy

    respond_to do |format|
      format.html { redirect_to competitors_url }
      format.json { head :no_content }
    end
  end
end

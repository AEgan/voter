class ContestsController < ApplicationController
  # GET /contests
  # GET /contests.json
  def index
    @contests = Contest.active.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contests }
    end
  end

  # GET /contests/1
  # GET /contests/1.json
  def show
    @contest = Contest.find(params[:id])
    @competitors = Competitor.for_contest(params[:id]).by_elo
    @leader = @competitors.first unless @competitors.empty?

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contest }
    end
  end

  # GET /contests/new
  # GET /contests/new.json
  def new
    @contest = Contest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contest }
    end
  end

  # GET /contests/1/edit
  def edit
    @contest = Contest.find(params[:id])
  end

  # POST /contests
  # POST /contests.json
  def create
    @contest = Contest.new(params[:contest])

    respond_to do |format|
      if @contest.save
        format.html { redirect_to @contest, notice: 'Contest was successfully created.' }
        format.json { render json: @contest, status: :created, location: @contest }
      else
        format.html { render action: "new" }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contests/1
  # PUT /contests/1.json
  def update
    @contest = Contest.find(params[:id])

    respond_to do |format|
      if @contest.update_attributes(params[:contest])
        format.html { redirect_to @contest, notice: 'Contest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contests/1
  # DELETE /contests/1.json
  def destroy
    @contest = Contest.find(params[:id])
    @contest.destroy

    respond_to do |format|
      format.html { redirect_to contests_url }
      format.json { head :no_content }
    end
  end

  # for voting for a contest
  def vote
    @contest = Contest.find(params[:id])
    @competitors = Competitor.for_contest(@contest.id).random
  end

  def submit
    winner = Competitor.find(params[:winner_id]) unless params[:winner_id].nil?
    loser = Competitor.find(params[:loser_id]) unless params[:loser_id].nil?
    # new version of update_elo method is called on the winner, passing in loser
    winner.update_elo(loser)
    redirect_to request.referer
  end
end

class SrvinfosController < ApplicationController
  before_action :set_srvinfo, only: [:show, :edit, :update, :destroy]

  # GET /srvinfos
  # GET /srvinfos.json
  def index
    @srvinfos = Srvinfo.all
  end

  # GET /srvinfos/1
  # GET /srvinfos/1.json
  def show
  end

  # GET /srvinfos/new
  def new
    @srvinfo = Srvinfo.new
  end

  # GET /srvinfos/1/edit
  def edit
  end

  # POST /srvinfos
  # POST /srvinfos.json
  def create
    @srvinfo = Srvinfo.new(srvinfo_params)

    respond_to do |format|
      if @srvinfo.save
        format.html { redirect_to @srvinfo, notice: 'Srvinfo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @srvinfo }
      else
        format.html { render action: 'new' }
        format.json { render json: @srvinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /srvinfos/1
  # PATCH/PUT /srvinfos/1.json
  def update
    respond_to do |format|
      if @srvinfo.update(srvinfo_params)
        format.html { redirect_to @srvinfo, notice: 'Srvinfo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @srvinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /srvinfos/1
  # DELETE /srvinfos/1.json
  def destroy
    @srvinfo.destroy
    respond_to do |format|
      format.html { redirect_to srvinfos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_srvinfo
      @srvinfo = Srvinfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def srvinfo_params
      params.require(:srvinfo).permit(:host, :post)
    end
end

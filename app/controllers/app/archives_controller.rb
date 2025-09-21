class App::ArchivesController < AppController
  allow_out_of_archive_access

  before_action :set_archive, only: %i[ show edit update destroy access ]

  # GET /app/archives or /app/archives.json
  def index
    @archives = Archive.accessible_by(Current.character.id)
  end

  # GET /app/archives/1 or /app/archives/1.json
  def show
  end

  # GET /app/archives/new
  def new
    @archive = Archive.new
  end

  # GET /app/archives/1/edit
  def edit
  end

  # POST /app/archives or /app/archives.json
  def create
    @archive = Archive.new(archive_params)

    respond_to do |format|
      if @archive.save
        format.html { redirect_to @archive, notice: "Archive was successfully created." }
        format.json { render :show, status: :created, location: @archive }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app/archives/1 or /app/archives/1.json
  def update
    respond_to do |format|
      if @archive.update(archive_params)
        format.html { redirect_to @archive, notice: "Archive was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @archive }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app/archives/1 or /app/archives/1.json
  def destroy
    @archive.destroy!

    respond_to do |format|
      format.html { redirect_to app_archives_url, notice: "Archive was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def access
    Current.session.update!(archive: @archive)

    redirect_to root_url, notice: "#{@archive.name} selected!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archive
      @archive = Archive.accessible_by(Current.character.id).find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def archive_params
      params.fetch(:archive, {})
    end
end

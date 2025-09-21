class App::ArchivesController < AppController
  allow_out_of_archive_access

  before_action :set_archive, only: %i[ edit update destroy ]

  # GET /app/archives or /app/archives.json
  def index
    @archives = Archive.accessible_by(Current.character.id)
  end

  # GET /app/archives/new
  def new
    @archive = App::ArchiveSchema.new
  end

  # GET /app/archives/1/edit
  def edit
    @archive = App::ArchiveSchema.new(
      id: @archive.id,
      name: @archive.name,
      description: @archive.description,
      owner: @archive.owner
    )
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

  # POST /app/archives/1/access
  def access
    @archive = Archive.accessible_by(Current.character.id).find(params.expect(:id))
    Current.session.update!(archive: @archive)
    redirect_to root_url, notice: "#{@archive.name} selected!"
  end

  private
    def set_archive
      @archive = Current.character.archives.find(params.expect(:id))
    end

    def archive_params
      params.require(:archive).permit(:name, :description)
    end
end

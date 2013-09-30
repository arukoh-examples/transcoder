class ContentsController < ApplicationController
  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contents }
    end
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])
    @transcode = @content.transcode
    @thumbnail_urls = @transcode.thumbnail_urls
    @properties = @transcode.properties rescue nil

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content }
    end
  end

  # GET /contents/upload
  # GET /contents/upload.json
  def new
    @content = Content.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @content }
    end
  end

  # POST /contents
  # POST /contents.json
  def create
    render :status => 404 and return unless request.xhr?

    uploaded = Hash.from_xml(params[:response])['PostResponse']
    @content = Content.new(
      name:       params[:name],
      size:       params[:size],
      mime_type:  MIME::Types.type_for(params[:name])[0].to_s || MIME::Types.type_for(params[:type])[0].to_s,
      link:       CGI.unescape(uploaded['Location']),
      bucket:     uploaded['Bucket'],
      object_key: uploaded['Key'],
    )

    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content was successfully created.' }
        format.json { render json: @content, status: :created, location: @content }
      else
        format.html { render action: "new" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to contents_url }
      format.json { head :no_content }
    end
  end
end

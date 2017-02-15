class DownloadController < ApplicationController

  def index
    @download = Sgfile.download.select('sgfile_id, sgfile_nm, vers, cmnt, datalength(data) as size')
  end

  def download
    file = Sgfile.download.find(params[:id])
    send_data( file.data, filename: file.sgfile_nm)
  end

end


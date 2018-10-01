module AlertsCrud
  extend ActiveSupport::Concern

  included do
    before_filter :set_alertable, only: [:create_alert, :update_alert, :destroy_alert]
    before_filter :set_alert, only: [:update, :destroy]
  end

  def create_alert
    @alert = @alertable.alerts.create alert_params.merge(alertables_custom_method: :any)

    respond_to do |format|
      if @alert.save alert_params
        format.json { render json: @alert.api_json, status: :ok }
      else
        format.json { render json: {}, status: :error }
      end
    end
  end

  def update_alert
    respond_to do |format|
      if @alert.update alert_params
        format.json { render json: @alert.api_json, status: :ok }
      else
        format.json { render json: {}, status: :error }
      end
    end
  end

  def destroy_alert
    respond_to do |format|
      if @alert.destroy
        format.json { render json: @alert.api_json, status: :ok }
      else
        format.json { render json: {}, status: :error }
      end
    end
  end

  def set_alert
    @alert = @alertable.alerts.find(params[:id])
  end
end
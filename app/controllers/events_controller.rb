class EventsController < ApplicationController

  def index
    unless current_student
      flash[:danger] = "Merci de vous connecter en tant qu'Elève pour pouvoir réserver"
      redirect_to new_student_session_path
    end

    #to build the "new event" form
    @duration_picker = [["1h", 3600], ["30min", 1800]]
    @hours = []
    (8..20).to_a.each do |i| 
      @hours << [i.to_s,i.to_s]
    end
    @minutes = [["00", "00"], ["15", "15"], ["30", "30"], ["45", "45"]]

    #all the objects used in the view
    @teacher = Teacher.find(params[:teacher_id])
    @resource = Resource.find(params[:resource_id])
    @establishment = @resource.establishment
    @resources = @establishment.resources
    @student = current_student
    @event = Event.new

    #all the events to show
    @events_resource= @resource.upcoming_events
    @events_teacher= @teacher.upcoming_events
    @events = []
    @events.concat(@events_resource) 
    @events.concat(@events_teacher) 
    @events.uniq!
  end

  def show
    p "-" * 50
    p "SHOW EVENTS ---" * 3
    p params
    p "-" * 50
  end

  def edit
  end

  def create
    params[:event][:start_time] = params[:event][:date]+"T"+params[:event][:hours]+":"+params[:event][:minutes]
    puts "$"*60
    puts params[:event][:start_time]
    puts "$"*60

    @event = Event.new(event_params)
    @event.set_event_name

    if @event.save
      flash[:success]="Le créneau a bien été réservé!"
      redirect_back(fallback_location: root_path)
      return
    else
      flash[:danger]= @event.errors
      redirect_back(fallback_location: root_path)
      return
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :start_time, :duration, :teacher_id, :student_id, :resource_id)
  end

end

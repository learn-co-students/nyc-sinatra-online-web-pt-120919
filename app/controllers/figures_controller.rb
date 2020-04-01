class FiguresController < ApplicationController
  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/new'
  end

  post '/figures' do
    # Creates figure, associates any titles or landmarks
    @figure = Figure.create(params[:figure])

    # Associates a new title to figure
    if !params[:title][:name].empty?
      @figure.titles << Title.create(params[:title])
    end

    # Associates a new landmark to figure
    if !params[:landmark][:name].empty?
      @figure.landmarks << Landmark.create(params[:landmark])
    end
    erb :'/figures/index'
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @landmarks = Landmark.all
    @titles = Title.all
    erb :'/figures/edit'
  end

  patch '/figures/:id' do
    # If no new checkboxs are selected while all others are selected
    # No parameters are passed through to indicate this
    # So the figure instance retains the unselected title / landmark
    # Below methods make it possible to remove all selections

    if !params[:figure][:title_ids]
      params[:figure][:title_ids] = []
    end

    if !params[:figure][:landmark_ids]
      params[:figure][:landmark_ids] = []
    end

    @figure = Figure.find(params[:id])
    @figure.update(params[:figure])

    # Associates a new title to figure
    if !params[:title][:name].empty?
      @figure.titles << Title.create(params[:title])
    end

    # Associates a new landmark to figure
    if !params[:landmark][:name].empty?
      @figure.landmarks << Landmark.create(params[:landmark])
    end
    redirect "/figures/#{@figure.id}"
  end
end

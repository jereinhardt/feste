module Feste
  module Admin
    class CategoriesController < ActionController::Base
      layout "feste/admin"

      before_action :load_mailers, only: [:new, :create, :edit, :update]

      def index
        @categories = Feste::Category.all
      end

      def new
        @category = Feste::Category.new
      end

      def create
        @category = Feste::Category.new(category_params)
        if @category.save
          flash[:success] = "Successfully created #{@category.name}."
          redirect_to categories_path
        else
          flash[:notice] = error_message_for(
            @category,
            "There was an issue creating this category."
          )
          render :new
        end
      end

      def edit
        @category = Feste::Category.find(params[:id])
      end

      def update
        @category = Feste::Category.find(params[:id])
        if @category.update(category_params)
          flash[:success] = "Successfully updated #{@category.name}"
          redirect_to categories_path
        else
          flash[:notice] = error_message_for(
            @category,
            "There was in issue updating this category."
          )
          render :edit
        end
      end

      def destroy
        category = Feste::Category.find(params[:id])
        category.destroy
        flash[:success] = "Category removed."
        redirect_to categories_path
      end

      private

      def category_params
        params.require(:category).permit(:name, mailers: [])
      end

      def load_mailers
        require_mailers
        @mailers = ActionMailer::Base.descendants.reject do |mailer|
          mailer == ApplicationMailer
        end.map do |mailer|
          mailer.action_methods.map { |action| "#{mailer.to_s}##{action}" }
        end.flatten
      end

      def require_mailers
        Dir[Rails.root.join("app", "mailers", "**", "*mailer.rb")].each do |f|
          require f
        end        
      end

      def error_message_for(model, preamble)
        errors = model.errors.messages.map do |name, errors|
          errors.reduce("") { |acc, error| "<li>#{name}: #{error}</li>" }
        end.join("")
        """
        #{preamble}  Please address the following errors:

        <ul>#{errors}</ul>
        """.html_safe
      end
    end
  end
end
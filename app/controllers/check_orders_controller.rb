class CheckOrdersController < ApplicationController
  def check_order_form
    @code = ''
  end

  def show
    @code = params[:code]

    if @code.length != 8
      flash.now[:alert] = 'O código do Pedido deve ter 8 caracteres'
      return render :check_order_form
    end

    @order = Order.find_by(code: @code)

    if @order.nil?
      flash.now[:alert] = 'Ops! :( Não foi possível achar um pedido com o Código informado'
      return render :check_order_form
    end
  end
end
# frozen_string_literal: true

class OrdersController < ApplicationController
  # list items
  def index
    @orders = Order.all
    render json: @orders
  end

  # single item
  def show; end

  # form for creating
  def new; end

  # create item
  def create
    @order = Order.new(order_params)
    if @order.save
      render json: @order
    else
      render json: @order.errors
    end
  end

  # form for edit
  def edit; end

  # change order
  def update; end

  # deletes item
  def destroy; end

  private

  def order_params
    # requires the params contain a hash :
    # {
    #   order: {
    #     status: '',
    #     paid_at: '',
    #     stripe_id: ''
    #   }
    # }
    params.require(:order).permit(:status, :paid_at, :stripe_id)
  end
end

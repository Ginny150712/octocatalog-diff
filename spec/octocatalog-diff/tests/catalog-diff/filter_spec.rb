# frozen_string_literal: true

require_relative '../spec_helper'
require OctocatalogDiff::Spec.require_path('/catalog-diff/filter')

describe OctocatalogDiff::CatalogDiff::Filter do
  before(:each) do
    @class_1 = double
    @class_2 = double
    allow(Kernel).to receive(:const_get).with('OctocatalogDiff::CatalogDiff::Filter::Fake1').and_return(@class_1)
    allow(Kernel).to receive(:const_get).with('OctocatalogDiff::CatalogDiff::Filter::Fake2').and_return(@class_2)
  end

  describe '#apply_filters' do
    it 'should call self.filter() with appropriate options for each class' do
      result = [false]
      options = { 'Fake1' => { foo: 'bar' } }
      classes = %w(Fake1 Fake2)
      expect(@class_1).to receive(:'filtered?').with(false, foo: 'bar').and_return(false)
      expect(@class_2).to receive(:'filtered?').with(false, {}).and_return(false)
      expect { described_class.apply_filters(result, classes, options) }.not_to raise_error
      expect(result).to eq([false])
    end
  end

  describe '#filter' do
    it 'should call .filtered?() in a class and remove matching items' do
      result = [false, true]
      expect(@class_1).to receive(:'filtered?').with(false, {}).and_return(false)
      expect(@class_1).to receive(:'filtered?').with(true, {}).and_return(true)
      expect { described_class.filter(result, 'Fake1') }.not_to raise_error
      expect(result).to eq([false])
    end
  end

  describe '#filtered?' do
    it 'should raise error' do
      expect { described_class.filtered?([]) }.to raise_error(RuntimeError, /No `filtered\?` method is implemented/)
    end
  end
end

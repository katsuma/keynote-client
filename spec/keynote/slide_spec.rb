require 'spec_helper'

describe Keynote::Slide do
  describe '#initialize' do
    context 'when base_slide is not given' do
      it 'raises an ArgumentError' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context 'when base_slide is given' do
      it 'returns Slide instance' do
        slide = described_class.new('base_title', title: 'foo')
        expect(slide).to be_a(described_class)
        expect(slide.title).to eq('foo')
      end
    end
  end

  describe '#title=' do
    subject { slide.title=('new_title') }

    context 'when document is not set' do
      let(:slide) { described_class.new('base_slide') }

      it 'does not eval script to update Keynote' do
        expect(slide).not_to receive(:eval_script)
        subject
      end
    end

    context 'when slide_number is not set'do
      let(:slide) { described_class.new('base_slide', slide_number: 1) }

      it 'does not eval script to update Keynote' do
        expect(slide).not_to receive(:eval_script)
        subject
      end
    end

    context 'when both argument is set' do
      let(:slide) do
        described_class.new('base_slide',
          document: Keynote::Document.new(id: 'some-document-id'),
          slide_number: 1
        )
      end

      it 'evals script to update Keynote' do
        allow(Open3).to receive(:capture2).with(/osascript -l JavaScript/).and_return(["", 1])
        expect(slide).to receive(:eval_script).with(/new_title/)
        subject
        expect(slide.title).to eq('new_title')
      end
    end
  end

  describe '#body=' do
    subject { slide.body=(new_body) }

    let(:new_body) { 'new_body' }

    context 'when document is not set' do
      let(:slide) { described_class.new('base_slide') }

      it 'does not eval script to update Keynote' do
        expect(slide).not_to receive(:eval_script)
        subject
      end
    end

    context 'when slide_number is not set'do
      let(:slide) { described_class.new('base_slide', slide_number: 1) }

      it 'does not eval script to update Keynote' do
        expect(slide).not_to receive(:eval_script)
        subject
      end
    end

    context 'when document is set' do
      let(:slide) do
        described_class.new('base_slide',
          document: Keynote::Document.new(id: 'some-document-id'),
          slide_number: 1
        )
      end

      it 'evals script to update Keynote' do
        allow(Open3).to receive(:capture2).with(/osascript -l JavaScript/).and_return(["", 1])
        expect(slide).to receive(:eval_script).with(/new_body/)
        subject
        expect(slide.body).to eq('new_body')
      end

      context 'and when new_body includes new-line character' do
        let(:new_body) { 'new\nbody' }

        it 'evals script to update Keynote with escaped new body' do
          allow(Open3).to receive(:capture2).with(/osascript -l JavaScript/).and_return(["", 1])
          expect(slide).to receive(:eval_script).with(/new\\nbody/)
          subject
          expect(slide.body).to eq('new\\nbody')
        end
      end
    end
  end
end

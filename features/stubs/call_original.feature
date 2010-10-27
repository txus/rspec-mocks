Feature: Stub or mock calls original method

  Use the call_original() inside a stub or mock return block to make it call the
  original implementation of the method.

      my_object.should_receive(:my_method).once.and_return do
        call_original 
      end

  This can be particularly useful combined with conditions; for example, you could
  make the stub or mock call the original method only if one of the arguments passed
  matches a particular criteria.

      my_object.stub(:my_method).with(kind_of(String), kind_of(Fixnum))\ 
               .and_return do |string, fixnum|
        call_original if fixnum > 3
      end

  Scenario: mock with call to the original method
    Given a file named "example_spec.rb" with:
      """
      describe "a simple mock with a call to the original method" do
        let(:receiver) { "mystring" }

        it "executes the original method implementation" do
          receiver.should_receive(:upcase).and_return do
            call_original
          end
          receiver.upcase.should == "MYSTRING"
        end

      end
      """
    When I run "rspec example_spec.rb"
    Then the output should contain "0 failures"

  Scenario: stub with call to the original method with arguments
    Given a file named "example_spec.rb" with:
      """
      describe "a simple mock with a call to the original method" do
        let(:receiver) { "mystring with whitespace" }

        it "executes the original method implementation with arguments" do
          receiver.should_receive(:split).with(" ").and_return do |separator|
            call_original(separator)
          end
          receiver.split(" ").should == ["mystring", "with", "whitespace"]
        end

      end
      """
    When I run "rspec example_spec.rb"
    Then the output should contain "0 failures"

require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.0.0" do
  describe "Module#refinements" do
    it "returns a hash of all refinements in the module" do
      mod = Module.new do
        refine(String) {}
        refine(Enumerable) {}
      end

      mod.refinements.key?(String).should be_true
      mod.refinements.key?(Enumerable).should be_true
      mod.refinements[String].should be_kind_of(Module)
      mod.refinements[Enumerable].should be_kind_of(Module)
    end
    it "changes to the returned hash don't affect refinements" do
      mod = Module.new do
        refine(String){}
      end
      hash = mod.refinements
      hash[Enumerable] = Module.new
      mod.refinements.key?(Enumerable).should be_false
    end
    it "methods added to the anon methods do refine class" do
      mod = Module.new do
        refine(String) {}
      end
      mod.refinements[String].module_eval do
        def manually_added
          true
        end
      end
      mod.module_eval do
        "foo".manually_added
      end.should be_true
    end
  end
end

# FIXME: Where to do this? the constant definition cannot be inside a method.
DB = Sequel.sqlite GammoAnalyzer::Configuration.database

# 
# # KDC Tests
#
# A few basic tests for KDC to ensure we don't accidentally change behavior.
#
{execFile}  = require 'child_process'
fs          = require 'fs'
path        = require 'path'
md5         = require 'MD5'
should      = require 'should'




describe 'kdc', ->
  kdc_path  = path.join __dirname, '..', 'bin', '_kdc.js'

  describe 'a simple project', ->
    stub_path = path.join __dirname, 'stubs', 'onlykdc'

    it 'should compile without failing', (done) ->
      #kdcp = spawn 'node', [kdc_path, stub_path]
      execFile 'node', [kdc_path, stub_path], (err, stdout, stderr) ->
        should.not.exist err
        # We're ignoring the Unicode LF
        stdout[...-1].should.equal 'Application has been compiled!'
        stderr.should.equal ''
        done()

    target_md5 = '8e20f6f63712ed758fd74e70c1608259'
    it "should match md5 #{target_md5}", ->
      index = fs.readFileSync path.join(stub_path, 'index.js'),
        encoding: 'utf-8'

      # We want to ignore the first line since it has a timestamp, so
      # we'll trim that off.
      index = index.split('\n')[1...].join('\n')

      md5(index).should.equal target_md5





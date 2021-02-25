/**
 * Roblox-Rojo-Bundle v1.0 [2020-12-07 04:00]
 *
 * The Roblox-Rojo-Bundle is a Rojo project template that facilitates the process of deploying projects. 
 * Roblox-Rojo-Bundle allows you to concatenate and minify all required scripts
 *
 * https://github.com/nidorx/roblox-rojo-bundle
 *
 * Discussions about this project are at https://devforum.roblox.com/t/841175
 *
 * ------------------------------------------------------------------------------
 *
 * MIT License
 *
 * Copyright (c) 2020 Alex Rodin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

const fs = require('fs')
const path = require('path')
const rimraf = require('rimraf')
const mkdirp = require('mkdirp')
const luamin = require('luamin')
const cpx = require('cpx')

const BUILD_CONFIG = require('./build.json')

// Removes previous content, if any
rimraf.sync('./build/**/*.lua');

// Copy default.project.json
var projectJSON = require('./default.project.json');

// Recreate all Rojo directories
// mkdirp.sync(path.join(__dirname, '/build', projectJSON.tree.Workspace.$path));
// mkdirp.sync(path.join(__dirname, '/build', projectJSON.tree.ServerStorage.$path));
mkdirp.sync(path.join(__dirname, '/build', projectJSON.tree.ReplicatedStorage.$path));
// mkdirp.sync(path.join(__dirname, '/build', projectJSON.tree.ServerScriptService.$path));
mkdirp.sync(path.join(__dirname, '/build', projectJSON.tree.StarterPlayer.StarterPlayerScripts.$path));
// mkdirp.sync(path.join(__dirname, '/build', projectJSON.tree.StarterPlayer.StarterCharacterScripts.$path));

fs.writeFileSync(path.normalize(__dirname + '/build/default.project.json'), JSON.stringify(projectJSON, null, 4));

var DEFAULT_VARIABLE_PATH = {
   // '__S_Workspace': projectJSON.tree.Workspace.$path,
   // '__S_ServerStorage': projectJSON.tree.ServerStorage.$path,
   '__S_ReplicatedStorage': projectJSON.tree.ReplicatedStorage.$path,
   // '__S_ServerScriptService': projectJSON.tree.ServerScriptService.$path,
   // '__S_Players.LocalPlayer.Character': projectJSON.tree.StarterPlayer.StarterCharacterScripts.$path,
   '__S_Players.LocalPlayer.PlayerScripts': projectJSON.tree.StarterPlayer.StarterPlayerScripts.$path
}


var DEPENDENCIES = {};
var DEPENDECY_SEQ = 1;

/**
 * All Roblox services, used to define a single global call
 */
var SERVICES = {};

cpx.copy('./src/**/*.rbxmx', './build/src/', { verbose: true, preserve: true, update: true }, function () {

   BUILD_CONFIG.entries.forEach(function (entry) {
      // clear variables
      DEPENDENCIES = {};
      DEPENDECY_SEQ = 1;
      SERVICES = {

         //'Players': false,
         //'Debris': false,
         //'ServerStorage': false,
         //'ReplicatedStorage': false,
         //'UserInputService': false,
         //'ServerScriptService': false
      };

      const rootFile = path.join(__dirname, entry);

      // Starts processing in the Main file
      DEPENDENCIES[rootFile] = {
         property: null,
         id: '__ROOT',
         depends: []
      };
      var rootInfo = proccessFile(rootFile);
      DEPENDENCIES[rootFile].depends = rootInfo.depends;
      DEPENDENCIES[rootFile].source = rootInfo.source;


      // Generate the final code, concatenating the files
      var modulesSource = [];
      var fileDeps = [];
      for (var dir in DEPENDENCIES) {
         if (!DEPENDENCIES.hasOwnProperty(dir)) {
            continue;
         }
         fileDeps.push(DEPENDENCIES[dir]);
      }

      fileDeps.sort(function (a, b) {
         // Root always at the end
         if (a.id === '__ROOT') {
            return +1;
         }
         if (b.id === '__ROOT') {
            return -1;
         }
         if (a.depends.indexOf(b.id) >= 0) {
            // A depends on B
            return 1;
         }
         if (b.depends.indexOf(a.id) >= 0) {
            // B depends on A
            return -1;
         }
         return 0;
      }).forEach(function (dependency) {
         if (dependency.id === '__ROOT') {
            modulesSource.push([
               'do',
               '   ' + dependency.source.replace(/\n/g, '\n   '),
               'end',
            ].join('\n'))
         } else {
            modulesSource.push([
               '__MF__[' + dependency.id + '] = function()\n   ' + dependency.source.trim().replace(/\n/g, '\n   ') + '\nend\n'
            ].join('\n'));
         }
      });

      function byteLength(code) {
         if (BUILD_CONFIG.minify) {
            try {
               return Buffer.byteLength(luamin.minify(code), 'utf8')
            } catch (e) {
               console.error('Luamin error on code')
               console.log(code)
               throw e
            }
         }
         return Buffer.byteLength(code, 'utf8')
      }

      // Organizes into chunks, Roblox does not allow scripts larger than 200k
      var sourceSize = 0
      var chunks = []
      var chunk = []
      modulesSource.forEach(function (source) {
         var moduleSize = byteLength(source)
         if (sourceSize + moduleSize > BUILD_CONFIG.maxSize) {
            chunks.push(chunk)
            chunk = [source]
            sourceSize = 0
         } else {
            sourceSize += moduleSize
            chunk.push(source)
         }
      })
      chunks.push(chunk)

      var outputDir = path.dirname(entry)
      var outputName = path.basename(entry)
      var outputNameBase, outputExt
      if (outputName.endsWith('.client.lua')) {
         outputExt = '.client.lua'
         outputNameBase = outputName.replace('.client.lua', '')
      } else if (outputName.endsWith('.server.lua')) {
         outputExt = '.server.lua'
         outputNameBase = outputName.replace('.server.lua', '')
      } else {
         outputExt = '.lua'
         outputNameBase = outputName.replace('.lua', '')
      }

      chunks.forEach((chunk, index) => {
         let isLast = (index == chunks.length - 1)

         if (isLast) {
            var others = chunks.concat()
            others.pop()
            // Main file
            var code = [
               'do',
               '   ' + (
                  Object.keys(SERVICES)
                     .filter((k) => SERVICES[k])
                     .map((k) => `local __S_${k} = game:GetService('${k}')`)
                     .join('\n   ')
               ),
               '   local __M__      = {}',
               '   local __MF__     = {}',
               '   local __MREC__   = function(m)',
               '      if not __M__[m] then __M__[m] = { r = __MF__[m]() } end',
               '      return __M__[m].r',
               '   end\n',
               others.length > 0
                  ? (
                     '   ' +
                     (
                        others
                           .map((v, i) => {
                              return `require(script.Parent:WaitForChild('${outputNameBase}${i}'))(__M__, __MF__, __MREC__)`
                           })
                           .join('\n   ')
                     ) + '\n'
                  )
                  : '',
               '   ' + chunk.join('\n').replace(/\n/g, '\n   '),
               'end'
            ].join('\n');

            var outputFile = path.join(__dirname, '/build/', outputDir, outputNameBase + outputExt);
            if (BUILD_CONFIG.minify) {
               try {
                  code = luamin.minify(code)
               } catch (e) {
                  console.error('Luamin error on code')
                  console.log(code)
                  throw e
               }
            }

            fs.writeFileSync(outputFile, code);
         } else {

            // Chunk
            var code = [
               'do',
               '   ' + (
                  Object.keys(SERVICES)
                     .filter((k) => SERVICES[k])
                     .map((k) => `local __S_${k} = game:GetService('${k}')`)
                     .join('\n   ')
               ),
               '',
               '   return function(__M__, __MF__, __MREC__)\n',
               '      ' + chunk.join('\n').replace(/\n/g, '\n      '),
               '   end',
               'end'
            ].join('\n');

            var outputFile = path.join(__dirname, '/build/', outputDir, outputNameBase + index + '.lua');
            if (BUILD_CONFIG.minify) {
               try {
                  code = luamin.minify(code)
               } catch (e) {
                  console.error('Luamin error on code')
                  console.log(code)
                  throw e
               }
            }

            fs.writeFileSync(outputFile, code);
         }
      })
   })
})

/**
 * Processing a lua file
 * 
 * @param {type} filePath
 * @returns {undefined}
 */
function proccessFile(filePath) {
   var filePathFinal;
   // @TODO: suport files init.lua ??
   var filePathWtExt = path.join(path.dirname(filePath), path.basename(filePath, path.extname(filePath)));
   if (fs.existsSync(filePathWtExt + '.lua')) {
      filePathFinal = filePathWtExt + '.lua';
   } else {
      throw new Error('Dependency not found:' + filePathWtExt);
   }

   var depends = [];
   var source = fs.readFileSync(filePathFinal, 'utf-8').replace(/\t/g, '   ');

   // removes all comments (simplifies processing and prevents false positives)
   var sourceNoComments = ''
   var inComment = false
   source.split('\n').forEach(function (line) {
      var linetrim = line.trim()
      if (linetrim == '') {
         return
      }

      if (inComment) {
         if (linetrim.startsWith(']]')) {
            inComment = false
         }
         return
      }

      if (linetrim.startsWith('--[[')) {
         inComment = true
         return
      }

      if (linetrim.startsWith('--')) {
         return
      }

      if (line.includes('--')) {
         // end of line comment
         line = line.replace(/--(.*)$/, '')
      }

      sourceNoComments += line.replace(/(\s+)$/, '') + '\n'
   })
   source = '--[[file:' + filePath.replace(__dirname, '') + ']]\n' + sourceNoComments

   // Replaces all game:GetService
   source = source.replace(/game:GetService\(['"]([^'"]*)['"]\)?/g, function ($0, service) {
      SERVICES[service] = true;
      return '(__S_' + service + ')'
   });

   // Replaces all game.Service
   source = source.replace(/([^\w])game\.(\w+)/g, function ($0, prefix, service, suffix) {
      SERVICES[service] = true;
      return prefix + '__S_' + service
   });


   var VARIABLE_PATH = JSON.parse(JSON.stringify(DEFAULT_VARIABLE_PATH))
   var SCRIPT_PARENT = 'script.Parent';
   VARIABLE_PATH[SCRIPT_PARENT] = path.dirname(filePath).replace(path.normalize(__dirname), '')

   var VARIABLE_ALIAS = {}

   // Enables up to 3 levels of script.Parent
   for (var a = 0; a < 3; a++) {
      VARIABLE_PATH[SCRIPT_PARENT + '.Parent'] = path.dirname(VARIABLE_PATH[SCRIPT_PARENT]).replace(path.normalize(__dirname), '')
      SCRIPT_PARENT = SCRIPT_PARENT + '.Parent'
   }

   var REQUIRE_REGEX = /(=\s+)require\((.*)\)$/
   var VARIABLE_REGEX = /local\s+(\w+)\s*=\s*(.*)$/

   var newSource = ''
   source.split('\n').forEach(function (line) {
      var linetrim = line.trim()
      if (linetrim.match(REQUIRE_REGEX)) {
         line = linetrim.replace(REQUIRE_REGEX, function ($0, prefix, value, $pos, $content) {

            var originalValue = value
            value = value.trim()

            if (value.includes('WaitForChild')) {
               value = value.replace(/:WaitForChild\(['"]([^'"]*)['"]\)/g, '.$1')
            }

            if (value.includes('FindFirstChild')) {
               value = value.replace(/:FindFirstChild\(['"]([^'"]*)['"]\)/g, '.$1')
            }

            var varPath = ''
            var dirPath = ''
            value.split('.').forEach((part) => {
               if (VARIABLE_ALIAS[varPath]) {
                  VARIABLE_ALIAS[varPath + '.' + part] = VARIABLE_ALIAS[varPath] + '.' + part
               }

               if (varPath != '') {
                  varPath += '.'
               }

               varPath += part

               if (SERVICES[varPath]) {
                  VARIABLE_ALIAS[varPath] = '__S_' + varPath
                  varPath = VARIABLE_ALIAS[varPath]
               }

               if (VARIABLE_ALIAS[varPath]) {
                  varPath = VARIABLE_ALIAS[varPath]
               }

               if (VARIABLE_PATH[varPath]) {
                  dirPath = VARIABLE_PATH[varPath]
               } else {
                  dirPath += '/' + part
               }
            })

            var dirFull = path.join(__dirname, dirPath + '.init.lua')
            if (!fs.existsSync(dirFull)) {
               dirFull = path.join(__dirname, dirPath + '.lua')
            }

            if (!fs.existsSync(dirFull)) {
               console.error('varPath=', varPath)
               console.error('dirFull=', dirFull)
               console.error('dirPath=', dirPath)
               console.error('filePath=', filePath)
               console.error('variables=', JSON.stringify(VARIABLE_PATH, null, 2))
               console.error('aliases=', JSON.stringify(VARIABLE_ALIAS, null, 2))
               throw ('Invalid require ' + originalValue)
            } else {
               if (!DEPENDENCIES.hasOwnProperty(dirFull)) {
                  DEPENDENCIES[dirFull] = {
                     depends: [],
                     id: DEPENDECY_SEQ++,
                     source: ''
                  };

                  var dependencyInfo = proccessFile(dirFull);
                  DEPENDENCIES[dirFull].depends = dependencyInfo.depends;
                  DEPENDENCIES[dirFull].source = dependencyInfo.source;
               }

               depends.push(DEPENDENCIES[dirFull].id);

               return prefix + '__MREC__(' + DEPENDENCIES[dirFull].id + ') '
            }
         })
      } else if (linetrim.match(VARIABLE_REGEX)) {
         line = linetrim.replace(VARIABLE_REGEX, function ($0, name, value, $pos, $content) {

            var originalValue = value
            value = value.trim()

            if (value.includes('WaitForChild')) {
               value = value.replace(/:WaitForChild\(['"]([^'"]*)['"]\)/g, '.$1')
            }

            if (value.includes('FindFirstChild')) {
               value = value.replace(/:FindFirstChild\(['"]([^'"]*)['"]\)/g, '.$1')
            }

            if (value.match(/[()\[\]:{}]/g)) {
               // ignore, is function call or table
               return 'local ' + name + ' = ' + originalValue
            }

            var varPath = ''
            var dirPath = ''
            value.split('.').forEach((part) => {
               if (VARIABLE_ALIAS[varPath]) {
                  VARIABLE_ALIAS[varPath + '.' + part] = VARIABLE_ALIAS[varPath] + '.' + part
               }

               if (varPath != '') {
                  varPath += '.'
               }
               varPath += part

               if (SERVICES[varPath]) {
                  VARIABLE_ALIAS[varPath] = '__S_' + varPath
                  varPath = VARIABLE_ALIAS[varPath]
               }

               if (VARIABLE_ALIAS[varPath]) {
                  varPath = VARIABLE_ALIAS[varPath]
               }

               if (VARIABLE_PATH[varPath]) {
                  dirPath = VARIABLE_PATH[varPath]
               } else {
                  dirPath += '/' + part
               }
            })

            VARIABLE_ALIAS[name] = varPath

            var dirFull = path.join(__dirname, dirPath)

            if (fs.existsSync(dirFull)) {
               // is a Rojo directory, ignores the existence of the variable
               VARIABLE_PATH[varPath] = dirPath
               VARIABLE_PATH[name] = dirPath
               if (BUILD_CONFIG.dontIgnoreVarDir.indexOf(dirPath) < 0) {
                  return '-- local ' + name + ' = ' + originalValue + ' -- IGNORED ' + dirPath
               }
            }

            return 'local ' + name + ' = ' + originalValue
         })
      }

      newSource += line + '\n'
   })

   source = newSource

   return {
      depends: depends,
      source: source
   }
}

"""
%%
%% This is file `sagetexparse.py',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% scripts.dtx  (with options: `parsermod')
%% 
%% This is a generated file. It is part of the SageTeX package.
%% 
%% Copyright (C) 2009 by Dan Drake <ddrake@member.ams.org>
%% 
%% This program is free software: you can redistribute it and/or modify it
%% under the terms of the GNU General Public License as published by the
%% Free Software Foundation, either version 2 of the License, or (at your
%% option) any later version.
%% 
%% This program is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%% General Public License for more details.
%% 
%% You should have received a copy of the GNU General Public License along
%% with this program.  If not, see <http://www.gnu.org/licenses/>
%% 
"""
import sys
from pyparsing import *
def skipToMatching(opener, closer):
  nest = nestedExpr(opener, closer)
  nest.setParseAction(lambda l, s, t: l[s:getTokensEndLoc()])
  return nest

curlybrackets = skipToMatching('{', '}')
squarebrackets = skipToMatching('[', ']')
sagemacroparser = '\\sage' + curlybrackets('code')
sageplotparser = ('\\sageplot'
                 + Optional(squarebrackets)('opts')
                 + Optional(squarebrackets)('format')
                 + curlybrackets('code'))
class SoutParser():
  def __init__(self, fn):
    self.label = {}
    parselabel = ('\\newlabel{@sageinline'
                 + Word(nums)('num')
                 + '}{'
                 + curlybrackets('result')
                 + '{}{}{}{}}')
    parselabel.ignore('%' + restOfLine)
    parselabel.setParseAction(self.newlabel)
    try:
      OneOrMore(parselabel).parseFile(fn)
    except IOError:
      print 'Error accessing %s; exiting. Does your .sout file exist?' % fn
      sys.exit(1)
  def newlabel(self, s, l, t):
    self.label[int(t.num)] = t.result[1:-1]
class DeSageTex():
  def __init__(self, fn):
    self.sagen = 0
    self.plotn = 0
    self.fn = fn
    self.sout = SoutParser(fn + '.sout')
    smacro = sagemacroparser
    smacro.setParseAction(self.sage)
    usepackage = ('\\usepackage'
                 + Optional(squarebrackets)
                 + '{sagetex}')
    usepackage.setParseAction(replaceWith("""\\RequirePackage{verbatim}
\\RequirePackage{graphicx}"""))
    splot = sageplotparser
    splot.setParseAction(self.plot)
    beginorend = oneOf('begin end')
    blockorverb = 'sage' + oneOf('block verbatim')
    blockorverb.setParseAction(replaceWith('verbatim'))
    senv = '\\' + beginorend + '{' + blockorverb + '}'
    silent = Literal('sagesilent')
    silent.setParseAction(replaceWith('comment'))
    ssilent = '\\' + beginorend + '{' + silent + '}'
    stexindent = Suppress('\\setlength{\\sagetexindent}' + curlybrackets)
    doit = smacro | senv | ssilent | usepackage | splot | stexindent
    doit.ignore('%' + restOfLine)
    doit.ignore('\\begin{verbatim}' + SkipTo('\\end{verbatim}'))
    doit.ignore('\\begin{comment}' + SkipTo('\\end{comment}'))
    str = ''.join(open(fn + '.tex', 'r').readlines())
    self.result = doit.transformString(str)
  def sage(self, s, l, t):
    self.sagen += 1
    return self.sout.label[self.sagen - 1]
  def plot(self, s, l, t):
    self.plotn += 1
    if len(t.opts) == 0:
      opts = '[width=.75\\textwidth]'
    else:
      opts = t.opts[0]
    return ('\\includegraphics%s{sage-plots-for-%s.tex/plot-%s}' %
      (opts, self.fn, self.plotn - 1))
class SageCodeExtractor():
  def __init__(self, fn):
    smacro = sagemacroparser
    smacro.setParseAction(self.macroout)

    splot = sageplotparser
    splot.setParseAction(self.plotout)
    env_names = oneOf('sageblock sageverbatim sagesilent')
    senv = '\\begin{' + env_names('env') + '}' + SkipTo(
           '\\end{' + matchPreviousExpr(env_names) + '}')('code')
    senv.leaveWhitespace()
    senv.setParseAction(self.envout)

    doit = smacro | splot | senv

    str = ''.join(open(fn + '.tex', 'r').readlines())
    self.result = ''

    doit.transformString(str)

  def macroout(self, s, l, t):
    self.result += '# \\sage{} from line %s\n' % lineno(l, s)
    self.result += t.code[1:-1] + '\n\n'

  def plotout(self, s, l, t):
    self.result += '# \\sageplot{} from line %s:\n' % lineno(l, s)
    if t.format is not '':
      self.result += '# format: %s' % t.format[0][1:-1] + '\n'
    self.result += t.code[1:-1] + '\n\n'

  def envout(self, s, l, t):
    self.result += '# %s environment from line %s:' % (t.env,
      lineno(l, s))
    self.result += t.code[0] + '\n'

"""
\endinput
%%
%% End of file `sagetexparse.py'.
"""

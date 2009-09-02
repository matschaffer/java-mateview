package com.redcareditor.mate;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import com.redcareditor.plist.Dict;

public class GrammarTest {
	private Grammar g;

	@Before
	public void setUp() {
		Dict ruby;
		ruby = Dict.parseFile("input/Bundles/Apache.tmbundle/Syntaxes/Apache.plist");
		g = new Grammar(ruby);
		g.initForUse();
	}

	@Test
	public void shouldLoadGrammarInformation() {
		assertEquals("Apache", g.name);
		assertEquals("source.apache-config", g.scopeName);
	}

	@Test
	public void shouldLoadPatternsIntoMemory() {
		assertTrue("allPatterns is not empty", g.allPatterns.size() > 0);
		List<String> patternNames = patternNames(g.allPatterns);
		assertTrue(patternNames.contains("comment.line.number-sign.apache-config"));
		assertTrue(patternNames.contains("source.include.apache-config"));
		assertTrue(patternNames.contains("support.constant.apache-config"));
	}

  @Test
  public void shouldLoadPatternsWithoutNames() {
    Pattern foundPattern = find(g.allPatterns, new Predicate() {
      public boolean match(Pattern p) {
        return (p instanceof DoublePattern) &&
               ((DoublePattern)p).bothCaptures != null &&
               ((DoublePattern)p).bothCaptures.values().contains("support.constant.rewritecond.apache-config");
      }
    });
    assertNotNull("Unable to find unnamed rewrite pattern", foundPattern);
  }

  public void assertNotIncludePattern(Pattern p) {
    assertFalse(p instanceof IncludePattern);
  }

  @Test
  public void shouldReplaceAllIncludePatterns() {
    for (Pattern p : g.allPatterns) {
      assertNotIncludePattern(p);
      if (p instanceof DoublePattern) {
        for (Pattern p1 : ((DoublePattern)p).patterns) {
          assertNotIncludePattern(p1);
          if (p1 instanceof DoublePattern) {
            for (Pattern p2 : ((DoublePattern)p1).patterns)
            assertNotIncludePattern(p2);
          }
        }
      }
    }
  }

  @Test
  public void shouldReplacePatternBaseProperly() {
    Pattern p = find(g.allPatterns, new Predicate() {
      public boolean match(Pattern p) {
        return "meta.vhost.apache-config".equals(p.name);
      }
    });
    if (p instanceof DoublePattern) {
      List<String> patternNames = patternNames(((DoublePattern)p).patterns);
      assertTrue(patternNames.contains("meta.vhost.apache-config"));
    } else {
      fail("Expected \"meta.vhost.apache-config\" to parse as a DoublePattern.");
    }
  }

	@Test
	public void shouldLoadCaptures() {
		for (Pattern p : g.allPatterns) {
			if ("comment.line.number-sign.apache-config".equals(p.name)) {
				assertEquals("punctuation.definition.comment.apache-config", ((SinglePattern) p).captures.get(1));
			}
		}
	}

  public ArrayList<String> patternNames(List<Pattern> patterns) {
    ArrayList<String> result = new ArrayList<String>();
    for (Pattern p : patterns) {
      result.add(p.name);
    }
    return result;
  }

  public Pattern find(List<Pattern> patterns, Predicate pred) {
    for (Pattern p : patterns) {
      if (pred.match(p)) {
        return p;
      }
    }
    return null;
  }

  interface Predicate {
    public boolean match(Pattern p);
  }
}

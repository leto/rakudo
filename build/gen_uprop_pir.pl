#!/usr/bin/perl
# Copyright (C) 2008, The Perl Foundation.
# $Id$

use strict;
use warnings;

my @prop = qw(
    Alphabetic
    Any
    Arabic
    Armenian
    ASCIIHexDigit
    Assigned
    Bengali
    BidiEN
    BidiES
    BidiET
    BidiL
    BidiWS
    Bopomofo
    Buhid
    C
    CanadianAboriginal
    Cc
    Cf
    Cherokee
    ClosePunctuation
    Common
    ConnectorPunctuation
    Control
    CurrencySymbol
    Cyrillic
    Dash
    DashPunctuation
    DecimalNumber
    Deseret
    Devanagari
    Diacritic
    EnclosingMark
    Ethiopic
    Extender
    FinalPunctuation
    Format
    Georgian
    Gothic
    GraphemeLink
    Greek
    Gujarati
    Gurmukhi
    Han
    Hangul
    Hanunoo
    Hebrew
    HexDigit
    Hiragana
    Hyphen
    ID_Continue
    Ideographic
    IDSBinaryOperator
    ID_Start
    IDSTrinaryOperator
    InAlphabeticPresentationForms
    InArabic
    InArabicPresentationFormsA
    InArabicPresentationFormsB
    InArmenian
    InArrows
    InBasicLatin
    InBengali
    InBlockElements
    InBopomofo
    InBopomofoExtended
    InBoxDrawing
    InBraillePatterns
    InBuhid
    InByzantineMusicalSymbols
    InCherokee
    InCJKCompatibility
    InCJKCompatibilityForms
    InCJKCompatibilityIdeographs
    InCJKCompatibilityIdeographsSupplement
    InCJKRadicalsSupplement
    InCJKSymbolsAndPunctuation
    InCJKUnifiedIdeographs
    InCJKUnifiedIdeographsExtensionA
    InCJKUnifiedIdeographsExtensionB
    InCombiningDiacriticalMarks
    InCombiningDiacriticalMarksforSymbols
    InCombiningHalfMarks
    InControlPictures
    InCurrencySymbols
    InCyrillic
    InCyrillicSupplementary
    InDeseret
    InDevanagari
    InDingbats
    InEnclosedAlphanumerics
    InEnclosedCJKLettersAndMonths
    InEthiopic
    InGeneralPunctuation
    InGeometricShapes
    InGeorgian
    InGothic
    InGreekAndCoptic
    InGreekExtended
    InGujarati
    InGurmukhi
    InHalfwidthAndFullwidthForms
    InHangulCompatibilityJamo
    InHangulJamo
    InHangulSyllables
    InHanunoo
    InHebrew
    Inherited
    InHighPrivateUseSurrogates
    InHighSurrogates
    InHiragana
    InIdeographicDescriptionCharacters
    InIPAExtensions
    InitialPunctuation
    InKanbun
    InKangxiRadicals
    InKannada
    InKatakana
    InKatakanaPhoneticExtensions
    InKhmer
    InLao
    InLatin1Supplement
    InLatinExtendedA
    InLatinExtendedAdditional
    InLatinExtendedB
    InLetterlikeSymbols
    InLowSurrogates
    InMalayalam
    InMathematicalAlphanumericSymbols
    InMathematicalOperators
    InMiscellaneousMathematicalSymbolsA
    InMiscellaneousMathematicalSymbolsB
    InMiscellaneousSymbols
    InMiscellaneousTechnical
    InMongolian
    InMusicalSymbols
    InMyanmar
    InNumberForms
    InOgham
    InOldItalic
    InOpticalCharacterRecognition
    InOriya
    InPrivateUseArea
    InRunic
    InSinhala
    InSmallFormVariants
    InSpacingModifierLetters
    InSpecials
    InSuperscriptsAndSubscripts
    InSupplementalArrowsA
    InSupplementalArrowsB
    InSupplementalMathematicalOperators
    InSupplementaryPrivateUseAreaA
    InSupplementaryPrivateUseAreaB
    InSyriac
    InTagalog
    InTagbanwa
    InTags
    InTamil
    InTelugu
    InThaana
    InThai
    InTibetan
    InUnifiedCanadianAboriginalSyllabics
    InVariationSelectors
    InYiRadicals
    InYiSyllables
    JoinControl
    Kannada
    Katakana
    Khmer
    L
    Lao
    Latin
    Letter
    LetterNumber
    LineSeparator
    Ll
    Lm
    Lo
    LogicalOrderException
    Lowercase
    LowercaseLetter
    Lr
    Lt
    Lu
    M
    Malayalam
    Mark
    Math
    MathSymbol
    Mc
    Me
    Mn
    ModifierLetter
    ModifierSymbol
    Mongolian
    Myanmar
    N
    Nd
    Nl
    No
    NoncharacterCodePoint
    NonspacingMark
    Number
    Ogham
    OldItalic
    OpenPunctuation
    Oriya
    Other
    OtherAlphabetic
    OtherDefaultIgnorableCodePoint
    OtherGraphemeExtend
    OtherLetter
    OtherLowercase
    OtherMath
    OtherNumber
    OtherPunctuation
    OtherSymbol
    OtherUppercase
    P
    ParagraphSeparator
    Pc
    Pd
    Pe
    Pf
    Pi
    Po
    Ps
    Punctuation
    QuotationMark
    Radical
    Runic
    S
    Sc
    Separator
    Sinhala
    Sk
    Sm
    So
    SoftDotted
    SpaceSeparator
    SpacingMark
    Symbol
    Syriac
    Tagalog
    Tagbanwa
    Tamil
    Telugu
    TerminalPunctuation
    Thaana
    Thai
    Tibetan
    TitlecaseLetter
    Unassigned
    UnifiedIdeograph
    Uppercase
    UppercaseLetter
    WhiteSpace
    Yi
    Z
    Zl
    Zp
    Zs
);

my $output = $ARGV[0] || '-';

open my $fh, "> $output" or die "Could not write $output: $!";
print $fh qq{

    .HLL 'parrot'
    .namespace ['PGE';'Match']
    
    .sub '!uprop' :anon
        .param pmc mob
        .param string uprop
        .local string target
        \$P0 = get_hll_global ['PGE'], 'Match'
        (mob, \$I0, target) = \$P0.'new'(mob)
        \$I1 = is_uprop uprop, target, \$I0
        unless \$I1 goto end
        inc \$I0
        mob.'to'(\$I0)
      end:
        .return (mob)
    .end
};

for (@prop) {
    print $fh qq(
        .sub 'is$_' :method
            .tailcall '!uprop'(self, '$_')
        .end
    );
}
        
close $fh or die $!;

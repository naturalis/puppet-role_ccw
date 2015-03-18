-- phpMyAdmin SQL Dump
-- version 4.2.10
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Mar 18, 2015 at 09:51 AM
-- Server version: 5.5.38
-- PHP Version: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ccw`
--

-- --------------------------------------------------------

--
-- Table structure for table `CCW_Citats`
--

DROP TABLE IF EXISTS `ccw_citats`;
CREATE TABLE `ccw_citats` (
  `recordId` int(10) unsigned NOT NULL DEFAULT '0',
  `family_` varchar(25) DEFAULT NULL,
  `subfamily_` varchar(25) DEFAULT NULL,
  `genus_` varchar(25) DEFAULT NULL,
  `subg_` varchar(25) DEFAULT NULL,
  `spec_` varchar(25) DEFAULT NULL,
  `subsp_` varchar(25) DEFAULT NULL,
  `auth_` varchar(250) DEFAULT NULL,
  `year_` varchar(10) DEFAULT NULL,
  `ISO_country_code` varchar(5) DEFAULT NULL,
  `taxonomy_` varchar(10) DEFAULT NULL,
  `biology_` varchar(10) DEFAULT NULL,
  `altit_` varchar(25) DEFAULT NULL,
  `month_` varchar(50) DEFAULT NULL,
  `item_sequence_` varchar(255) DEFAULT NULL,
  `CCW_country_code_` varchar(10) DEFAULT NULL,
  `checked_` varchar(10) DEFAULT NULL,
  `distribution_` varchar(10) DEFAULT NULL,
  `citation_` text,
  `ISOcountrycode_` varchar(255) DEFAULT NULL,
  `itemsequence_` varchar(255) DEFAULT NULL,
  `CCWcountrycode_` varchar(255) DEFAULT NULL,
  `checkedccw_` varchar(255) DEFAULT NULL,
  `checkedrefs_` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `CCW_Refs`
--

DROP TABLE IF EXISTS `ccw_refs`;
CREATE TABLE `ccw_refs` (
  `RecordId` int(10) unsigned NOT NULL DEFAULT '0',
  `remarksoncitinganddating_` text,
  `title_` text,
  `publ__` text,
  `notes_` text,
  `authorID_` varchar(255) DEFAULT NULL,
  `author_` varchar(255) DEFAULT NULL,
  `year_` varchar(10) DEFAULT NULL,
  `seq__` varchar(10) DEFAULT NULL,
  `yearseq__` varchar(15) DEFAULT NULL,
  `author_sreprintnr_` varchar(255) DEFAULT NULL,
  `checkedforCCW_` varchar(255) DEFAULT NULL,
  `publ_date_` varchar(255) DEFAULT NULL,
  `source_` varchar(255) DEFAULT NULL,
  `yearasgivenbyauthor_` varchar(255) DEFAULT NULL,
  `refnr_` int(10) DEFAULT NULL,
  `remarksoncitationanddating_` varchar(255) DEFAULT NULL,
  `listnr_` varchar(255) DEFAULT NULL,
  `region_` varchar(255) DEFAULT NULL,
  `Creation_` varchar(255) DEFAULT NULL,
  `Scans_` varchar(255) DEFAULT NULL,
  `Changed_` varchar(255) DEFAULT NULL,
  `Download_` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `CCW_Taxa`
--

DROP TABLE IF EXISTS `ccw_taxa`;
CREATE TABLE `ccw_taxa` (
  `RecordId` int(10) unsigned NOT NULL DEFAULT '0',
  `family_` varchar(25) DEFAULT NULL,
  `subfamily_` varchar(25) DEFAULT NULL,
  `notes_` text,
  `distr_` text,
  `genus_` varchar(50) DEFAULT NULL,
  `subg_` varchar(50) DEFAULT NULL,
  `spec_` varchar(50) DEFAULT NULL,
  `subsp_` varchar(50) DEFAULT NULL,
  `auth_` varchar(100) DEFAULT NULL,
  `descr_` varchar(255) DEFAULT NULL,
  `syns_` text,
  `revision_` varchar(100) DEFAULT NULL,
  `distr_gen_notes_` text,
  `descr_taxon_notes_` text,
  `imm_stagesandbiology_` text,
  `orig_genus_` varchar(100) DEFAULT NULL,
  `orig_name_` varchar(100) DEFAULT NULL,
  `na_` varchar(5) DEFAULT NULL,
  `wp_` varchar(5) DEFAULT NULL,
  `ep_` varchar(5) DEFAULT NULL,
  `no_` varchar(5) DEFAULT NULL,
  `af_` varchar(5) DEFAULT NULL,
  `ori_` varchar(5) DEFAULT NULL,
  `ao_` varchar(5) DEFAULT NULL,
  `sp_gr_` tinyint(4) DEFAULT NULL,
  `ssp_` tinyint(4) DEFAULT NULL,
  `syn_` tinyint(4) DEFAULT NULL,
  `nontip_` tinyint(4) DEFAULT NULL,
  `highertaxon_` varchar(25) DEFAULT NULL,
  `unrdf_` tinyint(4) DEFAULT NULL,
  `userfield_` text,
  `catnr_` int(11) DEFAULT NULL,
  `spell_` varchar(255) DEFAULT NULL,
  `spellcomm_` text,
  `misident__` text,
  `tobechecked_` text,
  `yearnr_` varchar(10) DEFAULT NULL,
  `reprintnr_` text,
  `figslisted_` text,
  `checkedorig_descr__` text,
  `preocc_` text,
  `searchalladdit_fields_` text,
  `habitus_` text,
  `head_` text,
  `wing_` text,
  `hypopygium_` text,
  `ovipositor_` text,
  `other_` text,
  `egg_` text,
  `larva_` text,
  `pupa_` text,
  `distribution_` text,
  `miscellaneous_` text,
  `searchinfig_fields_` text,
  `catalogue_` text,
  `typeloc__` text,
  `descr_as_` varchar(100) DEFAULT NULL,
  `keys_` text,
  `userfield2_` varchar(255) DEFAULT NULL,
  `Image_types_` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
`Id` int(11) NOT NULL,
  `RecordId` bigint(15) NOT NULL,
  `File_` varchar(100) NOT NULL,
  `Type_` varchar(20) NOT NULL,
  `Subtype_` varchar(20) NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `CCW_Citats`
--
ALTER TABLE `ccw_citats`
 ADD PRIMARY KEY (`recordId`), ADD KEY `year_` (`year_`), ADD KEY `CCW_country_code_` (`CCW_country_code_`), ADD KEY `fullname` (`genus_`,`subg_`,`spec_`,`subsp_`), ADD KEY `auth_` (`auth_`);

--
-- Indexes for table `CCW_Refs`
--
ALTER TABLE `ccw_refs`
 ADD PRIMARY KEY (`RecordId`), ADD KEY `author_` (`author_`), ADD KEY `yearseq__` (`yearseq__`), ADD KEY `yearseq___2` (`yearseq__`);

--
-- Indexes for table `CCW_Taxa`
--
ALTER TABLE `ccw_taxa`
 ADD PRIMARY KEY (`RecordId`), ADD KEY `wp_` (`wp_`), ADD KEY `na_` (`na_`), ADD KEY `ep_` (`ep_`), ADD KEY `spec_` (`spec_`), ADD KEY `family_` (`family_`), ADD KEY `no_` (`no_`), ADD KEY `af_` (`af_`), ADD KEY `ori_` (`ori_`), ADD KEY `ao_` (`ao_`), ADD KEY `subg_` (`subg_`), ADD KEY `subsp_` (`subsp_`), ADD KEY `fullname` (`genus_`,`subg_`,`spec_`,`subsp_`), ADD KEY `auth_` (`auth_`), ADD KEY `Image_types_` (`Image_types_`), ADD KEY `sp_gr_` (`sp_gr_`), ADD KEY `Image_types__2` (`Image_types_`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
 ADD PRIMARY KEY (`Id`), ADD KEY `RecordId` (`RecordId`), ADD KEY `Type_` (`Type_`), ADD KEY `Subtype_` (`Subtype_`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=34;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

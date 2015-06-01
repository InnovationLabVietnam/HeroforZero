-- phpMyAdmin SQL Dump
-- version 4.2.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: May 26, 2015 at 07:04 PM
-- Server version: 5.6.21
-- PHP Version: 5.6.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `heroforzero`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_allquestofuseraccept`(IN iUserId INT)
BEGIN
	SELECT * FROM quest
	INNER JOIN user_quest
	ON quest.id = user_quest.quest_id
	WHERE user_quest.user_id = iUserId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checksignupwithemailinfo`(iFullName VARCHAR(100),
											iHeroName VARCHAR(100),
											iEmail VARCHAR(100),
											iPhoneNumber VARCHAR(100),
											iPassword VARCHAR(100))
BEGIN
	IF EXISTS(SELECT * FROM user WHERE email = iEmail OR hero_name = iHeroName) THEN
		SELECT -1 AS id;
	ELSE
		INSERT INTO user(full_name, hero_name, email, phone_number, `password`, register_date)
		VALUES(iFullName, iHeroName, iEmail, iPhoneNumber, iPassword, NOW());
		SELECT * FROM user WHERE hero_name = iHeroName;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checksignupwithfacebookinfo`(IN iFacebookId VARCHAR(100),
												IN iFullName VARCHAR(100),
												IN iHeroName VARCHAR(100),
												IN iEmail VARCHAR(100))
BEGIN

	IF EXISTS(SELECT * FROM user WHERE facebook_id = iFacebookId OR hero_name = iHeroName) THEN
		 SELECT '0' as `code`, user.*, (SELECT COUNT(*) FROM user_quest WHERE user_quest.user_id = (SELECT id FROM user WHERE facebook_id = iFacebookId)) AS quest_count FROM user WHERE facebook_id = iFacebookId;
	ELSE
		INSERT INTO user(full_name, hero_name, email, facebook_id, register_date)
		VALUES(iFullName, iHeroName, iEmail, iFacebookId, NOW());
		SELECT '1' as `code`, user.*, (SELECT COUNT(*) FROM user_quest WHERE user_quest.user_id = (SELECT id FROM user WHERE facebook_id = iFacebookId)) AS quest_count FROM user WHERE facebook_id = iFacebookId;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_completeQuestProcess`(IN inUserId INT, IN inQuestId INT)
BEGIN
	DECLARE nextQuestId INT;
	SET @nextQuestId = (SELECT MIN(Id) FROM virtualquest WHERE Id > inQuestId);
	UPDATE uservirtualquest SET `Status` = 2 WHERE UserId = inUserId AND QuestId = inQuestId;
	IF (NOT EXISTS (SELECT * FROM uservirtualquest WHERE UserId = inUserId AND QuestId = @nextQuestId)) THEN
		INSERT INTO uservirtualquest VALUES (inUserId, @nextQuestId, 1);
	END IF;
	SELECT v.Id AS virtualquestId,v.QuestName AS QuestName,v.PacketId AS PacketId,v.PartnerId AS PartnerId,v.AnimationId AS AnimationId, v.UnlockPoint AS UnlockPoint, v.CreateDate AS virtualquestCreateDate, v.ImageURL AS questImageUrl
			,k.Title AS packetTitle,k.ImageURL AS packetImageURL
			,p.PartnerName AS PartnerName, p.OrganizationTypeId AS OrganizationTypeId, p.Address AS partnerAddress, p.PhoneNumber AS PhoneNumber, p.WebsiteURL AS partnerWebsiteUrl, p.Latitude AS Latitude, p.Longtitude AS Longtitude, p.Description AS partnerDescription, p.IsApproved AS partnerIsApproved, p.LogoURL AS partnerLogoUrl, p.IconURL AS partnerIconUrl
			,c.Id AS conditionId, c.Type AS conditionType, c.Value AS conditionValue, c.ObjectId AS ObjectId
			,a.Id AS Id, a.Title AS Title, a.Description AS Description, a.IsApproved AS IsApproved, a.CreateDate AS CreateDate
			, a.ActionId AS activityActionId, a.BonusPoint AS activityBonusPoint, a.ActionContent AS activityActionContent,'' AS donationRequiredPoint, '' AS donationMedalId, '' AS medalImageUrl
			,(SELECT p.WebsiteURL FROM partner p WHERE p.Id = a.PartnerId) AS WebUrl
			,(SELECT p.IconURL FROM partner p WHERE p.Id = a.PartnerId) AS IconUrl
	FROM virtualquest v 
	JOIN partner p ON v.PartnerId = p.Id
	JOIN packet k ON v.PacketId = k.Id 
	JOIN questcondition c ON v.Id = c.VirtualQuestId AND c.`Type` = 1
	JOIN activity a ON a.Id = c.`ObjectId`
	WHERE v.Id = @nextQuestId

	UNION

	SELECT v.Id AS virtualquestId,v.QuestName AS QuestName,v.PacketId AS PacketId,v.PartnerId AS PartnerId,v.AnimationId AS AnimationId, v.UnlockPoint AS UnlockPoint, v.CreateDate AS virtualquestCreateDate, v.ImageURL AS questImageUrl
			,k.Title AS packetTitle,k.ImageURL AS packetImageURL
			,p.PartnerName AS PartnerName, p.OrganizationTypeId AS OrganizationTypeId, p.Address AS partnerAddress, p.PhoneNumber AS PhoneNumber, p.WebsiteURL AS partnerWebsiteUrl, p.Latitude AS Latitude, p.Longtitude AS Longtitude, p.Description AS partnerDescription, p.IsApproved AS partnerIsApproved, p.LogoURL AS partnerLogoUrl, p.IconURL AS partnerIconUrl
			,c.Id AS conditionId, c.Type AS conditionType, c.Value AS conditionValue, c.ObjectId AS ObjectId
			,d.Id AS Id, d.Title AS Title, d.Description AS Description, d.IsApproved AS IsApproved, d.CreateDate AS CreateDate
			,'' AS activityActionId, '' AS activityBonusPoint, '' AS activityActionContent, d.RequiredPoint AS donationRequiredPoint, d.MedalId AS donationMedalId, m.ImageURL AS medalImageUrl
			, (SELECT p.WebsiteURL FROM partner p WHERE p.Id = d.PartnerId) AS WebUrl
			, (SELECT p.IconURL FROM partner p WHERE p.Id = d.PartnerId) AS IconUrl
	FROM virtualquest v 
	JOIN partner p ON v.PartnerId = p.Id
	JOIN packet k ON v.PacketId = k.Id 
	JOIN questcondition c ON v.Id = c.VirtualQuestId AND c.`Type` = 2
	JOIN donation d ON d.Id = c.`ObjectId`
	JOIN medal m ON m.Id = d.MedalId
	WHERE v.Id = @nextQuestId

	UNION

	SELECT v.Id AS virtualquestId,v.QuestName AS QuestName,v.PacketId AS PacketId,v.PartnerId AS PartnerId,v.AnimationId AS AnimationId, v.UnlockPoint AS UnlockPoint, v.CreateDate AS virtualquestCreateDate, v.ImageURL AS questImageUrl
			,k.Title AS packetTitle,k.ImageURL AS packetImageURL
			,p.PartnerName AS PartnerName, p.OrganizationTypeId AS OrganizationTypeId, p.Address AS partnerAddress, p.PhoneNumber AS PhoneNumber, p.WebsiteURL AS partnerWebsiteUrl, p.Latitude AS Latitude, p.Longtitude AS Longtitude, p.Description AS partnerDescription, p.IsApproved AS partnerIsApproved, p.LogoURL AS partnerLogoUrl, p.IconURL AS partnerIconUrl
			,c.Id AS conditionId, c.Type AS conditionType, c.Value AS conditionValue, c.ObjectId AS ObjectId
			,'' AS Id, CONCAT('Earn ', c.`Value`, ' points') AS Title, '' AS Description, '' AS IsApproved, '' AS CreateDate,'' AS activityActionId, '' AS activityBonusPoint, '' AS activityActionContent,'' AS donationRequiredPoint, '' AS donationMedalId, '' AS medalImageUrl
			,'' AS WebUrl, '' AS IconUrl
	FROM virtualquest v 
	JOIN partner p ON v.PartnerId = p.Id
	JOIN packet k ON v.PacketId = k.Id 
	JOIN questcondition c ON v.Id = c.VirtualQuestId AND c.`Type` = 0
	WHERE v.Id = @nextQuestId

	ORDER BY conditionType;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Delete_Activity`(Id INT)
BEGIN
		DELETE FROM  activity
			WHERE activity.Id = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Delete_Donation`(Id INT)
BEGIN
		DELETE FROM  donation
			WHERE donation.Id = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Delete_Partner`(Id INT)
BEGIN
	SET @Id = Id;

	-- Delete in 4 table:
	DELETE userrole, user, userpartner, partner FROM userrole inner join userpartner inner join user inner join partner
			WHERE userrole.UserId = userpartner.UserId
			AND userpartner.UserId = user.Id
			AND partner.Id = @Id
			and userpartner.PartnerId = @Id ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_player`(
	IN id INT
)
BEGIN
	# Using transaction for query
	DECLARE exit handler for sqlexception
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	DECLARE exit handler for sqlwarning
	BEGIN
		-- WARNING
		ROLLBACK;
	END;

	START TRANSACTION;
	
	# Start reset user
	# Delete other quest ID rather than 1 from uservirtualquest.
	DELETE FROM uservirtualquest
		WHERE UserId = id;

	# Delete data from usermedal table
	DELETE from usermedal
		WHERE UserId = id;

	# Delete data from usercondition table
	DELETE from usercondition
		WHERE UserId = id;

	# Reset data in userapplication table
	DELETE from userapplication 
		WHERE UserId = id;

	DELETE from user 
		WHERE user.Id = id;

	# End delete user

	COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Delete_QuestCondition`(Id INT)
BEGIN
	DELETE FROM  questcondition WHERE VirtualQuestId = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Delete_Quiz`(Id INT)
BEGIN
	DELETE FROM  quiz
		WHERE quiz.Id = Id;
				
	DELETE FROM  choice
		WHERE choice.QuestionId = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Delete_VirtualQuest`(Id INT)
BEGIN
	DELETE FROM  virtualquest
			WHERE virtualquest.Id = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getActivitiesByPartnerId`(IN partnerId INT)
BEGIN
	SELECT * FROM Activity WHERE PartnerId = partnerId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getDonationBy`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	SET @currentPage = currentPage + 1;
	SET @rowNumber = currentPage * pageSize;
	SET @pageSize = pageSize;
	#select @currentPage as a, @rowNumber as b, pageSize as c;
	PREPARE STMT FROM
	"SELECT * FROM donation d JOIN medal m ON d.MedalId = m.Id LIMIT ?,?";
	EXECUTE STMT USING @rowNumber, @pageSize;
	DEALLOCATE PREPARE STMT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getNumberOfChildrenByUserId`()
BEGIN
	SELECT (7000000 - COUNT(QuestId)) AS `numOfChildren` FROM uservirtualquest WHERE Status = 2;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetOrganizationList`(
	IN currentPage INTEGER, 
	IN pageSize INTEGER
)
BEGIN
	SET @_pageSize = pageSize;
	SET @_currentPage = currentPage;
	
	SET @rowNumber = (@_currentPage * @_pageSize); 
	
	if (@_pageSize != 0) 
	then
		PREPARE STMT FROM
		"SELECT partner.*, organizationtype.TypeName, user.Email
		FROM 
			organizationtype,
			partner,
			user,
			userpartner
				
		WHERE 
				organizationtype.Id = partner.OrganizationTypeId
				AND user.Id = userpartner.UserId
				AND userpartner.PartnerId = partner.Id
		ORDER BY partner.Id
		LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @_pageSize;
		DEALLOCATE PREPARE STMT;
	else  
		SELECT partner.*, organizationtype.TypeName, user.Email
		FROM 
				organizationtype,
				partner,
				user,
				userpartner
		WHERE 
				organizationtype.Id = partner.OrganizationTypeId
				AND user.Id = userpartner.UserId
				AND userpartner.PartnerId = partner.Id
		ORDER BY partner.Id;
		end if;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getPacketsBy`(IN currentPage INT, IN iPageSize INT)
BEGIN
	DECLARE rowNumber INT;
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * iPageSize;
	SET @pageSize = iPageSize;
	PREPARE STMT FROM
		"SELECT  
			p.Id AS pId,
			p.Title AS pTitle,
			p.ImageURL AS pImageURL,
			p.PartnerId AS pPartnerId,
			v.Id AS vId,
			v.QuestName AS vQuestName,
			v.PacketId AS vPacketId,
			v.QuestName AS vQuestName,
			v.PacketId AS vPacketId,
			v.PartnerId AS vPartnerId,
			v.AnimationId AS vAnimationId,
			v.UnlockPoint AS vUnlockPoint,
			v.CreateDate AS vCreateDate,
            v.ImageURL AS questImageUrl,
			v.MedalId as medalId,
			c.Id AS cId,
			c.Type AS cType,
			c.Value AS cValue,
			c.VirtualQuestId AS cVirtualQuestId,
			c.ObjectId AS cObjectId
		FROM packet p
		JOIN (SELECT Id FROM packet LIMIT ?, ?) ids ON p.Id = ids.Id
		INNER JOIN virtualquest v 
		ON p.Id = v.PacketId
		INNER JOIN questcondition c
		ON c.VirtualQuestId = v.Id
		ORDER BY pId, vId, cId ASC"; 
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getparentquest`(IN iQuestId INT)
BEGIN
	SELECT * FROM quest WHERE id = (SELECT parent_quest_id FROM quest WHERE id = iQuestId);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getquestrefer`(IN iQuestId INT)
BEGIN
	SELECT * FROM quest WHERE parent_quest_id = (SELECT parent_quest_id FROM quest WHERE id = iQuestId) ORDER BY id ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getuserdatawithemail`(IN userName VARCHAR(100), IN pass VARCHAR(100))
BEGIN
	DECLARE userId INT;
	SELECT id INTO userId FROM user WHERE email = userName AND `password` = pass;
	SELECT *,(SELECT COUNT(*) FROM user_quest WHERE user_quest.user_id = userId) AS quest_count FROM user WHERE id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getuserdatawithfacebook`(IN facebookId VARCHAR(100))
BEGIN
	DECLARE userId INT;
	SELECT id INTO userId FROM user WHERE facebook_id = facebookId;
	SELECT *,(SELECT COUNT(*) FROM user_quest WHERE user_quest.user_id = userId) AS quest_count FROM user WHERE id = userId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getVirtualQuestForMobile`(IN inId INT)
BEGIN
	SELECT v.Id as vId,v.QuestName as vQuestName,v.PacketId as vPacketId,v.PartnerId as vPartnerId,v.AnimationId as vAnimationId, v.UnlockPoint as vUnlockPoint, v.CreateDate as vCreateDate, v.ImageURL as vImageURL
			,k.Title AS kTitle,k.ImageURL AS kImageURL
			,p.PartnerName as pPartnerName, p.OrganizationTypeId as pOrganizationTypeId, p.Address as pAddress, p.PhoneNumber as pPhoneNumber, p.WebsiteURL as pWebsiteUrl, p.Latitude as pLatitude, p.Longtitude as pLongtitude, p.Description as pDescription, p.IsApproved as pIsApproved, p.LogoURL as pLogoUrl, p.IconURL as pIconUrl
			,c.Id AS cId, c.Type AS cType, c.Value AS cValue, c.ObjectId AS cObjectId
			,a.Id as Id, a.Title as Title, a.Description as Description, a.IsApproved as IsApproved, a.CreateDate as CreateDate
			, a.ActionId as aActionId, a.BonusPoint as aBonusPoint, a.ActionContent as aActionContent,'' as dRequiredPoint, '' as dMedalId, '' as mImageUrl
			,(SELECT p.WebsiteURL FROM partner p WHERE p.Id = a.PartnerId) AS WebUrl
			,(SELECT p.IconURL FROM partner p WHERE p.Id = a.PartnerId) AS IconUrl
	FROM virtualquest v 
	JOIN partner p ON v.PartnerId = p.Id
	JOIN packet k ON v.PacketId = k.Id 
	JOIN questcondition c ON v.Id = c.VirtualQuestId AND c.`Type` = 1
	JOIN activity a ON a.Id = c.`ObjectId`
	WHERE v.Id = inId

	UNION

	SELECT v.Id as vId,v.QuestName as vQuestName,v.PacketId as vPacketId,v.PartnerId as vPartnerId,v.AnimationId as vAnimationId, v.UnlockPoint as vUnlockPoint, v.CreateDate as vCreateDate, v.ImageURL as vImageURL
			,k.Title AS kTitle,k.ImageURL AS kImageURL
			,p.PartnerName as pPartnerName, p.OrganizationTypeId as pOrganizationTypeId, p.Address as pAddress, p.PhoneNumber as pPhoneNumber, p.WebsiteURL as pWebsiteUrl, p.Latitude as pLatitude, p.Longtitude as pLongtitude, p.Description as pDescription, p.IsApproved as pIsApproved, p.LogoURL as pLogoUrl, p.IconURL as pIconUrl
			,c.Id AS cId, c.Type AS cType, c.Value AS cValue, c.ObjectId AS cObjectId
			,d.Id as Id, d.Title as Title, d.Description as Description, d.IsApproved as IsApproved, d.CreateDate as CreateDate
			,'' as aActionId, '' as aBonusPoint, '' as aActionContent, d.RequiredPoint as dRequiredPoint, d.MedalId as dMedalId, m.ImageURL as mImageUrl
			, (SELECT p.WebsiteURL FROM partner p WHERE p.Id = d.PartnerId) AS WebUrl
			, (SELECT p.IconURL FROM partner p WHERE p.Id = d.PartnerId) AS IconUrl
	FROM virtualquest v 
	JOIN partner p ON v.PartnerId = p.Id
	JOIN packet k ON v.PacketId = k.Id 
	JOIN questcondition c ON v.Id = c.VirtualQuestId AND c.`Type` = 2
	JOIN donation d ON d.Id = c.`ObjectId`
	JOIN medal m ON m.Id = d.MedalId
	WHERE v.Id = inId

	UNION

	SELECT v.Id as vId,v.QuestName as vQuestName,v.PacketId as vPacketId,v.PartnerId as vPartnerId,v.AnimationId as vAnimationId, v.UnlockPoint as vUnlockPoint, v.CreateDate as vCreateDate, v.ImageURL as vImageURL
			,k.Title AS kTitle,k.ImageURL AS kImageURL
			,p.PartnerName as pPartnerName, p.OrganizationTypeId as pOrganizationTypeId, p.Address as pAddress, p.PhoneNumber as pPhoneNumber, p.WebsiteURL as pWebsiteUrl, p.Latitude as pLatitude, p.Longtitude as pLongtitude, p.Description as pDescription, p.IsApproved as pIsApproved, p.LogoURL as pLogoUrl, p.IconURL as pIconUrl
			,c.Id AS cId, c.Type AS cType, c.Value AS cValue, c.ObjectId AS cObjectId
			,'' as Id, CONCAT('Earn ', c.`Value`, ' points') as Title, '' as Description, '' as IsApproved, '' as CreateDate,'' as aActionId, '' as aBonusPoint, '' as aActionContent,'' as dRequiredPoint, '' as dMedalId, '' as mImageUrl
			,'' AS WebUrl, '' AS IconUrl
	FROM virtualquest v 
	JOIN partner p ON v.PartnerId = p.Id
	JOIN packet k ON v.PacketId = k.Id 
	JOIN questcondition c ON v.Id = c.VirtualQuestId AND c.`Type` = 0
	WHERE v.Id = inId

	ORDER BY cType;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_Activity`(id INT)
BEGIN
	SELECT activity.*, partner.PartnerName FROM  activity,  action,  partner
		
			
		WHERE
				activity.PartnerId = partner.Id
			AND
				activity.Id = id;
				
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_ActivityList`(IN currentPage INTEGER, IN pageSize INTEGER)
BEGIN
	#DECLARE rowNumber INT;
	SET @_pageSize = pageSize;
	SET @_currentPage = currentPage;
	
	SET @rowNumber = (@_currentPage * @_pageSize);
	
	if (@_pageSize != 0) 
	then
		PREPARE STMT FROM 
		"SELECT activity.Id, activity.Title, activity.ActionContent, partner.PartnerName, activity.BonusPoint,  activity.IsApproved, activity.CreateDate, partner.IconURL, activity.Description, activity.ActionId, partner.WebsiteUrl
		FROM 
				 activity,
				 partner
		WHERE 
				activity.PartnerId = partner.Id
		ORDER BY activity.CreateDate DESC
		LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @_pageSize;
		DEALLOCATE PREPARE STMT;
	else  
		SELECT activity.Id, activity.Title, activity.ActionContent, partner.PartnerName, activity.BonusPoint,  activity.IsApproved, activity.CreateDate, partner.IconURL, activity.Description, activity.ActionId, partner.WebsiteUrl
		FROM 
				 activity,
				 partner
		WHERE 
				activity.PartnerId = partner.Id
		ORDER BY activity.CreateDate DESC;
		end if;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_ActivityListByOrganization`(IN currentPage INTEGER, IN pageSize INTEGER, partnerId INT)
BEGIN
	#DECLARE rowNumber INT;
	SET @_pageSize = pageSize;
	SET @_currentPage = currentPage;
	SET @partnerId = partnerId;

	SET @rowNumber = (@_currentPage * @_pageSize);
	  
	if (@_pageSize != 0) 
	then
		PREPARE STMT FROM
		"SELECT activity.Id, activity.Title, activity.ActionContent, partner.PartnerName, activity.BonusPoint,  activity.IsApproved, activity.CreateDate, partner.IconURL, activity.Description, activity.ActionId, partner.WebsiteUrl
		FROM 
				 activity,
				 partner
		WHERE 
				activity.PartnerId = partner.Id
				AND activity.PartnerId = ? 
				AND activity.IsApproved = 1
		ORDER BY activity.CreateDate DESC
		LIMIT ?,?";
		EXECUTE STMT USING @partnerId, @rowNumber, @_pageSize;
		DEALLOCATE PREPARE STMT;
	else  
		SELECT activity.Id, activity.Title, activity.ActionContent, partner.PartnerName, activity.BonusPoint,  activity.IsApproved, activity.CreateDate, partner.IconURL, activity.Description, activity.ActionId, partner.WebsiteUrl
		FROM 
				 activity,
				 partner
		WHERE 
				activity.PartnerId = partner.Id
				AND activity.PartnerId = partnerId 
				AND activity.IsApproved = 1
		ORDER BY activity.CreateDate DESC;
		end if;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_Animation`(id INT)
BEGIN
	SELECT * FROM  animation			
		WHERE
				animation.Id = id;
				
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_Donation`(Id INT)
BEGIN
	SELECT donation.Id, donation.Title, donation.Description, donation.PartnerId, partner.PartnerName, donation.RequiredPoint,  donation.IsApproved, donation.CreateDate
		FROM 
				 donation,
				 partner
		WHERE 
				donation.PartnerId = partner.Id
		AND 	donation.Id = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_DonationList`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;
	
	SET @pageSize = pageSize; 
	if (pageSize != 0) 
	then
		PREPARE STMT FROM
		"SELECT donation.Id, donation.Title, partner.PartnerName, donation.RequiredPoint,  donation.IsApproved, donation.CreateDate, medal.ImageURL, donation.Description, donation.MedalId
		FROM 
				 donation,
				 partner,
				 medal
		WHERE 
				donation.PartnerId = partner.Id
				AND medal.Id = donation.MedalId
		ORDER BY donation.CreateDate DESC
		LIMIT  ?,?";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	else  
		SELECT donation.Id, donation.Title, partner.PartnerName, donation.RequiredPoint,  donation.IsApproved, donation.CreateDate, medal.ImageURL, donation.Description, donation.MedalId
		FROM 
				 donation,
				 partner,
				 medal
		WHERE 
				donation.PartnerId = partner.Id
				AND medal.Id = donation.MedalId
		ORDER BY donation.CreateDate DESC;
		END if;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_DonationListByOrganization`(IN currentPage INT, IN pageSize INT, partnerId INT)
BEGIN
	DECLARE rowNumber int;
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;
	 
	SET @pageSize = pageSize;
	SET @partnerId = partnerId;
	if (pageSize != 0) 
	then
		PREPARE STMT FROM
		"SELECT donation.Id, donation.Title, partner.PartnerName, donation.RequiredPoint,  donation.IsApproved, donation.CreateDate, medal.ImageURL, donation.Description, donation.MedalId
		FROM 
				 donation,
				 partner,
				 medal
		WHERE 
				donation.PartnerId = partner.Id
				AND medal.Id = donation.MedalId
				AND donation.PartnerId = ? 
				AND donation.IsApproved = 1
		ORDER BY donation.CreateDate DESC
		LIMIT  ?,?";
		EXECUTE STMT USING @partnerId, @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	else  
		SELECT donation.Id, donation.Title, partner.PartnerName, donation.RequiredPoint,  donation.IsApproved, donation.CreateDate, medal.ImageURL, donation.Description, donation.MedalId
		FROM 
				 donation,
				 partner,
				 medal
		WHERE 
				donation.PartnerId = partner.Id
				AND medal.Id = donation.MedalId
				AND donation.PartnerId = partnerId
				AND donation.IsApproved = 1
		ORDER BY donation.CreateDate DESC;
		END if;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_Leaderboard`(IN currentPage INT, IN pageSize INT, IN friends NVARCHAR(5000))
BEGIN
	DECLARE rowNumber INT;
	SET @pageSize = pageSize;
	SET @rowNumber = currentPage * pageSize;
	SET @friends = friends; -- List of facebook id in format: "0123, 02343254, 23234"
	SET @getmore = true;
	
	-- we select from user's friend first. If there are no friend, select from all user.
	if (@friends IS NOT NULL OR @friends != '')
	then
		if (pageSize != 0)
		then 
			SET @myquery1 = 
			"SELECT userapplication.UserId as id, user.FullName as name, user.AvatarId as avatar, userapplication.Points as mark, userapplication.FacebookId facebook_id, userapplication.CurrentLevel as current_level, @curRank := @curRank+1 as rank
			FROM 
					 userapplication,  user,
					(SELECT @curRank := 0) r
			WHERE userapplication.UserId = user.Id
				AND userapplication.FacebookId IN (";
			set @myquery2 = ")
			order by userapplication.Points DESC
			LIMIT  ?,?";
			set @myquery = CONCAT(@myquery1, @friends, @myquery2);
			PREPARE STMT FROM @myquery;
			EXECUTE STMT USING  @rowNumber, @pageSize;
			DEALLOCATE PREPARE STMT;
		
		else 
			SELECT userapplication.UserId as id, user.FullName as name, user.AvatarId as avatar, userapplication.Points as mark, userapplication.FacebookId facebook_id, userapplication.CurrentLevel as current_level, @curRank := @curRank+1 as rank
			FROM 
					 userapplication,  user,
					(SELECT @curRank := 0) r
			WHERE userapplication.UserId = user.Id
			order by userapplication.Points DESC;
		END if;	
		-- Check if is there any result:
		if (FOUND_ROWS() != 0)
		then 
			SET @getmore = false;
		END if;
	END if;
	

	-- If there are no friend, select from all user.
	if (@getmore = true)
	then
		if (pageSize != 0) 
		then
			PREPARE STMT FROM
			"SELECT userapplication.UserId as id, user.FullName as name, user.AvatarId as avatar, userapplication.Points as mark, userapplication.FacebookId facebook_id, userapplication.CurrentLevel as current_level, @curRank := @curRank+1 as rank
			FROM 
					 userapplication,  user,
					(SELECT @curRank := 0) r
			WHERE userapplication.UserId = user.Id
			order by userapplication.Points DESC
			LIMIT  ?,?";
			EXECUTE STMT USING @rowNumber, @pageSize;
			DEALLOCATE PREPARE STMT;
		
		else  
			SELECT userapplication.UserId as id, user.FullName as name, user.AvatarId as avatar, userapplication.Points as mark, userapplication.FacebookId as facebook_id, userapplication.CurrentLevel as current_level, @curRank := @curRank+1 as rank
			FROM 
					 userapplication,  user,
					(SELECT @curRank := 0) r
			WHERE userapplication.UserId = user.Id
			order by userapplication.Points DESC;
		END if;	
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_PacketAvailableList`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT  * FROM packet p 
		WHERE NOT EXISTS (SELECT PacketId, count from (SELECT PacketId, COUNT(*) as count from virtualquest GROUP BY PacketId) as c where count = 3 AND c.PacketId = p.Id)
		LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	else
		SELECT  * FROM packet p 
		WHERE NOT EXISTS (SELECT PacketId, count from (SELECT PacketId, COUNT(*) as count from virtualquest GROUP BY PacketId) as c where count = 3 AND c.PacketId = p.Id);
	END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_PacketList`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT * FROM  packet
		LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	else
		SELECT * FROM  packet;
	END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_Partner`(IN Id INT)
BEGIN
	SELECT user.*, partner.*, userpartner.UserName, partner.PhoneNumber as phone
		FROM 
				user,
				userpartner,
				partner
		WHERE 
				partner.Id = Id
		AND		partner.Id = userpartner.PartnerId
		AND 	userpartner.UserId = user.Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_PartnerList`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;
	
	if (pageSize != 0) 
	then
		PREPARE STMT FROM
		"SELECT partner.Id, partner.PartnerName, partner.OrganizationTypeId, partner.Address,  partner.PhoneNumber, partner.WebsiteURL, partner.Latitude, partner.Longtitude, partner.Description, partner.IsApproved
		FROM 
				 partner
		order by partner.Id DESC
		LIMIT  ?,?";
		EXECUTE STMT USING @rowNumber, @_pageSize;
		DEALLOCATE PREPARE STMT;
	
	else  
		SELECT partner.Id, partner.PartnerName, partner.OrganizationTypeId, partner.Address,  partner.PhoneNumber, partner.WebsiteURL, partner.Latitude, partner.Longtitude, partner.Description, partner.IsApproved
		FROM 
				 partner
		order by partner.Id DESC;
	END if;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuestCondition`(Id INT)
BEGIN
	
		SELECT 
			Id, 
			Type, 
			ObjectId,
			Value
		FROM  questcondition
		WHERE questcondition.VirtualQuestId = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuestCondition_before`(Id INT)
BEGIN
	DECLARE typeCondition INT;
	SET typeCondition = (SELECT Type FROM  questcondition 
								WHERE questcondition.VirtualQuestId = Id);
	
	if(typeCondition = 0) then
		SELECT 
			Id, 
			Type, 
			ObjectId, 
			
			Value
		FROM  virtualquest, questcondition
		WHERE questcondition.VirtualQuestId = Id;

	elseif(typeCondition = 1) then
		SELECT 
			Id, 
			Type, 
			ObjectId, 
			activity.Title as ObjectName,
			Value
		FROM  virtualquest, questcondition, activity
		WHERE 
				questcondition.VirtualQuestId = Id
			AND
				activity.Id = questcondition.ObjectId;

	elseif(typeCondition = 2) then
		SELECT 
			Id, 
			Type, 
			ObjectId, 
			donation.Title as ObjectName,
			Value
		FROM  virtualquest, questcondition, donation
		WHERE 
				questcondition.VirtualQuestId = Id
			AND
				donation.Id = questcondition.ObjectId;
	END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_Quiz`(Id Int)
BEGIN
	SELECT quiz.*, quizcategory.CategoryName, choice.Id, choice.Content as answer, partner.PartnerName 
	FROM quizcategory, 
		 quiz,
		 choice, 
		 partner 
	WHERE 	
				quiz.Id 		= Id
		  AND   quiz.CategoryId = quizcategory.Id
		  AND   quiz.Id 		= choice.QuestionId
		  AND   quiz.PartnerId  = partner.Id;
	
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizCategoryList`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;

	if (pageSize != 0) 
	then
		PREPARE STMT FROM
		"SELECT Id, CategoryName FROM  quizcategory
		LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	else
		SELECT Id, CategoryName FROM  quizcategory;
	END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizChoiceList`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	
	SET @pageSize = pageSize;
	SET @rowNumber = currentPage * pageSize;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT q.*, c.Id as cId, c.Content as answer
		FROM choice c 
		JOIN (
			SELECT quiz.*, quizcategory.CategoryName, partner.PartnerName 
				FROM  quiz, quizcategory, partner
				WHERE quiz.PartnerId  = partner.Id
				  AND
					 quiz.CategoryId = quizcategory.Id
				ORDER BY quiz.CreatedDate DESC
				LIMIT ?, ?) as q
		ON q.Id = c.QuestionId";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	 else
		SELECT q.*, c.Id as cId, c.Content as answer
		FROM choice c 
		JOIN (
			SELECT quiz.*, quizcategory.CategoryName, partner.PartnerName 
				FROM  quiz, quizcategory, partner
				WHERE quiz.PartnerId  = partner.Id
				  AND
					 quiz.CategoryId = quizcategory.Id 
				) as q  
		ON q.Id = c.QuestionId
		ORDER BY q.CreatedDate DESC;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizChoiceList_Random`(IN pageSize INT)
BEGIN
	
	SET @pageSize = pageSize;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT q.*, c.Id as cId, c.Content as answer 
		FROM choice c 
		JOIN (SELECT *  FROM  quiz WHERE quiz.IsApproved=1 order by RAND() 	LIMIT ?) as q ON q.Id = c.QuestionId";
		EXECUTE STMT USING @pageSize;
		DEALLOCATE PREPARE STMT;
	 else
		SELECT q.*, c.Id as cId, c.Content as answer
		FROM choice c 
		JOIN (SELECT *  FROM  quiz  WHERE quiz.IsApproved=1 order by RAND()) as q ON q.Id = c.QuestionId;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizChoiceList_Random_Cate`(IN pageSize INT, IN category INT)
BEGIN
	
	SET @pageSize = pageSize;
	SET @category = category; 
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT q.*, c.Id as cId, c.Content as answer
		FROM choice c 
		JOIN (SELECT *  FROM  quiz WHERE quiz.CategoryId = ? AND quiz.IsApproved=1 order by RAND() 	LIMIT ?) as q ON q.Id = c.QuestionId";
		EXECUTE STMT USING @category, @pageSize;
		DEALLOCATE PREPARE STMT; 
	 else
		SELECT q.*, c.Id as cId, c.Content as answer
		FROM choice c 
		JOIN (SELECT *  FROM  quiz WHERE quiz.CategoryId = @category AND quiz.IsApproved=1 order by RAND()) as q ON q.Id = c.QuestionId;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizList`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	
	SET @pageSize = pageSize;
	SET @rowNumber = currentPage * pageSize;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT quiz.Id, quizcategory.CategoryName, quiz.IsApproved, partner.PartnerName, quiz.CreatedDate  
		FROM 
			  quiz,
			  partner,
			  quizcategory
		WHERE 
			 quiz.PartnerId  = partner.Id
		  AND
			 quiz.CategoryId = quizcategory.Id
		ORDER BY quiz.CreatedDate DESC
		LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	 else
		SELECT quiz.Id, quizcategory.CategoryName, quiz.IsApproved, partner.PartnerName, quiz.CreatedDate  
		FROM 
			  quiz,
			  partner, 
			  quizcategory
		WHERE 
			 quiz.PartnerId  = partner.Id
		  AND
			 quiz.CategoryId = quizcategory.Id
		ORDER BY quiz.CreatedDate DESC;
	end if;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizList_ByCategory`(IN currentPage INT, IN pageSize INT, IN category INT)
BEGIN
	DECLARE rowNumber INT;
	
	SET @pageSize = pageSize;
	SET @rowNumber = currentPage * pageSize;
	SET @category = category;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT *   
		FROM 
			  quiz
		order by field (CategoryId, ?) desc
		LIMIT ?,?";
		EXECUTE STMT USING @category, @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	 else
		SELECT *   
		FROM 
			  quiz
		WHERE 
			 quiz.CategoryId = @category;
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizList_Random`(IN pageSize INT)
BEGIN
	
	SET @pageSize = pageSize;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT *   
		FROM 
			  quiz
		order by rand()
		LIMIT ?";
		EXECUTE STMT USING @pageSize;
		DEALLOCATE PREPARE STMT;
	 else
		SELECT *   
		FROM 
			  quiz
		order by RAND();
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_QuizList_Random_Cate`(IN pageSize INT, IN category INT)
BEGIN
	
	SET @pageSize = pageSize;
	SET @category = category; 
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT *   
		FROM 
			  quiz
		WHERE quiz.CategoryId = ?
		order by rand()
		LIMIT ?";
		EXECUTE STMT USING @category, @pageSize;
		DEALLOCATE PREPARE STMT;
	 else
		SELECT *   
		FROM 
			  quiz
		WHERE quiz.CategoryId = @category
		order by RAND();
	end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_UserMedal`(IN currentPage INT, IN pageSize INT, IN userId INT)
BEGIN
	DECLARE rowNumber INT;
	
	SET @pageSize = pageSize;
	SET @rowNumber = currentPage * pageSize;
	SET @userId = userId;
	
	if (pageSize != 0) 
	then	
		PREPARE STMT FROM
		"SELECT usermedal.Id, usermedal.MedalId, medal.Name, medal.ImageURL
		FROM usermedal, medal
		WHERE usermedal.UserId = ? AND usermedal.MedalId = medal.Id
		ORDER BY usermedal.Id DESC
		LIMIT ?,?";
		EXECUTE STMT USING @userId, @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	else
		SELECT usermedal.Id, usermedal.MedalId, medal.Name, medal.ImageURL 
		FROM usermedal, medal
		WHERE usermedal.UserId = @userId AND usermedal.MedalId = medal.Id 
		ORDER BY usermedal.Id DESC;
	END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_VirtualQuest`(Id INT)
BEGIN
	SELECT 
		virtualquest.Id,
		QuestName,
		partner.PartnerName,
		UnlockPoint,
		CreateDate,
		AnimationId,
		virtualquest.ImageURL, 
		PacketId,
		packet.Title as 'PacketName',
		questcondition.Id, 
		questcondition.Type, 
		questcondition.ObjectId,
		questcondition.Value
	FROM 
		 virtualquest,
		partner, packet, questcondition
	WHERE 
				virtualquest.Id = Id
		AND		virtualquest.PartnerId = partner.Id
		AND		virtualquest.PacketId = packet.Id
		AND     questcondition.VirtualQuestId = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Get_VirtualQuestList`(IN currentPage INT, IN pageSize INT)
BEGIN
	declare rowNumber INT;
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;

	if (pageSize != 0) 
	then
		PREPARE STMT FROM
		"SELECT virtualquest.Id, 
		QuestName,
		packet.Title as 'PacketName',
		UnlockPoint,
		CreateDate
				
		FROM  virtualquest, packet
		WHERE virtualquest.PacketId = packet.Id
		LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;
	else
SELECT virtualquest.Id, 
		QuestName,
		packet.Title as 'PacketName',
		UnlockPoint,
		CreateDate
				
		FROM  virtualquest, packet
		WHERE virtualquest.PacketId = packet.Id;
	END if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_InsertMedal`(
	userId INT, 
	medalId INT
)
BEGIN
	DECLARE iStatus INT;
	SET iStatus = 0;
		IF not exists(SELECT Id FROM usermedal WHERE usermedal.UserId = userId AND usermedal.MedalId = medalId)
		THEN
			INSERT INTO usermedal(
														UserId,
														MedalId
													)
											VALUES(
														userId,
														medalId
													);
			
		ELSE
			SET iStatus = 1;
		END IF; 
		SELECT iStatus;
	  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertUserFb`(IN iFullName VARCHAR(100),IN iEmail VARCHAR(100), IN iPhone VARCHAR(45), IN iFacebookId VARCHAR(45))
BEGIN
	DECLARE userId INT;

	BEGIN 
		-- ERROR
		ROLLBACK;
	END;

	BEGIN
		-- WARNING
		ROLLBACK;
	END;
	
	IF EXISTS(SELECT * FROM userapplication WHERE FacebookId = iFacebookId) THEN
	
		SELECT '0' as `code`, 'User is Exist' as 'message',
			s.FullName as uUserName,
			s.AvatarId as uAvatar,
			u.UserId AS uUserId,
			u.FacebookId AS uFacebookId,
			u.Points AS uPoints,
			u.CurrentLevel AS uCurrentLevel,
			v.Id AS vId,
			v.QuestName AS vQuestName,
			v.PacketId AS vPacketId,
			v.QuestName AS vQuestName,
			v.PacketId AS vPacketId,
			v.PartnerId AS vPartnerId,
			v.AnimationId AS vAnimationId,
			v.UnlockPoint AS vUnlockPoint,
			v.CreateDate AS vCreateDate,
			q.Status AS qStatus,
			c.Id AS cId,
			c.Type AS cType,
			c.Value AS cValue,
			c.VirtualQuestId AS cVirtualQuestId,
			c.ObjectId AS cObjectId,
			IF( EXISTS (SELECT * FROM usercondition WHERE UserId = u.UserId AND ConditionId = c.Id), 1, 0 ) AS  'is_completed'
			
		FROM userapplication u
		JOIN uservirtualquest q ON u.UserId = q.UserId
		JOIN virtualquest v ON q.QuestId = v.Id
		JOIN questcondition c ON c.VirtualQuestId = v.Id
		join user s on s.Id = u.UserId
		WHERE FacebookId = iFacebookId AND device_id IS NULL;

	ELSE
		START TRANSACTION;
			
			INSERT INTO user(Fullname, Email, RegisterDate, PhoneNumber, AvatarId) VALUES(iFullName, iEmail, curdate(), iPhone, 0);
		
			set @userId = (SELECT LAST_INSERT_ID());
			
			INSERT INTO userapplication(UserId, FacebookId, Points, CurrentLevel) VALUES(@userId, iFacebookId, 0, 0);
			
			INSERT INTO uservirtualquest(UserId, QuestId, Status) VALUES (@userId, (SELECT Id FROM virtualquest LIMIT 1), 1);
			
			SELECT '1' as `code`, 'Regist successful' as 'message', 
				s.FullName as uUserName,
				s.AvatarId as uAvatar,
				u.UserId AS uUserId,
				u.FacebookId AS uFacebookId,
				u.Points AS uPoints,
				u.CurrentLevel AS uCurrentLevel,
				v.Id AS vId,
				v.QuestName AS vQuestName,
				v.PacketId AS vPacketId,
				v.PartnerId AS vPartnerId,
				v.AnimationId AS vAnimationId,
				v.UnlockPoint AS vUnlockPoint,
				v.CreateDate AS vCreateDate,
				q.Status AS qStatus,
				c.Id AS cId,
				c.Type AS cType,
				c.Value AS cValue,
				c.VirtualQuestId AS cVirtualQuestId, 
				c.ObjectId AS cObjectId,
				IF( EXISTS (SELECT * FROM usercondition WHERE UserId = u.UserId AND ConditionId = c.Id), 1, 0 ) AS  'is_completed'

			FROM userapplication u
			JOIN uservirtualquest q ON u.UserId = q.UserId
			JOIN virtualquest v ON q.QuestId = v.Id 
			JOIN questcondition c ON c.VirtualQuestId = v.Id
			join user s on s.Id = u.UserId
			WHERE u.UserId = @userId;

		COMMIT;
			
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertUserFb2`(IN iFullName VARCHAR(100),IN iEmail VARCHAR(100), IN iPhone VARCHAR(45), IN iFacebookId VARCHAR(45))
BEGIN
	DECLARE var_userId INT;
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	BEGIN
		-- WARNING
		ROLLBACK;
	END;
	IF EXISTS(SELECT * FROM userapplication WHERE FacebookId = iFacebookId) 
	THEN
	
		SELECT UserId INTO @var_userId 
		FROM userapplication 
		WHERE FacebookId = iFacebookId;
		
		SELECT * 
		FROM (SELECT *, 1 AS is_completed 
				FROM view_userinfo 
				WHERE uUserId = @var_userId AND cId IN (
					SELECT ConditionId 
					FROM usercondition u 
					WHERE u.userId = @var_userId
				)
					
			UNION
			
			SELECT *, 0 AS is_completed 
			FROM view_userinfo 
			WHERE uUserId = @var_userId AND cId NOT IN (
				SELECT ConditionId 
				FROM usercondition u 
				WHERE u.userId = @var_userId
			)
		) AS tt
		ORDER BY cId;
	ELSE
		START TRANSACTION;
			
			SELECT * 
			FROM (SELECT *, 1 AS is_completed 
					FROM view_userinfo 
					WHERE uUserId = @var_userId AND cId IN (
						SELECT ConditionId 
						FROM usercondition u 
						WHERE u.userId = @var_userId
					)
						
				UNION
				
				SELECT *, 0 AS is_completed 
				FROM view_userinfo 
				WHERE uUserId = @var_userId AND cId NOT IN (
					SELECT ConditionId 
					FROM usercondition u 
					WHERE u.userId = @var_userId
				)
			) AS tt
			ORDER BY cId;

		COMMIT;
		
	END IF;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_Activity`(	
	title nvarchar(140),
	description nvarchar(140),
	partner_id int,	
	action_id int,
	action_content nvarchar(140),
	CreateDate datetime
)
BEGIN
	INSERT INTO activity
				(
					Title,
					Description,
					PartnerId,
					ActionId,
					ActionContent,
					BonusPoint,
					CreateDate
				)
			VALUES
				(
					title,
					description,
					partner_id,
					action_id,
					action_content,
					100,
					CreateDate
				);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_Choice`(
	Content nvarchar(500)
)
BEGIN
	DECLARE QuestionId INT;
	SET QuestionId = (SELECT MAX(quiz.Id) FROM quiz) + 1;
	INSERT INTO choice(
						QuestionId,
						Content
						)
			VALUES(
					QuestionId,
					Content
					);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_ConditionQuest`(
	type INT,
	objectId INT,
	Id INT
)
BEGIN
	INSERT INTO  questcondition
				(
					questcondition.Type,
					ObjectId,
					VirtualQuestId
				)
			VALUES
				(
					type,
					objectId,
					Id
				);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_Donation`(
	title nvarchar(150),
	description nvarchar(140),
	partner_id int,
	create_date datetime
)
BEGIN
	
	INSERT INTO donation
				(
					Title,
					Description,
					PartnerId,
					RequiredPoint,
					CreateDate
				)
			VALUES
				(
					title,
					description,
					partner_id,
					100,
					create_date
				);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_Packet`(
	title 		nvarchar(140),
	imageUrl	nvarchar(140),
	partnerId 	int
)
BEGIN
	INSERT INTO  packet
				(
					packet.Title,
					packet.ImageURL,
					packet.PartnerId
				)
			VALUES
				(
					title,
					imageUrl,
					PartnerId
				);
			
					
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_Quiz`(
	questCategory 	int,
	questQuestion	nvarchar(140),
	ImageURL		nvarchar(200),
	CorrectChoiceId int,
	sharingInfo		nvarchar(8000),
	linkURL	     	nvarchar(200),
	partnerId		int,
	createdDate	  	datetime
)
BEGIN
	

	# Insert infomation into Quiz table
	INSERT INTO quiz(
						CategoryId,
						PartnerId,
                        CreatedDate,
						Content,
						CorrectChoiceId,
						SharingInfo,
						LearnMoreURL,
						BonusPoint,
						ImageURL
					)
				VALUES(
						questCategory,
						partnerId,
						createdDate,
						questQuestion,
						CorrectChoiceId,
						sharingInfo,
						linkURL,
						100,
						ImageURL
					);
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_QuizCategory`(category nvarchar(140))
BEGIN
	INSERT INTO  quizcategory
				(
					quizcategory.CategoryName
				)
			VALUES
				(
					category
				);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_Quiz_Choice`(
	questCategory 	int,
	questQuestion	nvarchar(140),
	imageURL		nvarchar(200),
	correctChoiceId int,
	sharingInfo		nvarchar(8000),
	linkURL	     	nvarchar(200),
	partnerId		int,
	createdDate	  	datetime,
	answerA nvarchar(50),
	answerB nvarchar(50),
	answerC nvarchar(50),
	answerD nvarchar(50)
)
BEGIN
	# Parameter for main Store Proceduce
	declare QuestionId int;
	declare choiceId int;
	
	# Using transaction for query
	DECLARE exit handler for sqlexception
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	DECLARE exit handler for sqlwarning
	BEGIN
		-- WARNING
		ROLLBACK;
	END;

	START TRANSACTION;
	
	# Insert infomation into Quiz table
	INSERT INTO quiz(
						CategoryId,
						PartnerId,
                        CreatedDate,
						Content,
						SharingInfo,
						LearnMoreURL,
						BonusPoint,
						ImageURL
					)
				VALUES(
						questCategory,
						partnerId,
						createdDate,
						questQuestion,
						sharingInfo,
						linkURL,
						1,
						imageURL
					);
	
	# Get quiz id insert after
	set QuestionId = (SELECT LAST_INSERT_ID()) ;

	INSERT INTO choice(
						QuestionId,
						Content
						)
			VALUES(
					QuestionId,
					answerA
					);
	INSERT INTO choice(
						QuestionId,
						Content
						)
			VALUES(
					QuestionId,
					answerB
					);
	INSERT INTO choice(
						QuestionId,
						Content
						)
			VALUES(
					QuestionId,
					answerC
					);
	INSERT INTO choice(
						QuestionId,
						Content
						)
			VALUES(
					QuestionId,
					answerD
					);

	# Get choice id insert after
	set choiceId = (select LAST_INSERT_ID()) - 3 + correctChoiceId;
	
	UPDATE  quiz
			SET quiz.correctChoiceId = choiceId
			WHERE Id = QuestionId;	
	COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_user`(
				IN userName varchar (100), 
				IN deviceID varchar (100)
)
BEGIN
	DECLARE userId INT;
 
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	BEGIN
		-- WARNING
		ROLLBACK;
	END;
	
	IF EXISTS (SELECT Id FROM user, userapplication WHERE user.FullName = userName and userapplication.device_id = deviceID and user.Id = userapplication.UserId) THEN 

-- SELECT UserId, (SELECT Id FROM user WHERE FullName = userName) FROM userapplication WHERE device_id = deviceID) THEN
		SELECT '0' as `code`, 'User is Exist' as 'message',
			s.FullName as uUserName,
			s.AvatarId as uAvatar,
			u.UserId AS uUserId,
			u.FacebookId AS uFacebookId,
			u.device_id as device_id,
			u.Points AS uPoints,
			u.CurrentLevel AS uCurrentLevel,
			v.Id AS vId,
			v.QuestName AS vQuestName,
			v.PacketId AS vPacketId,
			v.QuestName AS vQuestName,
			v.PacketId AS vPacketId,
			v.PartnerId AS vPartnerId,
			v.AnimationId AS vAnimationId,
			v.UnlockPoint AS vUnlockPoint,
			v.CreateDate AS vCreateDate,
			q.Status AS qStatus,
			c.Id AS cId,
			c.Type AS cType,
			c.Value AS cValue,
			c.VirtualQuestId AS cVirtualQuestId, 
			c.ObjectId AS cObjectId,
			IF( EXISTS (SELECT * FROM usercondition WHERE UserId = u.UserId AND ConditionId = c.Id), 1, 0 ) AS  'is_completed'
			
		FROM userapplication u
		JOIN uservirtualquest q ON u.UserId = q.UserId
		JOIN virtualquest v ON q.QuestId = v.Id
		JOIN questcondition c ON c.VirtualQuestId = v.Id
		join user s on s.Id = u.UserId
		WHERE device_id = deviceID and FullName = userName;

	ELSE
		START TRANSACTION;
			
			INSERT INTO user(Fullname, RegisterDate) VALUES(userName, curdate());
		 
			set @userId = (SELECT LAST_INSERT_ID());
			
			INSERT INTO userapplication(UserId, Points, CurrentLevel, device_id) VALUES(@userId, 0, 0, deviceID);
			
			INSERT INTO uservirtualquest(UserId, QuestId, Status) VALUES (@userId, (SELECT Id FROM virtualquest LIMIT 1), 1);
			
			SELECT '1' as `code`, 'Regist successful' as 'message', 
				s.FullName as uUserName,
				s.AvatarId as uAvatar,
				u.UserId AS uUserId,
				u.FacebookId AS uFacebookId,
				u.device_id as device_id,
				u.Points AS uPoints,
				u.CurrentLevel AS uCurrentLevel,
				v.Id AS vId,
				v.QuestName AS vQuestName,
				v.PacketId AS vPacketId,
				v.PartnerId AS vPartnerId,
				v.AnimationId AS vAnimationId,
				v.UnlockPoint AS vUnlockPoint,
				v.CreateDate AS vCreateDate,
				q.Status AS qStatus,
				c.Id AS cId,
				c.Type AS cType,
				c.Value AS cValue,
				c.VirtualQuestId AS cVirtualQuestId,
				c.ObjectId AS cObjectId,
				IF( EXISTS (SELECT * FROM usercondition WHERE UserId = u.UserId AND ConditionId = c.Id), 1, 0 ) AS  'is_completed'

			FROM userapplication u
			JOIN uservirtualquest q ON u.UserId = q.UserId
			JOIN virtualquest v ON q.QuestId = v.Id
			JOIN questcondition c ON c.VirtualQuestId = v.Id
			join user s on s.Id = u.UserId
			WHERE u.UserId = @userId; 

		COMMIT;
			
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Insert_VirtualQuest`(
	partner_id Int,
	packet_id Int,
	name nvarchar(40),
	point INT,
	create_date datetime,
	animation int,
	image_url nvarchar(200)
	
)
BEGIN
	INSERT INTO  virtualquest
				(
					PacketId,
					PartnerId,
					QuestName,
					UnlockPoint,
					CreateDate,
					AnimationId,
					ImageURL
				)
			VALUES
				(
					packet_id,
					partner_id,
					name,
					point,
					create_date,
					animation ,
					image_url
				);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_paginationhotelagodabydistance`(IN currentPage INT
																						, IN pageSize INT
																						, IN iLat FLOAT
																						, IN iLon FLOAT
																						, IN iDistance FLOAT
																						, IN iCountryisocode VARCHAR(2))
BEGIN
	DECLARE rowNumber INT;
	SET @currentPage = currentPage + 1;
	SET @rowNumber = currentPage * pageSize;
	PREPARE STMT FROM
	"SELECT *, (((acos(sin((iLat * 0.0174)) 
				* sin((hotel_agoda.latitude * 0.0174))
				+cos((iLat*0.0174)) 
				* cos((hotel_agoda.latitude * 0.0174)) 
				*cos(((iLon- hotel_agoda.longitude)*0.0174))))*57.32484)*111.18957696) as distance
	FROM hotel_agoda 
	WHERE countryisocode = iCountryisocode
	HAVING distance <= iDistance
	ORDER BY distance
	LIMIT ?,?";
		EXECUTE STMT USING @rowNumber, @pageSize;
		DEALLOCATE PREPARE STMT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_paginationquest`(IN currentPage INT, IN pageSize INT)
BEGIN
	DECLARE rowNumber INT;
	SET @currentPage = currentPage;
	SET @rowNumber = currentPage * pageSize;
	PREPARE STMT FROM
	"SELECT A.* FROM quest A WHERE !isnull(A.parent_quest_id)
	ORDER BY A.id LIMIT ?,?";
	EXECUTE STMT USING @rowNumber, @pageSize;
	DEALLOCATE PREPARE STMT;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reset_player`(
	id INT
)
BEGIN
	# Using transaction for query
	DECLARE exit handler for sqlexception
	BEGIN
		-- ERROR
		ROLLBACK;
	END;

	DECLARE exit handler for sqlwarning
	BEGIN
		-- WARNING
		ROLLBACK;
	END;

	START TRANSACTION;
	
	# Start reset user
	# Delete other quest ID rather than 1 from uservirtualquest.
	DELETE FROM uservirtualquest
		WHERE UserId = id
			AND QuestId != 1;
	# Reset the status
	UPDATE uservirtualquest
		set Status = 1
		WHERE UserId = id;

	# Delete data from usermedal table
	DELETE from usermedal
		WHERE UserId = id;

	# Delete data from usercondition table
	DELETE from usercondition
		WHERE UserId = id;

	# Reset data in userapplication table
	UPDATE userapplication
		SET Points = 0 
		WHERE UserId = id;

	# End reset user

	COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_saveGame`(IN inUserId INT, IN score INT, IN inConditionId INT)
BEGIN
	DECLARE tmpScore INT;

	SELECT Points INTO @tmpScore FROM userapplication WHERE UserId = inUserId;
	SET @tmpScore = @tmpScore + score;
	UPDATE userapplication SET Points = @tmpScore WHERE UserId = inUserId;
	
	SET @tmpScore = 0; 
	SELECT AchievingPoints INTO @tmpScore FROM usercondition WHERE UserId = inUserId AND ConditionId = inConditionId;
	#SELECT @tmpScore IS NOT NULL;
	IF exists(SELECT AchievingPoints FROM usercondition WHERE UserId = inUserId AND ConditionId = inConditionId)
	THEN
		SET @tmpScore = @tmpScore + score;
		UPDATE usercondition SET AchievingPoints = @tmpScore WHERE UserId = inUserId AND ConditionId = inConditionId;
		#SELECT @tmpScore AS col;
	ELSE
		INSERT INTO `zadmin_heroforzero`.`usercondition`(`UserId`,`ConditionId`,`AchievingPoints`)VALUES (inUserId, InConditionId, score);
		#SELECT @tmpScore AS COLNULL;
	END IF;

	SELECT a.Points AS UserApplicationPoints, c.AchievingPoints AS UserConditionPoints
	FROM userapplication a 
	JOIN  usercondition c 
	ON a.UserId = c.UserId AND c.ConditionId = inConditionId 
	WHERE a.UserId = inUserId;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UpdateQuestStatus`(userId INT, questId INT, questStatus INT)
BEGIN

		IF not exists (SELECT QuestId FROM uservirtualquest WHERE uservirtualquest.UserId = userId AND uservirtualquest.QuestId = (questId + 1))
		THEN 
			BEGIN 
				INSERT INTO uservirtualquest(
												UserId,
												QuestId,
												Status
											)
							VALUES(
									userId,
									(questId + 1),
									1
									);
			END;
		END IF;
	
		UPDATE uservirtualquest SET uservirtualquest.Status = 2
								WHERE uservirtualquest.UserId = userId AND 
									  uservirtualquest.QuestId = questId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_Activity`(
	id INT,
	partner_id INT,
	title nvarchar(140),
	description nvarchar(140),
	action_id INT,
	action_content nvarchar(140),
	bonus_point INT,
	approve BIT
)
BEGIN
	UPDATE  activity
			SET 
				activity.PartnerId = partner_id,
				activity.Title = title,
				activity.description = description,
				activity.ActionId = action_id,
				activity.BonusPoint = bonus_point,
				activity.IsApproved = approve,
				activity.ActionContent = action_content
			WHERE
				activity.Id = id;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_ActivityApprove`(Id int, IsApproved bit)
BEGIN
		UPDATE  activity
		   SET 
				activity.IsApproved = IsApproved
		   WHERE
				activity.Id = Id;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_BonusPoint_Activity`(Id int, point float)
BEGIN
	UPDATE activity
	SET
		activity.BonusPoint = point
	WHERE 
		activity.Id = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_BonusPoint_Quiz`(
	Id INT,
	BonusPoint float
)
BEGIN
	UPDATE   quiz
			SET
				BonusPoint = BonusPoint
			WHERE
				quiz.Id = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_Choice`(
	Id 		int,
	Content nvarchar(50)
)
BEGIN
	UPDATE choice 
		SET
			choice.Content = Content
		WHERE
			choice.Id = Id;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_ConditionQuest`(
	objectId INT,
	Id INT
)
BEGIN
	UPDATE  questcondition
				SET
					ObjectId = objectId 
				WHERE	Id = Id;
				
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_Donation`(
	id INT,
	partner_id INT,
	title nvarchar(140),
	description nvarchar(140),
	bonus_point INT,
	approve BIT
)
BEGIN
	UPDATE  donation
			SET 
				donation.PartnerId = partner_id,
				donation.Title = title,
				donation.description = description,
				donation.RequiredPoint = bonus_point,
				donation.IsApproved = approve
			WHERE
				donation.Id = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_DonationApprove`(Id int, IsApproved bit)
BEGIN
	UPDATE  donation
		   SET 
				donation.IsApproved = IsApproved
		   WHERE
				donation.Id = Id;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_Partner_IsApproved`(Id int, IsApproved bit)
BEGIN
			
	UPDATE  partner
		   SET 
				partner.IsApproved = IsApproved
		   WHERE
				partner.Id = Id;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_Quiz`(
	Id 				int,
	questCategory 	int,
	questQuestion 	nvarchar(140),
	ImageURL		nvarchar(200),
	CorrectChoiceId int,
	sharingInfo		nvarchar(8000),
	linkURL	      	nvarchar(200),
	createdDate	  	datetime
)
BEGIN
	

	# Update infomation into Quiz table
	UPDATE  quiz
		   SET
						quiz.CategoryId = questCategory,
						quiz.CreatedDate = createdDate,
						quiz.Content = questQuestion,
						quiz.ImageURL = ImageURL,
						quiz.CorrectChoiceId = CorrectChoiceId,
						quiz.SharingInfo = sharingInfo,
						quiz.LearnMoreURL = linkURL
			WHERE	
				quiz.Id = Id;
				
				
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_QuizApprove`(Id int, IsApproved bit)
BEGIN
			
	UPDATE  quiz
		   SET 
				quiz.IsApproved = IsApproved
		   WHERE
				quiz.Id = Id;	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_RequiredPoint_Donation`(Id int, point float)
BEGIN
	UPDATE  donation
	SET
		donation.RequiredPoint = point
	WHERE 
		donation.Id = Id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Update_VirtualQuest`(IN `id` INT, IN `partner_id` INT, IN `packet_id` INT, IN `name` nvarchar(140), point INT, animation INT, imageURL nvarchar(100))
BEGIN
	UPDATE  virtualquest
				SET
					virtualquest.PacketId = packet_id,
					virtualquest.QuestName = name,
					virtualquest.UnlockPoint = point,
					virtualquest.AnimationId = animation,
					virtualquest.ImageURL = imageURL
				WHERE  virtualquest.Id = id;
					
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_useracceptquest`(IN iUserId INT, IN iQuestId INT, IN iParentQuestId INT)
BEGIN
	IF NOT EXISTS(SELECT * FROM quest WHERE id = iQuestId AND parent_quest_id = iParentQuestId) THEN
		SELECT 0 AS `code`;
	ELSE
		IF EXISTS(SELECT * FROM user_quest WHERE user_id = iUserId AND quest_id = iQuestId) THEN
			SELECT 0 AS `code`;
		ELSE
			INSERT INTO user_quest(user_id, quest_id, parent_quest_id) VALUES (iUserId, iQuestId, iParentQuestId);
			SELECT 1 AS `code`;
		END IF;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usercompletequest`(IN iUserId INT, IN iQuestId INT)
BEGIN
	DECLARE parentQuestId INT;
	SELECT parent_quest_id INTO parentQuestId FROM quest WHERE id = iQuestId;

	IF EXISTS(SELECT * FROM user_quest WHERE user_id = iUserId AND quest_id = iQuestId AND status_quest = 0) THEN
		SET SQL_SAFE_UPDATES=0;
		UPDATE user_quest SET status_quest = 1 WHERE user_id = iUserId AND quest_id = iQuestId;
		-- check main quest
		
		SET SQL_SAFE_UPDATES=0;
		UPDATE user SET points = points + (SELECT points FROM quest WHERE id = iQuestId) WHERE id = iUserId;
		
		IF ((SELECT COUNT(*) 
			 FROM quest 
			 WHERE parent_quest_id = parentQuestId) = (SELECT COUNT(*) 
													   FROM user_quest 
													   WHERE user_id = iUserId
															AND parent_quest_id = parentQuestId
															AND status_quest = 1))
		THEN
			SET SQL_SAFE_UPDATES=0;
			UPDATE user SET points = points + (SELECT points FROM quest WHERE id = parentQuestId) WHERE id = iUserId;
			INSERT INTO user_quest VALUES (iUserId, parentQuestId, null, 1);
			SELECT 2 AS `code`, 'Complete Main Quest' AS `message`,  quest.*,reward.* from quest, reward where quest.id = parentQuestId and quest.reward_id = reward.id;
		ELSE
			SELECT 1 AS `code`, 'Complete Quest' AS `message`;
		END IF;
	ELSE
		SELECT 0 AS `code`, 'Fail' AS `message`;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test`()
BEGIN 
	DECLARE a INT;
	SELECT id INTO a FROM quest WHERE id = 1;
	SELECT a;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test_proc`(IN con int)
BEGIN
  SELECT * FROM userapplication
  WHERE UserId = con;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_checkSignUpInfo`(iFullName VARCHAR(100),
									iHeroName VARCHAR(100),
									iEmail VARCHAR(100),
									iPhoneNumber VARCHAR(100),
									iPassword VARCHAR(100)) RETURNS int(11)
BEGIN
	DECLARE count INT;
	DECLARE resultCode INT;
    SELECT COUNT(*) INTO count FROM user WHERE email = iEmail OR hero_name = iHeroName;

	IF count > 0 THEN
		SET resultCode = 0;
	ELSE
		INSERT INTO user
		VALUES(iFullName, iHeroName, iEmail, iPhoneNumber, iPassword, null, null, 1, 1, 0, NOW());
		SET resultCode = 1;
	END IF;
	RETURN resultCode;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fnc_checkSignUpWithFacebookInfo`(iFacebookId VARCHAR(100),
												iFullName VARCHAR(100),
												iHeroName VARCHAR(100)) RETURNS int(11)
BEGIN
	DECLARE count INT;
	DECLARE resultCode INT;
    

	IF EXISTS(SELECT * FROM user WHERE facebook_id = iFacebookId OR hero_name = iHeroName) THEN
		SET resultCode = 0;
	ELSE
		INSERT INTO user
		VALUES(UUID(), iFullName, iHeroName, null, null, null, null, null, 1, 1, 0, NOW());
		SET resultCode = 1;
	END IF;
	RETURN resultCode;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `action`
--

CREATE TABLE IF NOT EXISTS `action` (
`Id` int(11) NOT NULL,
  `Name` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_image` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `action`
--

INSERT INTO `action` (`Id`, `Name`, `action_image`) VALUES
(1, 'Share on their Facebook', NULL),
(2, 'Sign up for Your news letter', NULL),
(3, 'Like our facebook pages', NULL),
(4, 'Add to User''s calendar', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `activity`
--

CREATE TABLE IF NOT EXISTS `activity` (
`Id` int(11) NOT NULL,
  `PartnerId` int(11) DEFAULT NULL,
  `Title` varchar(140) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(140) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ActionId` int(11) DEFAULT NULL,
  `BonusPoint` int(11) DEFAULT '100',
  `IsApproved` bit(1) DEFAULT b'0',
  `CreateDate` datetime DEFAULT NULL,
  `ActionContent` varchar(140) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `activity`
--

INSERT INTO `activity` (`Id`, `PartnerId`, `Title`, `Description`, `ActionId`, `BonusPoint`, `IsApproved`, `CreateDate`, `ActionContent`) VALUES
(29, 5, 'Visit an orphanage', 'This Sunday, 02/11/2014', 1, 100, b'0', '2014-11-01 02:51:32', 'Join with us');

-- --------------------------------------------------------

--
-- Table structure for table `animation`
--

CREATE TABLE IF NOT EXISTS `animation` (
`Id` int(11) NOT NULL,
  `time` float NOT NULL,
  `HeroAnimWalking` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `HeroAnimStandby` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `MonsterAnim` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `KidFrame` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `ColorR` int(11) NOT NULL,
  `ColorG` int(11) NOT NULL,
  `ColorB` int(11) NOT NULL,
  `ScreenShotURL` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `animation`
--

INSERT INTO `animation` (`Id`, `time`, `HeroAnimWalking`, `HeroAnimStandby`, `MonsterAnim`, `KidFrame`, `ColorR`, `ColorG`, `ColorB`, `ScreenShotURL`) VALUES
(1, 60, 'walking', 'standby', 'death_walking', 'sick-boy-1.png', 242, 156, 51, 'http://heroforzero.be/assets/img/animation/1.png'),
(2, 60, 'cook_walking', 'cook_standby', 'death_walking', 'sick-boy-1.png', 41, 180, 115, 'http://heroforzero.be/assets/img/animation/2.png'),
(3, 60, 'teacher_walking', 'teacher_standby', 'prisoner_walking', 'schoolgirl-1.png', 17, 152, 195, 'http://heroforzero.be/assets/img/animation/3.png'),
(4, 60, 'boyC_walking', 'boyC_standby', 'death_walking', 'training-cape.png', 91, 189, 121, 'http://heroforzero.be/assets/uploads/6039e670c77c5f277a82f38727e6f91f.png'),
(5, 60, 'boyB_walking', 'boyB_standby', 'death_walking', 'training-shield.png', 32, 162, 132, 'http://heroforzero.be/assets/uploads/f98df41b4d85add2efc6b72d2413ed49.png'),
(6, 60, 'boyA_walking', 'boyA_standby', 'death_walking', 'training-sword.png', 25, 185, 154, 'http://heroforzero.be/assets/uploads/a5389e84c24d5433d0a29f2cd9c0d536.png'),
(7, 60, 'boyD_walking', 'boyD_standby', 'wolf_walking', 'protection-abusedgirl.png', 194, 132, 76, 'http://heroforzero.be/assets/uploads/e42dc539f483b65fbc6fa20457735759.png'),
(8, 60, 'boyD_walking', 'boyD_standby', 'wolf_walking', 'protection-crippledboy.png', 194, 132, 76, 'http://heroforzero.be/assets/uploads/874d8bddf08c65d6b1b6c30a8758b063.png'),
(9, 60, 'boyD_walking', 'boyD_standby', 'prisoner_walking', 'loto-girl-1.png', 194, 132, 76, 'http://heroforzero.be/assets/uploads/065c63b68f431ed3ed41cfc365cfce25.png');

-- --------------------------------------------------------

--
-- Table structure for table `app_sessions`
--

CREATE TABLE IF NOT EXISTS `app_sessions` (
  `session_id` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `ip_address` varchar(45) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `user_agent` varchar(120) CHARACTER SET utf8 NOT NULL,
  `last_activity` int(10) unsigned NOT NULL DEFAULT '0',
  `user_data` text CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `app_sessions`
--

INSERT INTO `app_sessions` (`session_id`, `ip_address`, `user_agent`, `last_activity`, `user_data`) VALUES
('f34b5c64531b0323fd7d663ab80697ec', '::1', 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36', 1432659811, 'a:4:{s:9:"user_data";s:0:"";s:10:"partner_id";i:47;s:4:"role";s:5:"admin";s:7:"islogin";b:1;}');

-- --------------------------------------------------------

--
-- Table structure for table `choice`
--

CREATE TABLE IF NOT EXISTS `choice` (
`Id` int(11) NOT NULL,
  `QuestionId` int(11) DEFAULT NULL,
  `Content` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1902 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `choice`
--

INSERT INTO `choice` (`Id`, `QuestionId`, `Content`) VALUES
(174, 69, 'Run and Hide'),
(175, 69, 'Ignore it'),
(176, 69, 'Call children''s help hotlines '),
(177, 69, 'Confront the aggressor'),
(178, 70, 'Government'),
(179, 70, 'Family'),
(180, 70, 'Society'),
(181, 70, 'All are correct'),
(182, 71, 'Children with disabilities'),
(183, 71, 'Street children'),
(184, 71, 'Poor children'),
(185, 71, 'All are correct'),
(186, 72, 'They should keep it to themselves'),
(187, 72, 'To parents, relatives, teachers or police'),
(188, 72, 'Their friends'),
(189, 72, 'Their abuser'),
(198, 75, '2014-04-15 08:18:31'),
(199, 75, '111'),
(200, 75, '112'),
(201, 75, '113'),
(202, 76, '2014-04-15 08:21:52'),
(203, 76, '115'),
(204, 76, ''),
(205, 76, ''),
(210, 78, '1'),
(211, 78, '2'),
(212, 78, '3'),
(213, 78, '4'),
(214, 79, '2'),
(215, 79, '2'),
(216, 79, '2'),
(217, 79, ''),
(222, 81, '18 and under'),
(223, 81, '10 and under'),
(224, 81, '16 and under'),
(225, 81, '14 and under'),
(226, 82, 'A police officer'),
(227, 82, 'A teacher'),
(228, 82, 'A doctor'),
(229, 82, 'A person who is responsible for protection.'),
(234, 84, '5'),
(235, 84, '3'),
(236, 84, '4'),
(237, 84, '6'),
(238, 85, 'Abandoned or orphaned children'),
(239, 85, 'Disabled children'),
(240, 85, 'Children from rural local areas'),
(241, 85, 'All of the above'),
(250, 88, 'Abandoned or orphaned children. '),
(251, 88, 'Disabled children. '),
(252, 88, 'Immigrant children from other local areas. '),
(253, 88, 'All are correct.'),
(262, 91, '52 years'),
(263, 91, '72 years'),
(264, 91, '92 years'),
(265, 91, '42 years'),
(266, 92, 'Eating healthy'),
(267, 92, 'Physical activity'),
(268, 92, 'Drying stagnant pools of water'),
(269, 92, 'Avoiding contact with animals'),
(270, 93, '2.000'),
(271, 93, '10.000'),
(272, 93, '18.000'),
(273, 93, '25.000'),
(274, 94, 'World Health Organisation'),
(275, 94, 'Unicef'),
(276, 94, 'World Bank'),
(277, 94, 'North Atlantic Treaty Organisation'),
(278, 95, 'Heart Attacks and Diabetes'),
(279, 95, 'Malnutrition and apendicitis'),
(280, 95, 'Cogenital abnormalities and pneunomia'),
(281, 95, 'HIV and Malaria'),
(282, 96, '10'),
(283, 96, '20'),
(284, 96, '17'),
(285, 96, '2'),
(286, 97, 'The cost of treatment'),
(287, 97, 'The closest hospital is too far away'),
(288, 97, 'They do not feel sick “enough”'),
(289, 97, 'It is too expensive and/or too far away'),
(290, 98, 'There is no statutory quality control.'),
(291, 98, 'There aren''t prescriptions for certain medicine'),
(292, 98, 'They are all homeopathic.'),
(293, 98, 'both quality control and lack of medicine'),
(294, 99, 'The staff is friendlier'),
(295, 99, 'The salary is higher'),
(296, 99, 'They get the chance to treat more people'),
(297, 99, 'They don''t have to wear white coats'),
(298, 100, '5'),
(299, 100, '10'),
(300, 100, '20'),
(301, 100, '50'),
(302, 101, 'Solely public institutions.'),
(303, 101, 'Solely private institutions.'),
(304, 101, 'Public and private institutions.'),
(305, 101, ' There is no health system in Vietnam.'),
(306, 102, 'Big cities, like HCMC'),
(307, 102, 'Coastal cities, like Nha Trang'),
(308, 102, 'Central Highlands, like Kon Tum province'),
(309, 102, 'Big cities and Coastal cities'),
(310, 103, 'Cover your skin and use sun block'),
(311, 103, 'Drink carrot juice for its beta carotene'),
(312, 103, 'Use sun block.'),
(313, 103, 'Only go out at midday when the sun is the farthest'),
(314, 104, 'Stop at red lights'),
(315, 104, 'Use turn indicators'),
(316, 104, 'Respect speed limits'),
(317, 104, 'All are correct.'),
(318, 105, 'Hepatitis A'),
(319, 105, 'Typhoid'),
(320, 105, 'Yellow fever'),
(321, 105, 'Routine vaccines, e.g. diphtheria-tetanus-pertussi'),
(322, 106, 'Colds and flus'),
(323, 106, 'Gastrointestinal illnesses'),
(324, 106, 'Circulatory problems'),
(325, 106, 'All correct'),
(326, 107, 'Cover exposed skin'),
(327, 107, 'Avoid sharing body fluids'),
(328, 107, 'Select safe transportation '),
(329, 107, ' All correct '),
(330, 108, 'Eat solely raw food'),
(331, 108, 'Do not wash your food before eating.'),
(332, 108, 'Eat food that is cooked and served hot'),
(333, 108, 'Drink as much tap water as possible'),
(334, 109, 'Prescription medicines you usually take.'),
(335, 109, 'Personalized antibiotic prescriptions'),
(336, 109, 'Strong drugs like Morphine'),
(337, 109, 'Bandages to treat small wounds'),
(338, 110, 'Cognitive development'),
(339, 110, 'Stunted growth '),
(340, 110, 'Organ damage'),
(341, 110, 'All are correct'),
(342, 111, '29'),
(343, 111, '35'),
(344, 111, '42'),
(345, 111, '50'),
(346, 112, '1,85'),
(347, 112, '4,25'),
(348, 112, '0,20'),
(349, 112, '6,54'),
(350, 113, '10 %'),
(351, 113, '25 %'),
(352, 113, '3 %'),
(353, 113, '47 %'),
(354, 114, '0 %'),
(355, 114, '25 %'),
(356, 114, '52 %'),
(357, 114, '66 %'),
(358, 115, 'Nhi Dong 2 Hospital'),
(359, 115, 'Hung Vuong Hospital'),
(360, 115, 'Cho Ray Hospital'),
(361, 115, 'An Sinh Hospital'),
(362, 116, 'It only treats child cancer patients'),
(363, 116, 'It only treats adult cancer patients'),
(364, 116, ' It is the largest public cancer hospital in Vietn'),
(365, 116, 'All are correct'),
(366, 117, '3 No Trang Long Street, Binh Thanh District'),
(367, 117, '201B Nguyen Chi Thanh Street, District 5'),
(368, 117, '106 Cong Quynh Street, District 1'),
(369, 117, '280 Dien Bien Phu Street, District 3'),
(374, 119, 'A police officer'),
(375, 119, 'A teacher'),
(376, 119, 'A doctor'),
(377, 119, 'Someone who is responsible for child protection'),
(382, 121, 'Keep it to themselves'),
(383, 121, 'Report to parents or relatives'),
(384, 121, 'Report to local police, teachers or social work'),
(385, 121, 'Report to parents,relatives, police, teachers or s'),
(386, 122, 'Effective child protection system'),
(387, 122, 'Professional social work'),
(388, 122, 'Building more youth centers'),
(389, 122, 'All are correct'),
(390, 123, 'Civil Law'),
(391, 123, 'Common Law'),
(392, 123, 'Sharia Law'),
(393, 123, 'Civil and Common Law'),
(394, 124, '16 years'),
(395, 124, '18 years'),
(396, 124, '21 years'),
(397, 124, 'There are no elections in VN.'),
(398, 125, 'Every 2nd year'),
(399, 125, 'Every 3rd year'),
(400, 125, 'Every 5th year'),
(401, 125, 'Twice a year'),
(402, 126, 'Petty crimes, such as pick-pocketing'),
(403, 126, 'Armed robbery'),
(404, 126, 'Murder'),
(405, 126, 'Kidnapping'),
(406, 127, 'Police of VN'),
(407, 127, 'People''s Public Security of Vietnam'),
(408, 127, 'There is no police in VN'),
(409, 127, 'People''s Police'),
(410, 128, 'Blue'),
(411, 128, 'Brown'),
(412, 128, 'Pink'),
(413, 128, 'Green'),
(414, 129, '5.000'),
(415, 129, '500'),
(416, 129, '120.000'),
(417, 129, '12.000'),
(418, 130, 'China, Myanmar'),
(419, 130, 'China, Malaysia'),
(420, 130, 'China, Cambodia'),
(421, 130, 'China, Malaysia, Cambodia'),
(422, 131, 'Marriage'),
(423, 131, 'Labor exploitation'),
(424, 131, 'Sex work and adoption'),
(425, 131, 'All are correct'),
(426, 132, '50%'),
(427, 132, '60%'),
(428, 132, '70%'),
(429, 132, '80%'),
(430, 133, 'They want a happier life'),
(431, 133, 'They feel that they need finacial support'),
(432, 133, 'They lack education'),
(433, 133, 'All are correct'),
(434, 134, 'Connections to the friends & families of victims'),
(435, 134, 'Connections to the victims directly'),
(436, 134, 'Connections to local governments'),
(437, 134, 'Connection to victims and friends/families of vict'),
(438, 135, 'Under age of 15'),
(439, 135, 'Under age of 16'),
(440, 135, 'Under age of 17'),
(441, 135, 'Under age of 18'),
(442, 136, 'Cleaner'),
(443, 136, 'Souvenir Seller'),
(444, 136, 'Lottery Ticket Seller'),
(445, 136, ' All are correct'),
(446, 137, '35%'),
(447, 137, '40%'),
(448, 137, '45%'),
(449, 137, '50%'),
(450, 138, 'Long hours'),
(451, 138, 'Low wages'),
(452, 138, 'Poor facilities'),
(453, 138, 'All are correct'),
(454, 139, 'About 12,000 children'),
(455, 139, 'About 23,000 children'),
(456, 139, 'About 50,000 children'),
(457, 139, ' About 250,000 children'),
(458, 140, 'Broken family'),
(459, 140, 'Mindset problem'),
(460, 140, 'Economic migration'),
(461, 140, 'All are correct'),
(462, 141, '12'),
(463, 141, '13'),
(464, 141, '14'),
(465, 141, '15'),
(466, 142, 'Provide a loving home for children'),
(467, 142, 'Provide schools for children that are illiterate'),
(468, 142, 'Provide financial support for children'),
(469, 142, 'Provide children with schools and financial suppor'),
(470, 143, '1967'),
(471, 143, '1977'),
(472, 143, '1987'),
(473, 143, '1997'),
(474, 144, '6-8'),
(475, 144, '8-10'),
(476, 144, '10-12'),
(477, 144, 'One mother takes care of only one child'),
(478, 145, '2'),
(479, 145, '13'),
(480, 145, '80'),
(481, 145, '52'),
(482, 146, 'General knowledge and Vocational training'),
(483, 146, 'Math training'),
(484, 146, 'Science skills'),
(485, 146, 'Computer skills'),
(486, 147, '5 or 6'),
(487, 147, '9 or 10 '),
(488, 147, '3 or 4'),
(489, 147, 'None of the answers are correct'),
(490, 148, 'Physical Education'),
(491, 148, 'Military and Security Education'),
(492, 148, 'Home Economics '),
(493, 148, 'History'),
(494, 149, 'American pedagogy, interaction and debate'),
(495, 149, 'British pedagogy, interaction and debate '),
(496, 149, 'Confucian pedagogy, passively attentive'),
(497, 149, 'None of the answers are correct'),
(498, 150, 'Australia, USA, China'),
(499, 150, 'Germany, Japan, Singapore'),
(500, 150, 'The Netherlands, Thailand, China'),
(501, 150, 'France, USA, China'),
(502, 151, 'Not enough money for school supplies and unifor'),
(503, 151, 'Necessity of earning money for the family'),
(504, 151, 'School is too far away'),
(505, 151, 'Not enough money and they must earn money'),
(506, 152, 'French'),
(507, 152, 'Japanese'),
(508, 152, 'English'),
(509, 152, 'Chinese'),
(510, 153, '6 per cent'),
(511, 153, '10 per cent'),
(512, 153, '25 per cent'),
(513, 153, '0 per cent'),
(514, 154, 'Democracy'),
(515, 154, 'Communism'),
(516, 154, 'Socialism'),
(517, 154, 'Communism and Socialism'),
(518, 155, 'Buddhist'),
(519, 155, 'Catholic'),
(520, 155, 'Muslim'),
(521, 155, 'There is no predominant religion'),
(522, 156, '22'),
(523, 156, '30'),
(524, 156, '18'),
(525, 156, '28'),
(526, 157, '20 % of GDP'),
(527, 157, '6,3 % of GDP'),
(528, 157, '0,5 % of GDP'),
(529, 157, 'Governmental expenditures on education are 0'),
(530, 158, 'No children are working'),
(531, 158, 'Around 2 million'),
(532, 158, 'Around 10 million'),
(533, 158, 'Around 500.000'),
(534, 159, 'University/College Test VN'),
(535, 159, 'National Graduation Examination'),
(536, 159, 'SAT'),
(537, 159, 'GMAT'),
(538, 160, '50:50'),
(539, 160, '10:90'),
(540, 160, '0:100'),
(541, 160, '100:0'),
(542, 161, 'Primary school'),
(543, 161, 'Secondary school'),
(544, 161, 'High school'),
(545, 161, 'All  are correct'),
(546, 162, 'They improve community feeling'),
(547, 162, 'They decrease peer pressure'),
(548, 162, 'They are easier to clean'),
(549, 162, 'Teachers will not judge students'' clothing'),
(550, 163, '8 years'),
(551, 163, '10 years'),
(552, 163, '12 years'),
(553, 163, '13 years'),
(554, 164, '4'),
(555, 164, '5'),
(556, 164, '6'),
(557, 164, '7'),
(558, 165, 'A focus on creativity'),
(559, 165, 'Practical training rather than theory'),
(560, 165, 'Student-oriented teaching'),
(561, 165, 'A lack of science and math'),
(562, 166, 'Studious and passively attentive'),
(563, 166, 'Interactive and communicative'),
(564, 166, 'Creative and Questioning'),
(565, 166, 'Interactive and Creative'),
(566, 167, '60 to 100 USD per month'),
(567, 167, '80 to 120 USD per month'),
(568, 167, '100  to 140 USD per month'),
(569, 167, '120 to 160 USD per month'),
(570, 168, 'Give extra classes at their houses'),
(571, 168, 'Get another job'),
(572, 168, 'Monthly salary is enough for their living'),
(573, 168, 'Home classes or get another job'),
(574, 169, '3'),
(575, 169, '4'),
(576, 169, '5'),
(577, 169, '4 or 5'),
(578, 170, 'Mathematics and Vietnamese literature  '),
(579, 170, 'Mathematics and Physics'),
(580, 170, 'Mathematics and English'),
(581, 170, 'Vietnamese literature and English'),
(582, 171, 'In late April or early May'),
(583, 171, 'In late May or early June'),
(584, 171, 'Early January'),
(585, 171, 'Any time'),
(586, 172, '20 October'),
(587, 172, '25 October'),
(588, 172, '20 November'),
(589, 172, '25 November'),
(590, 173, 'Visit their teachers’ house'),
(591, 173, 'Give gifts to their teachers'),
(592, 173, 'Do not weara  uniform to school'),
(593, 173, 'Visit and give their teacher gifts'),
(594, 174, '65%'),
(595, 174, '70%'),
(596, 174, '75%'),
(597, 174, '80%'),
(598, 175, 'In early January'),
(599, 175, 'In late June'),
(600, 175, 'In early July'),
(601, 175, 'In late September'),
(606, 177, 'Group A'),
(607, 177, 'Group B'),
(608, 177, 'Group C'),
(609, 177, 'Group D'),
(610, 178, 'Mathematics, Physics, Chemistry'),
(611, 178, 'Mathematics, Physics, Biology'),
(612, 178, 'Mathematics, Biology, Chemistry'),
(613, 178, 'Mathematics, Biology, Physics'),
(614, 179, 'High infant mortality rate'),
(615, 179, 'Old/wrong hospital equipment'),
(616, 179, 'Child obesity'),
(617, 179, 'All  are correct'),
(618, 180, '2007'),
(619, 180, '2008'),
(620, 180, '2009'),
(621, 180, '2010'),
(622, 181, 'USD 2.000'),
(623, 181, 'USD 10.000'),
(624, 181, 'USD 950'),
(625, 181, 'University is free of charge '),
(626, 182, '1,5 million'),
(627, 182, '5,3 million'),
(628, 182, '3,2 million'),
(629, 182, 'None are correct'),
(630, 183, 'Being able to read and write'),
(631, 183, 'Minimum age of 15'),
(632, 183, 'Being enrolled in a school'),
(633, 183, 'Being able to read at 3 book a day'),
(634, 184, '50:1'),
(635, 184, '15:1'),
(636, 184, ' 25:1'),
(637, 184, '10:1'),
(638, 185, 'Underweight'),
(639, 185, 'Stunted growth'),
(640, 185, 'Undeveloped bones'),
(641, 185, 'All are correct'),
(642, 186, 'The central highlands'),
(643, 186, 'Big cities'),
(644, 186, 'Coastal areas'),
(645, 186, 'All areas suffer equally'),
(646, 187, 'Generally females are favoured over males'),
(647, 187, 'Limited economic opportunities'),
(648, 187, 'Public Policy'),
(649, 187, 'A and B are correct'),
(650, 188, 'Eating various kinds of food'),
(651, 188, 'Avoiding salty food'),
(652, 188, 'Breastfeeding babies'),
(653, 188, 'All are correct'),
(654, 189, 'Excellence in many subjects'),
(655, 189, 'Respect for teachers and promotion of learning'),
(656, 189, 'Overseas study'),
(657, 189, 'Practical over theory'),
(658, 190, 'Wheat allergy'),
(659, 190, 'Lactose intolerance'),
(660, 190, 'Gluten intolerance'),
(661, 190, 'Pork intolerance'),
(662, 191, 'Grammar and reading comprehension'),
(663, 191, 'Listening and reading comprehension'),
(664, 191, 'Speaking and listening comprehension'),
(665, 191, 'Writing and speaking'),
(666, 192, 'Asia'),
(667, 192, 'Latin Caribbean'),
(668, 192, 'Africa'),
(669, 192, 'Middle East'),
(670, 193, '30-40%'),
(671, 193, '40-50%'),
(672, 193, '50-60%'),
(673, 193, '60-70%'),
(674, 194, 'In the summer'),
(675, 194, ' In the summer and winter'),
(676, 194, 'In the winter and spring'),
(677, 194, 'During the fall'),
(682, 196, 'Registration office'),
(683, 196, 'The groom’s house'),
(684, 196, 'The bride’s backyard'),
(685, 196, 'Local Department of Justice'),
(686, 197, '12'),
(687, 197, '16'),
(688, 197, '18'),
(689, 197, '20'),
(690, 198, '1,5 USD per day'),
(691, 198, '2 USD per day'),
(692, 198, '1,25 USD per day'),
(693, 198, '10 USD per day'),
(694, 199, 'Reducing world hunger'),
(695, 199, 'Achieving primary education'),
(696, 199, 'Ensuring environmental sustainability'),
(697, 199, 'Protecting endangered species'),
(698, 200, 'A combination of life expectancy, education, and i'),
(699, 200, 'GDP development over the last five years'),
(700, 200, 'Growth of a country’s population'),
(701, 200, 'Ratio between young and old people'),
(702, 201, 'Hanoi'),
(703, 201, 'HCMC'),
(704, 201, 'Hanoi and HCMC'),
(705, 201, 'Beijing'),
(706, 202, 'Black pepper'),
(707, 202, 'Rice'),
(708, 202, 'Cashew nuts'),
(709, 202, 'All correct'),
(714, 204, 'Receive lucky money'),
(715, 204, 'Put on new clothes'),
(716, 204, 'Play games'),
(717, 204, 'Receive money and new clothes'),
(718, 205, 'Self-confidence and self-esteem'),
(719, 205, 'Obedience and self-esteem'),
(720, 205, 'Self-confidence and respect'),
(721, 205, 'Obedience and respect'),
(722, 206, 'Change their life through education'),
(723, 206, 'Education is highly valued in Vietnamese’s culture'),
(724, 206, 'Education is a means of family advancement'),
(725, 206, 'All are correct'),
(730, 208, 'Give their parents money to take care themselves'),
(731, 208, 'Build a house for their parents'),
(732, 208, 'Send their parents to nursing homes'),
(733, 208, 'Take care of their parents in their own home'),
(734, 209, 'Hanoi'),
(735, 209, 'HCMC'),
(736, 209, 'Hanoi and HCMC'),
(737, 209, 'Beijing'),
(738, 210, 'USA'),
(739, 210, 'Russia'),
(740, 210, 'China'),
(741, 210, 'Cambodia'),
(746, 212, 'Lunar New Year Celebration'),
(747, 212, 'Independence Day'),
(748, 212, 'National Resting Day'),
(749, 212, 'Unification Day'),
(750, 213, 'Receive lucky money and wear new clothes'),
(751, 213, 'Play games'),
(752, 213, 'Go to their friends houses'),
(753, 213, 'Go to school'),
(754, 214, 'Self-confidence and self-esteem'),
(755, 214, 'Obedience and self-esteem'),
(756, 214, 'Self-confidence and respect'),
(757, 214, 'Obedience and respect'),
(758, 215, 'Discipline or punish them physically'),
(759, 215, 'Allow children to do anything they want'),
(760, 215, 'Give them verbal commands'),
(761, 215, 'Give them time outs'),
(766, 217, 'Take care of children and grandchildren'),
(767, 217, 'Perform all household tasks'),
(768, 217, 'Make the final decisions of the family'),
(769, 217, 'Take care of children and household'),
(770, 218, 'Cat and mouse'),
(771, 218, 'Cat and goat'),
(772, 218, 'Cat and tiger'),
(773, 218, 'Duck and Goose'),
(774, 219, 'Help families and people.'),
(775, 219, 'Educate, connect, and activate'),
(776, 219, 'Make money'),
(777, 219, 'Encourage people to travel to Vietnam'),
(782, 221, '4,000,000'),
(783, 221, '43,770'),
(784, 221, '7,000,000'),
(785, 221, '6,900,999'),
(790, 223, 'Take a quiz to gain knowledge.'),
(791, 223, 'Do an activity, such as teaching English to childr'),
(792, 223, 'Share important information on Facebook'),
(793, 223, 'All answers are correct'),
(794, 224, 'Nothing'),
(795, 224, 'The game will be finished. We will have won.'),
(796, 224, 'We do a dance'),
(797, 224, 'Keep playing'),
(798, 225, 'You can add a heart'),
(799, 225, 'You have found your soulmate'),
(800, 225, 'You need to see a doctor'),
(801, 225, 'Someone close to you likes you'),
(802, 226, 'You got a brand new car!'),
(803, 226, 'Add time to your quiz'),
(804, 226, 'Big Ben is coming to get you!'),
(805, 226, 'A steering wheel'),
(806, 227, 'This is the Loch Mess Monster'),
(807, 227, 'Ability to skip ONE question'),
(808, 227, 'Skipping rocks'),
(809, 227, 'Hopscotch'),
(810, 228, 'Tap on the avatar in the top left corner'),
(811, 228, 'I don''t know'),
(812, 228, 'There is no user''s profile'),
(813, 228, 'None of the above'),
(814, 229, '130,000'),
(815, 229, '250,000'),
(816, 229, '950,000'),
(817, 229, '2.5 million'),
(818, 230, 'Blood'),
(819, 230, 'Semen and vaginal fluid'),
(820, 230, 'Breast milk'),
(821, 230, 'Saliva (spit)'),
(822, 231, '110 million'),
(823, 231, '35 million'),
(824, 231, '7 million'),
(825, 231, '83 million'),
(826, 232, 'Reduce the number of people you have sex with'),
(827, 232, 'Use condoms consistently and correctly'),
(828, 232, 'Ask your partner to get tested for STIs'),
(829, 232, 'All are correct'),
(830, 233, '10%'),
(831, 233, '20%'),
(832, 233, '30%'),
(833, 233, '40%'),
(834, 234, 'Take antiviral medications during pregnancy'),
(835, 234, 'Deliver the baby through caesarean (C-section)'),
(836, 234, 'Avoid breastfeeding'),
(837, 234, 'All are correct'),
(838, 235, '2%'),
(839, 235, '5%'),
(840, 235, '7%'),
(841, 235, '10%'),
(842, 236, 'Human Infectious Virus'),
(843, 236, 'Human Immudeficiency Virus'),
(844, 236, 'Heart Infection Virus'),
(845, 236, 'Hepatitis Inert Virus'),
(846, 237, 'Advanced Immune Disease State'),
(847, 237, 'Acquired Immune Disease Syndrome'),
(848, 237, 'Acquired Inert Deficiency State'),
(849, 237, 'Acquired Immune Deficiency Syndrome'),
(850, 238, '25%'),
(851, 238, '17%'),
(852, 238, '12%'),
(853, 238, '8%'),
(858, 240, '48%'),
(859, 240, '3%'),
(860, 240, '35%'),
(861, 240, '11%'),
(862, 241, '380'),
(863, 241, '2.040'),
(864, 241, '10.360'),
(865, 241, '76.570'),
(866, 242, 'Quảng Trị'),
(867, 242, 'Bình Thuận'),
(868, 242, 'Vĩnh Long'),
(869, 242, 'Ho Chi Minh'),
(870, 243, 'Setting up water filter tanks in slums'),
(871, 243, 'Bio-fertilizers'),
(872, 243, 'Waste collection campaigns'),
(873, 243, 'All received grants'),
(874, 244, 'A website about mental health in Vietnam'),
(875, 244, 'A website for youth in Vietnam on climate change'),
(876, 244, 'A website for educators in Vietnam'),
(877, 244, 'A website where you can watch animated films'),
(878, 245, '23%'),
(879, 245, '37%'),
(880, 245, '42%'),
(881, 245, '9%'),
(882, 246, '45%'),
(883, 246, '53%'),
(884, 246, '68%'),
(885, 246, '97%'),
(886, 247, '0,2%'),
(887, 247, '1,4%'),
(888, 247, '2,3%'),
(889, 247, '4,7%'),
(890, 248, '78% in males and 76% in females'),
(891, 248, '82.5% in males and 80.1% in females'),
(892, 248, '96.7 % in males and 97.5% in females'),
(893, 248, '97.5% in males and 96.7% in females'),
(894, 249, 'Mother passes the parasite to an unborn child'),
(895, 249, 'Blood transfusions'),
(896, 249, 'Sharing needles'),
(897, 249, 'All are ways the disease can be passed on'),
(898, 250, 'Brain'),
(899, 250, 'Liver'),
(900, 250, 'Intestines'),
(901, 250, 'None of these places'),
(902, 251, 'Malaria'),
(903, 251, 'Rubella'),
(904, 251, 'Yellow Fever'),
(905, 251, 'Hepatitis A'),
(906, 252, 'Spray homes against mosquitos'),
(907, 252, 'Sleep under a mosquito net'),
(908, 252, 'All answers are correct'),
(909, 252, 'Spray clothing and skin with repellent'),
(910, 253, 'Drug resistant strains of the malaria parasite'),
(911, 253, 'Lack in research funding'),
(912, 253, 'Shortages in medications'),
(913, 253, 'Expense of the medications'),
(914, 254, 'The type of malaria parasite'),
(915, 254, 'The severity of symptoms'),
(916, 254, 'Age'),
(917, 254, 'All are correct'),
(918, 255, 'Cerebral malaria'),
(919, 255, 'Breathing problems'),
(920, 255, 'Organ failure'),
(921, 255, 'All answers are correct'),
(922, 256, 'Polio is a bacterial infection'),
(923, 256, 'Most infected people never know they are infected'),
(924, 256, 'Those who show symptoms always become paralyzed'),
(925, 256, 'There is no vaccine for polio'),
(926, 257, 'Paralysis'),
(927, 257, 'Muscle atrophy for up to 35 years'),
(928, 257, 'Sleep apnea and/or depression'),
(929, 257, 'They are all possible symptoms'),
(930, 258, '13-15 years'),
(931, 258, '5-7 years'),
(932, 258, 'up to 1 year'),
(933, 258, 'up to 4 months'),
(934, 259, 'Cough, runny nose, inflamed eyes, sore throat'),
(935, 259, 'Tiny white spots inside the mouth'),
(936, 259, 'A skin rash of large, flat blotches'),
(937, 259, 'All are symptoms of measles'),
(938, 260, 'No specific antiviral treatment exists for measles'),
(939, 260, 'Immune serum globulin'),
(940, 260, 'Post-exposure vaccination within 72 hours'),
(941, 260, 'Antibiotics'),
(942, 261, 'To help families and children'),
(943, 261, 'To educate, connect, and activate people '),
(944, 261, 'To make money'),
(945, 261, 'To encourage people to travel to Vietnam'),
(946, 262, 'UNICEF'),
(947, 262, 'UNICEF, NGOs, Non-profits, and You'),
(948, 262, 'The Justice League'),
(949, 262, 'The Major League'),
(954, 264, 'You must complete a quest'),
(955, 264, 'You must only complete a quiz'),
(956, 264, 'You must only complete an activity'),
(957, 264, 'You must only donate'),
(958, 265, 'Yes'),
(959, 265, 'No'),
(960, 265, 'No, but you will get an award for spending points'),
(961, 265, 'None of these'),
(962, 266, '2%'),
(963, 266, '16%'),
(964, 266, '38%'),
(965, 266, '53%'),
(966, 267, '5/1000'),
(967, 267, '16/1000'),
(968, 267, '23/1000'),
(969, 267, '34/1000'),
(970, 268, '32%'),
(971, 268, '61%'),
(972, 268, '94%'),
(973, 268, '97%'),
(974, 269, '4%'),
(975, 269, '13%'),
(976, 269, '21%'),
(977, 269, '26%'),
(978, 270, '75 years'),
(979, 270, '69 years'),
(980, 270, '62 years'),
(981, 270, '57 years'),
(982, 271, '4%'),
(983, 271, '7%'),
(984, 271, '10%'),
(985, 271, '15%'),
(986, 272, '15%'),
(987, 272, '30%'),
(988, 272, '45%'),
(989, 272, '60%'),
(990, 273, '1 in 10'),
(991, 273, '1 in 5'),
(992, 273, '1 in 4'),
(993, 273, '1 in 3'),
(994, 274, '4'),
(995, 274, '5'),
(996, 274, '6'),
(997, 274, '7'),
(998, 275, '15%'),
(999, 275, '30%'),
(1000, 275, '45%'),
(1001, 275, '6%'),
(1002, 276, '1 in 10'),
(1003, 276, '1 in 5'),
(1004, 276, '1 in 4'),
(1005, 276, '1 in 3'),
(1006, 277, '4'),
(1007, 277, '5'),
(1008, 277, '6'),
(1009, 277, '7'),
(1010, 278, 'Anyone under 18'),
(1011, 278, '15 - 18 year olds'),
(1012, 278, '10 - 19 year olds'),
(1013, 278, '18 - 30 year olds'),
(1014, 279, 'Anyone under the age of 18'),
(1015, 279, 'Girls and boys have not finished growing'),
(1016, 279, 'Anyone under the age of 15'),
(1017, 279, 'Anyone under the age of 10'),
(1018, 280, 'Direct bullying through chat and messaging'),
(1019, 280, 'Posting a harassing message on an email list'),
(1020, 280, 'Creating a website to make fun of the victim'),
(1021, 280, 'All of the above'),
(1022, 281, 'Assaulting a child you care for'),
(1023, 281, 'Process to lure children into sexual behavior '),
(1024, 281, 'Teaching children how to care for themselves'),
(1025, 281, 'Maintaining a safe play environment for children'),
(1026, 282, 'Informative Commercial Technologies'),
(1027, 282, 'Integrative Community Techniques'),
(1028, 282, 'Information and Communication Technologies '),
(1029, 282, 'Information and Communication Techniques'),
(1030, 283, 'Any representation of a child engaged in sex'),
(1031, 283, 'Children filmed or photographed against their will'),
(1032, 283, 'Videos of children filmed in real or simulated sex'),
(1033, 283, 'Any representation of a child engaged in real sex'),
(1034, 284, 'Donate your points'),
(1035, 284, 'Save a child and donate points'),
(1036, 284, 'Give money'),
(1037, 284, 'There are no rewards'),
(1038, 285, 'United States of America'),
(1039, 285, 'China '),
(1040, 285, 'Vietnam'),
(1041, 285, 'Russia'),
(1042, 286, 'You run out of time'),
(1043, 286, 'You run out of hearts'),
(1044, 286, 'You answer 4 questions incorrectly'),
(1045, 286, 'All are possible ways to lose a quiz'),
(1046, 287, 'Volunteer your time by participating in activities'),
(1047, 287, 'Spread NGOs'' messages on social media'),
(1048, 287, 'Donate money on NGOs websites.'),
(1049, 287, 'All of the above'),
(1058, 290, 'You can volunteer your time to support NGOs'),
(1059, 290, 'Your donated points teach you how to donate'),
(1060, 290, 'You can spread NGOs'' messages through social media'),
(1061, 290, 'All are ways to become a HERO'),
(1062, 291, 'Vy, a minority girl who is in need of food '),
(1063, 291, 'Son, a street boy who must sell items from his car'),
(1064, 291, 'Linh, a street girl who sells lottery tickets'),
(1065, 291, 'All of the above'),
(1066, 292, '1'),
(1067, 292, '4'),
(1068, 292, '1000'),
(1069, 292, 'Unlimited'),
(1074, 294, 'United Nations International Children’s Education '),
(1075, 294, 'United Nations International Children''s Encouragem'),
(1076, 294, 'United Nations International Children''s Emergency '),
(1077, 294, 'United Nations International Children''s Equality F'),
(1078, 295, '01 June 1940'),
(1079, 295, '01 June 1946'),
(1080, 295, 'A3. 11 December 1940'),
(1081, 295, '11 December 1946'),
(1082, 296, 'Girls'' education and gender equality:'),
(1083, 296, 'Enhancing quality in primary and secondary educati'),
(1084, 296, 'Education in emergencies and post-crisis transitio'),
(1085, 296, 'All are correct'),
(1086, 297, 'unicef.org'),
(1087, 297, 'un.org'),
(1088, 297, 'unicef-irc.org'),
(1089, 297, 'unicefinnovation.org'),
(1090, 298, 'Jackie Chan'),
(1091, 298, 'David Beckham'),
(1092, 298, 'Orlando Bloom'),
(1093, 298, 'Angelina Jolie'),
(1094, 299, 'Reduce number of unvaccinated children to ZERO'),
(1095, 299, 'Reduce number of daily preventable deaths to ZERO'),
(1096, 299, 'Reduce number of malnourished children to ZERO'),
(1097, 299, 'Reduce number of illiterate children to ZERO'),
(1098, 300, 'Network of young adults raising funds for children'),
(1099, 300, 'Develop the next generation to help UNICEF'),
(1100, 300, 'Create a world where kids realize their potential'),
(1101, 300, 'All of the Above'),
(1102, 301, 'All children in developing countries'),
(1103, 301, 'Preschool-aged children'),
(1104, 301, 'Primary school-aged children (6-11)'),
(1105, 301, 'Orphaned children'),
(1106, 302, 'Eastern and Southern Africa'),
(1107, 302, 'South Asia'),
(1108, 302, 'West Asia'),
(1109, 302, 'Sub-Saharan Africa'),
(1110, 303, 'eradicate poverty/hunger & universal primary edu'),
(1111, 303, 'universal primary edu & gender equality'),
(1112, 303, 'gender equality & global partnership & development'),
(1113, 303, 'eradicate poverty & global partnership/development'),
(1114, 304, '3'),
(1115, 304, '4'),
(1116, 304, '5'),
(1117, 304, '6'),
(1118, 305, 'Yes'),
(1119, 305, 'No'),
(1120, 305, 'It depends on each child’s specific case'),
(1121, 305, 'Children from rich families have to complete al'),
(1122, 306, 'Permanent household income'),
(1123, 306, 'Parental education'),
(1124, 306, 'Teachers education and experience'),
(1125, 306, 'All of the above'),
(1126, 307, 'Tuition fee'),
(1127, 307, 'Other indirect expenses (uniforms, tutoring, etc.)'),
(1128, 307, 'Bullying'),
(1129, 307, 'All of the above'),
(1130, 308, '9 years'),
(1131, 308, '10 years'),
(1132, 308, '11 years'),
(1133, 308, '12 years'),
(1138, 310, 'A high fever'),
(1139, 310, 'Red and watery eyes'),
(1140, 310, 'Small white spots'),
(1141, 310, 'A skin rash'),
(1142, 311, 'Adult'),
(1143, 311, 'Children'),
(1144, 311, 'Unvaccinated young children'),
(1145, 311, 'Pregnant women'),
(1146, 312, 'Less than 1 dollar'),
(1147, 312, 'More than 1 dollar'),
(1148, 312, 'More than 1 dollar'),
(1149, 312, 'More than 10 dollar'),
(1150, 313, 'Vitamin B supplements'),
(1151, 313, 'Vitamin A supplements'),
(1152, 313, 'Vitamin D supplements'),
(1153, 313, 'Vitamin C supplements'),
(1154, 314, 'Close contact with infected nasal secretions'),
(1155, 314, 'Coughing and sneezing'),
(1156, 314, 'close contact, coughing and sneezing upon'),
(1157, 314, 'All are incorrect'),
(1158, 315, 'Measles is a human disease'),
(1159, 315, 'Measles is known to occur in animals'),
(1160, 315, 'Measles causes death'),
(1161, 315, 'There is a vaccine against Measles'),
(1162, 316, 'Malaria – Mumps - Rubella'),
(1163, 316, 'Measles – Mumps - Rotavirus'),
(1164, 316, 'Measles – Mumps – Rubella'),
(1165, 316, 'None of above'),
(1166, 317, 'Vaccine against Hepatitis B'),
(1167, 317, 'Vaccine against Measles'),
(1168, 317, 'Vaccine against Influenza'),
(1169, 317, 'None of the above.'),
(1170, 318, 'Good hygiene'),
(1171, 318, 'Keeping food at a safe temperature'),
(1172, 318, 'Using clean water and trusted raw materials'),
(1173, 318, 'None of the above.'),
(1174, 319, 'Under 1 year'),
(1175, 319, 'Under 3 years old'),
(1176, 319, 'Under 10 years old'),
(1177, 319, '5 years old or less'),
(1178, 320, 'Know – Request – Protect'),
(1179, 320, 'Know – Check – Protect'),
(1180, 320, 'Know – Check – Protect'),
(1181, 320, 'Know – Check – Protect'),
(1182, 321, '20%'),
(1183, 321, '30%'),
(1184, 321, '40%'),
(1185, 321, '50%'),
(1186, 322, 'UNICEF'),
(1187, 322, 'WHO'),
(1188, 322, 'UNESCO'),
(1189, 322, 'UNDP'),
(1190, 323, '4'),
(1191, 323, '5'),
(1192, 323, '6'),
(1193, 323, '7'),
(1194, 324, 'Nine Dragon River Delta'),
(1195, 324, 'North Central Region'),
(1196, 324, 'Northeast Region'),
(1197, 324, 'Central Highlands.'),
(1198, 325, '17,000'),
(1199, 325, '18,000'),
(1200, 325, '19,000'),
(1201, 325, '20,000'),
(1202, 326, '90'),
(1203, 326, '110'),
(1204, 326, '122'),
(1205, 326, '138'),
(1206, 327, '2 million'),
(1207, 327, '3 million'),
(1208, 327, '4 million'),
(1209, 327, 'None of the Above'),
(1210, 328, 'Private or public hospitals'),
(1211, 328, '(Nearby) local health centers'),
(1212, 328, 'Private clinics (run by a single or group of docto'),
(1213, 328, 'hospitals and health centers'),
(1214, 329, 'First week of June'),
(1215, 329, 'Second week of February'),
(1216, 329, 'Third week of November'),
(1217, 329, 'Last week of April'),
(1218, 330, '“Are you vaccinated?”'),
(1219, 330, '“Are you up-to-date?”'),
(1220, 330, '"Protect your world – get vaccinated"'),
(1221, 330, '“Get vaccinated”'),
(1222, 331, 'Eye care'),
(1223, 331, 'Vitamin K'),
(1224, 331, 'Birth dose of OPV and Hepatitis B vaccine'),
(1225, 331, 'All of above'),
(1226, 332, 'The majority of mothers around the world'),
(1227, 332, 'The majority of newborns around the world'),
(1228, 332, 'mothers & newborn in low/middle income countries'),
(1229, 332, 'none of the above'),
(1230, 333, 'Newborns that are born prematurely'),
(1231, 333, 'Newborns that have low birth weight.'),
(1232, 333, 'Newborns born to HIV-infected mothers.'),
(1233, 333, 'All of above'),
(1234, 334, 'Women with complications of pregnancy.'),
(1235, 334, 'Children with severe anemia'),
(1236, 334, 'People with severe trauma after accidents, surgery'),
(1237, 334, 'All of above'),
(1238, 335, 'When they are three years old'),
(1239, 335, 'During the first month of life'),
(1240, 335, 'During the third month of life'),
(1241, 335, 'During the six month of life'),
(1242, 336, 'Neonatal deaths'),
(1243, 336, 'Measles'),
(1244, 336, 'Phneumonia'),
(1245, 336, 'Malaria'),
(1246, 337, 'Southern Africa'),
(1247, 337, 'North America and South America'),
(1248, 337, 'Southeast Asia'),
(1249, 337, 'Europe'),
(1250, 338, 'Viruses'),
(1251, 338, 'Bacteria'),
(1252, 338, 'Fungi'),
(1253, 338, 'Viruses, Bacteria, Fungi'),
(1254, 339, 'Diarrheal disease can spread from person-to-person'),
(1255, 339, 'It disease can be aggravated by poor person hygien'),
(1256, 339, 'it can be spread from person-to-person and '),
(1257, 339, ''),
(1258, 340, 'It can spread from person-to-person'),
(1259, 340, 'It can be aggravated by poor personal hygiene'),
(1260, 340, 'Both answers are correct'),
(1261, 340, 'Non are correct'),
(1262, 341, 'Labour'),
(1263, 341, 'Birth'),
(1264, 341, 'Immediate postnatal'),
(1265, 341, 'All of above'),
(1266, 342, 'Lipotropic Vitamin B12'),
(1267, 342, 'Insulin'),
(1268, 342, 'Natriclorid'),
(1269, 342, 'Oral Rehydration Salts (ORS)'),
(1270, 343, 'Vaccinations'),
(1271, 343, 'Hand washing with soap'),
(1272, 343, 'Reducing household air pollution.'),
(1273, 343, 'All of above'),
(1274, 344, 'Nigeria, Pakistan and Afghanistan'),
(1275, 344, 'South Africa, Slovenia, Indonesia'),
(1276, 344, 'Sudan, China, Portugal'),
(1277, 344, 'Vietnam, Thailand, Cambodia'),
(1278, 345, 'There is no cure for polio, it can only be prevent'),
(1279, 345, 'The polio vaccine, given multiple times, can prote'),
(1280, 345, 'Both answers are correct'),
(1281, 345, 'None are correct'),
(1282, 346, 'Tuberculosis is caused by bacteria (Mycobacterium '),
(1283, 346, 'Tuberculosis most often affects the lungs'),
(1284, 346, 'Tuberculosis is curable and preventable.'),
(1285, 346, 'All of above'),
(1286, 347, 'Cough, fever, night sweats, weight loss'),
(1287, 347, 'Headache, cough, fever'),
(1288, 347, 'Weight loss, insomina, runny nose'),
(1289, 347, 'No evident symptoms'),
(1290, 348, 'Treating measles'),
(1291, 348, 'Treating the yellow fever'),
(1292, 348, 'Treating tuberculosis'),
(1293, 348, 'Treating diarrhea'),
(1294, 349, '16 per 1000 live births'),
(1295, 349, '17 per 1,000 live births'),
(1296, 349, '18 per 1,000 live births'),
(1297, 349, '19 per 1,000 live births'),
(1298, 350, '68 per 100,000 live births'),
(1299, 350, '69 per 100,000 live births'),
(1300, 350, '70 per 100,000 live births'),
(1301, 350, '71 per 100,000 live births'),
(1302, 351, '15 October'),
(1303, 351, '21 February'),
(1304, 351, '30 November'),
(1305, 351, '22 March'),
(1306, 352, '16 000'),
(1307, 352, '17 000'),
(1308, 352, '18 000'),
(1309, 352, '19 000'),
(1310, 353, 'Breast-feeding'),
(1311, 353, 'Feeding children with various kinds of food'),
(1312, 353, 'Keeping children in good hygienic conditions'),
(1313, 353, 'Both breast-feeding and various food'),
(1314, 354, '20.2%'),
(1315, 354, '32.2%'),
(1316, 354, '14.1%'),
(1317, 354, '21.1%'),
(1318, 355, '4 out of 6 children'),
(1319, 355, '3 out of 6 children'),
(1320, 355, '2 out of 6 children'),
(1321, 355, '1 out of 6 children'),
(1322, 356, 'Diarrhea'),
(1323, 356, 'Fever'),
(1324, 356, 'Measles'),
(1325, 356, 'Mumps'),
(1326, 357, 'Three months (90 days)'),
(1327, 357, 'Six months (180 days)'),
(1328, 357, 'Twelve months (1 years)'),
(1329, 357, 'Twenty-four months (2 years)'),
(1330, 358, 'Informative Commercial Technologies'),
(1331, 358, 'Integrative Community Techniques'),
(1332, 358, 'Information and Communication Technologies'),
(1333, 358, 'Information and Communication Techniques'),
(1334, 359, 'More than a half'),
(1335, 359, 'More than one third'),
(1336, 359, 'Less than a half'),
(1337, 359, 'Less than one third'),
(1338, 360, 'Mother has better health and well-being'),
(1339, 360, 'Children perform better in intelligence tests'),
(1340, 360, 'It reduces the risk of ovarian and breast cancer i'),
(1341, 360, 'All of above'),
(1342, 361, 'Vegetable'),
(1343, 361, 'Cereals'),
(1344, 361, 'Breastmilk'),
(1345, 361, 'Fish or meat gruel'),
(1346, 362, 'the age 6 - 36 months'),
(1347, 362, 'the age 4 - 24 months'),
(1348, 362, 'the age 1 - 12 months'),
(1349, 362, 'the age 12 - 24 months'),
(1350, 363, '25%'),
(1351, 363, '50%'),
(1352, 363, '75%'),
(1353, 363, '100%'),
(1354, 364, 'Vitamin A deficiency (VAD)'),
(1355, 364, 'Vitamin C deficiency (VCD)'),
(1356, 364, 'B Vitamin C deficiency (VCD)  Vitamin D deficiency'),
(1357, 364, 'Lack of breastmilk'),
(1358, 365, '34%'),
(1359, 365, '81%'),
(1360, 365, '52%'),
(1361, 365, '18%'),
(1362, 366, 'Visual impairment and blindness'),
(1363, 366, 'Increased risk of severe illness'),
(1364, 366, 'Death'),
(1365, 366, 'All of above'),
(1366, 367, '30%'),
(1367, 367, '40%'),
(1368, 367, '50%'),
(1369, 367, '60%'),
(1370, 368, 'Medicine'),
(1371, 368, 'Breastfeeding'),
(1372, 368, 'Vaccines'),
(1373, 368, 'None of the above.'),
(1374, 369, '15%'),
(1375, 369, '23%'),
(1376, 369, '53%'),
(1377, 369, '76%'),
(1378, 370, '1 December'),
(1379, 370, '3 July'),
(1380, 370, '20 December'),
(1381, 370, '11 July'),
(1382, 371, '5-10 years'),
(1383, 371, '10-15 years'),
(1384, 371, '15-25 years'),
(1385, 371, '1-5 years'),
(1386, 372, 'Parents have less understanding of the internet'),
(1387, 372, 'There is more convergence of internet and mobiles'),
(1388, 372, 'More children now have private access to internet '),
(1389, 372, 'All make parental oversight more difficult'),
(1390, 373, 'Cancer'),
(1391, 373, 'Tuberculosis'),
(1392, 373, 'Pneumonia'),
(1393, 373, 'None of the above.'),
(1394, 374, 'June 01'),
(1395, 374, 'May 5'),
(1396, 374, 'November 20'),
(1397, 374, 'The first Sunday in June'),
(1398, 375, 'Weight/ Height'),
(1399, 375, 'Height/ Weight'),
(1400, 375, 'Weight/ (Height)2'),
(1401, 375, '(Weight)2/ Height'),
(1402, 376, 'Below 18.5'),
(1403, 376, '18.5-24.9'),
(1404, 376, '25-29'),
(1405, 376, '>30'),
(1406, 377, '20 March'),
(1407, 377, '21 March'),
(1408, 377, '22 March'),
(1409, 377, '23 March'),
(1410, 378, 'Socializing Up National Movement'),
(1411, 378, 'Speaking Up National Movement'),
(1412, 378, 'Socializing Up Nutrition Movement'),
(1413, 378, 'Scaling Up Nutrition Movement'),
(1414, 379, '43th'),
(1415, 379, '44th'),
(1416, 379, '45th'),
(1417, 379, '46th'),
(1418, 380, 'Police of Vietnam'),
(1419, 380, 'People''s Public Security of Vietnam'),
(1420, 380, 'There are no police in Vietnam'),
(1421, 380, 'None of the above'),
(1422, 381, '19 August'),
(1423, 381, '22 March'),
(1424, 381, '1 May'),
(1425, 381, '1 August'),
(1426, 382, 'UNs International Children''s Education Fund'),
(1427, 382, 'UNs International Children''s Encouragement Fund'),
(1428, 382, 'UNs International Children''s Emergency Fund'),
(1429, 382, 'UNs International Children''s Equality Fund'),
(1430, 383, '1 million'),
(1431, 383, '6 million'),
(1432, 383, '10 million'),
(1433, 383, '2 million'),
(1434, 384, '01 June 1940'),
(1435, 384, '01 June 1946'),
(1436, 384, '11 December 1940'),
(1437, 384, '11 December 1946'),
(1438, 385, '5'),
(1439, 385, '6'),
(1440, 385, '7'),
(1441, 385, '8'),
(1442, 386, 'www.unicef.org'),
(1443, 386, 'http://www.un.org'),
(1444, 386, 'www.unicef-irc.org'),
(1445, 386, 'www.unicefinnovation.org'),
(1446, 387, '1985'),
(1447, 387, '1989'),
(1448, 387, '1990'),
(1449, 387, '1992'),
(1450, 388, '1989'),
(1451, 388, '1990'),
(1452, 388, '1991'),
(1453, 388, '1992'),
(1454, 389, '190'),
(1455, 389, '192'),
(1456, 389, '194'),
(1457, 389, '195'),
(1458, 390, 'Girls'' education and gender equality'),
(1459, 390, 'Enhancing quality in primary education'),
(1460, 390, 'Education in emergencies and post-crisis'),
(1461, 390, 'All are correct'),
(1462, 391, 'Afghanistan, Iraq and Iran'),
(1463, 391, 'Afghanistan, Zimbabwe and Somalia'),
(1464, 391, 'Somalia, the United States and South Sudan'),
(1465, 391, 'Iran, Zimbabwe and Uganda'),
(1466, 392, 'School'),
(1467, 392, 'Family'),
(1468, 392, 'Community'),
(1469, 392, 'Society'),
(1474, 394, '15'),
(1475, 394, '16'),
(1476, 394, '18'),
(1477, 394, '20'),
(1478, 395, 'The right to an education'),
(1479, 395, 'The right to play'),
(1480, 395, 'The right to disobey parents'),
(1481, 395, 'All of the above'),
(1482, 396, 'Respect for their views'),
(1483, 396, 'Freedom of association'),
(1484, 396, 'Right to access information'),
(1485, 396, 'All of the above'),
(1486, 397, 'Number of children who have not been vaccinated'),
(1487, 397, 'Number of daily preventable deaths of children'),
(1488, 397, 'Number of children suffering from malnourishment'),
(1489, 397, 'Number of illiterate children'),
(1490, 398, 'Letting the child always decide'),
(1491, 398, 'Children can represent themselves in court '),
(1492, 398, 'Letting children express their views'),
(1493, 398, 'Involving the child in decisions that affect them'),
(1494, 399, 'Create a network of adults that support UNICEF'),
(1495, 399, 'Develop the next generation of UNICEF supporters'),
(1496, 399, 'Create a world where all children survive'),
(1497, 399, 'All of the above'),
(1498, 400, 'Non-discrimination'),
(1499, 400, 'Best interests of the child'),
(1500, 400, 'Right to life, survival and development'),
(1501, 400, 'Right to play'),
(1502, 401, 'Emotional and physical abuse'),
(1503, 401, 'Neglect or negligent treatment'),
(1504, 401, 'Sexual exploitation and abuse of children'),
(1505, 401, 'All are examples of violence against children'),
(1510, 403, 'All children in developing countries'),
(1511, 403, 'Preschool-aged children'),
(1512, 403, 'Primary school-aged children'),
(1513, 403, 'Orphaned children'),
(1514, 404, 'Support parents in taking care of their children'),
(1515, 404, 'Teach children life skills'),
(1516, 404, 'Strengthen policies and laws that protect children'),
(1517, 404, 'All of the above'),
(1518, 405, 'Eastern and Southern Africa'),
(1519, 405, 'Southeast Asia'),
(1520, 405, 'South America'),
(1521, 405, 'Sub-Saharan Africa'),
(1522, 406, '3.5 million'),
(1523, 406, '4.3 million'),
(1524, 406, '4.7 million'),
(1525, 406, '5.5 million'),
(1526, 407, 'lifelong physical and mental health problems'),
(1527, 407, 'anti-social behaviour'),
(1528, 407, 'Slow economic and social development'),
(1529, 407, 'All of above.'),
(1530, 408, 'Goal 1: eradicate extreme poverty and hunger'),
(1531, 408, 'Goal 3: gender equality'),
(1532, 408, 'Goal 2: universal primary education'),
(1533, 408, 'Goal 2 and Goal 3'),
(1534, 409, 'Yes, they do'),
(1535, 409, 'No, they don''t'),
(1536, 409, 'It depends on each child''s case'),
(1537, 409, 'Only children of rich families need to complete'),
(1542, 411, 'Tuition fees'),
(1543, 411, 'School expenses (uniforms, books, boarding, etc)'),
(1544, 411, 'Bullying'),
(1545, 411, 'All are correct'),
(1546, 412, '9 years'),
(1547, 412, '10 years'),
(1548, 412, '11 years'),
(1549, 412, '12 years'),
(1550, 413, '94% of 6 to 12-year-olds'),
(1551, 413, '96% of 6 to 11-year-olds'),
(1552, 413, '94% of 7 to 12-year-olds'),
(1553, 413, '96% of 7 to 12-year-olds'),
(1554, 414, 'A high fever'),
(1555, 414, 'Red and watery eyes'),
(1556, 414, 'Small white spots'),
(1557, 414, 'A skin rash'),
(1558, 415, 'Adults'),
(1559, 415, 'Chilren'),
(1560, 415, 'Unvaccinated young children'),
(1561, 415, 'Pregnant women'),
(1562, 416, 'Less and 1 dollar'),
(1563, 416, 'More than 1 dollar'),
(1564, 416, 'More than 10 dollars'),
(1565, 416, 'Less than 10 dollars'),
(1566, 417, 'Vitamin A supplements'),
(1567, 417, 'Vitamin B supplements'),
(1568, 417, 'Vitamin C supplements'),
(1569, 417, 'Vitamin D supplements'),
(1570, 418, 'Contact with bodily fluids, coughing and sneezing'),
(1571, 418, 'A bite from an infected mosquito'),
(1572, 418, 'Prolonged exposure to radiation'),
(1573, 418, 'From mother to child in breatmilk'),
(1574, 419, 'Cigarette smoking and unhealthy eating'),
(1575, 419, 'Alcohol and drug abuse'),
(1576, 419, 'Depression and attempted suicide'),
(1577, 419, 'All of the above'),
(1578, 420, 'Loss of productivity'),
(1579, 420, 'Disability'),
(1580, 420, 'Decreased quality of life'),
(1581, 420, 'All of the above'),
(1582, 421, 'Body ownership'),
(1583, 421, 'How to recognize an abusive situation and say “NO”'),
(1584, 421, 'How to disclose abuse to a trusted adult'),
(1585, 421, 'All of the above'),
(1586, 422, 'Physical health problems: brain injuries, bruises.'),
(1587, 422, 'Difficulties in dealing with other people.'),
(1588, 422, 'Learning problems.'),
(1589, 422, 'All of the above'),
(1590, 423, 'Physical and/or emotional ill-treatment'),
(1591, 423, 'Sexual abuse'),
(1592, 423, 'Labour exploitation'),
(1593, 423, 'All of the above'),
(1594, 424, '100%'),
(1595, 424, '75%'),
(1596, 424, '50%'),
(1597, 424, '30%'),
(1598, 425, 'Kicking, shaking, or throwing the child'),
(1599, 425, 'Pinching or pulling the hair'),
(1600, 425, 'Burning or scarring the child'),
(1601, 425, 'All of the above'),
(1602, 426, 'Measles is a human disease'),
(1603, 426, 'Measles is known to occur in animals'),
(1604, 426, 'Measles causes death'),
(1605, 426, 'There is a vaccine against Measles'),
(1606, 427, 'Show and tell what they should do'),
(1607, 427, 'Try to say ‘yes’ and ‘well done’'),
(1608, 427, 'Rely on rewards like hugs & jokes, not punishments'),
(1609, 427, 'All of the above'),
(1610, 428, 'Malaria-Mumps-Rubella'),
(1611, 428, 'Measles-Mumps-Rotavirus'),
(1612, 428, 'Measles-Mumps-Rubella'),
(1613, 428, 'None of the above'),
(1614, 429, 'Attention seeking behaviors'),
(1615, 429, 'Fear of new situations'),
(1616, 429, 'Both answers are correct'),
(1617, 429, 'None are correct'),
(1618, 430, '2 times'),
(1619, 430, '3 times'),
(1620, 430, '4 times'),
(1621, 430, '6 times'),
(1622, 431, '1 million'),
(1623, 431, '1.5 million'),
(1624, 431, '2 million'),
(1625, 431, '2.5 million'),
(1626, 432, '10%'),
(1627, 432, '15%'),
(1628, 432, '30%'),
(1629, 432, '25%'),
(1630, 433, 'Vaccine against Hepatitis B'),
(1631, 433, 'Vaccine against Measles'),
(1632, 433, 'Vaccine against Influenza'),
(1633, 433, 'None of the above'),
(1634, 434, 'Provide a safe environment '),
(1635, 434, 'Tell the child it was not his/her fault'),
(1636, 434, 'Listen & document the child’s exact quotes'),
(1637, 434, 'All of the above '),
(1638, 435, 'Investigate'),
(1639, 435, 'Ask leading questions'),
(1640, 435, 'Make promises that you cannot keep.'),
(1641, 435, 'All of the above'),
(1642, 436, '3'),
(1643, 436, '5'),
(1644, 436, '7'),
(1645, 436, '10'),
(1646, 437, '1.5 million'),
(1647, 437, '2.2 million'),
(1648, 437, '3.3 million'),
(1649, 437, '4 million'),
(1654, 439, '50 million'),
(1655, 439, '100 million'),
(1656, 439, '200 million'),
(1657, 439, '300 million'),
(1658, 440, 'A. Genes provide blueprints for brain development'),
(1659, 440, 'B. Environment shapes genes.'),
(1660, 440, 'C. Nature'),
(1661, 440, 'D. Both A and B are correct.'),
(1662, 441, 'In the first few years of life'),
(1663, 441, 'Between the ages of 5-10'),
(1664, 441, 'Between the ages of 10-15'),
(1665, 441, 'Between the ages of 15-25'),
(1666, 442, 'When a child is under 5 years of age'),
(1667, 442, 'From 5 years old to puberty'),
(1668, 442, 'During puberty'),
(1669, 442, 'In adulthood'),
(1670, 443, 'Nutrition that feeds the brain'),
(1671, 443, 'Healthy interactions that reduce illness'),
(1672, 443, 'Protection from stress'),
(1673, 443, 'All of the answers are correct'),
(1674, 444, '25%'),
(1675, 444, '50%'),
(1676, 444, 'Between 50 and 75%'),
(1677, 444, '80%'),
(1678, 445, 'Body is unable to metabolize key nutrients'),
(1679, 445, 'Lowers absorption capacity of vital organs'),
(1680, 445, 'Decreases the effectiveness of supplements '),
(1681, 445, 'All are correct'),
(1682, 446, 'Body stress caused by poisonous chemicals'),
(1683, 446, 'Stress of experiencing violence, abuse, neglect'),
(1684, 446, 'Low levels of the hormone cortisol'),
(1685, 446, 'Body stressed caused by obesity'),
(1686, 447, 'A good teacher'),
(1687, 447, 'Classroom supplies'),
(1688, 447, 'Going to school 6 days a week'),
(1689, 447, 'Positive interactions between a child and his/her '),
(1690, 448, 'After puberty'),
(1691, 448, 'By six years of age'),
(1692, 448, 'Up until puberty'),
(1693, 448, 'The foundation is always changing. '),
(1694, 449, 'In mothers breastfeeding encourages bonding'),
(1695, 449, 'Better nutrition leads to better brain development'),
(1696, 449, 'It provides stimulation and nuturing'),
(1697, 449, 'All answers are correct'),
(1698, 450, '1 out of 4'),
(1699, 450, '1 out of 3'),
(1700, 450, '2 out of 5'),
(1701, 450, '1 out of 2'),
(1702, 451, 'It is only half full'),
(1703, 451, 'It is half the size of an adult brain'),
(1704, 451, 'It is twice the size of an adult brain'),
(1705, 451, 'It has twice as much information as an adult''s'),
(1706, 452, '23%'),
(1707, 452, '56%'),
(1708, 452, '71%'),
(1709, 452, '87%'),
(1710, 453, 'Under 1 year'),
(1711, 453, 'Under 3 years'),
(1712, 453, 'Under 10 years'),
(1713, 453, 'Under 5 years'),
(1714, 454, '20%'),
(1715, 454, '30%'),
(1716, 454, '40%'),
(1717, 454, '50%'),
(1718, 455, 'UNICEF'),
(1719, 455, 'WHO'),
(1720, 455, 'UNESCO'),
(1721, 455, 'UNDP'),
(1722, 456, '17,000'),
(1723, 456, '18,000'),
(1724, 456, '19,000'),
(1725, 456, '20,000'),
(1726, 457, '52'),
(1727, 457, '96'),
(1728, 457, '122'),
(1729, 457, '153'),
(1730, 458, '1 million'),
(1731, 458, '3 million'),
(1732, 458, '10 million'),
(1733, 458, '20 million'),
(1734, 459, 'A. Private and public hospitals'),
(1735, 459, 'B. (Nearby) local health centers'),
(1736, 459, 'C. Local government offices'),
(1737, 459, 'A and B are correct'),
(1738, 460, 'First week of June'),
(1739, 460, 'First week of January'),
(1740, 460, 'Last week in April'),
(1741, 460, 'Last week in December'),
(1742, 461, 'Are you up to date?'),
(1743, 461, 'Are you vaccinated?'),
(1744, 461, 'Protect your world--get vacinnated'),
(1745, 461, 'Get Vaccinated'),
(1746, 462, 'The majority of mothers around the world'),
(1747, 462, 'The majority of newborns around the world'),
(1748, 462, 'Mothers and newborns in low-middle income countrie'),
(1749, 462, 'None of the above'),
(1798, 475, 'With history of violence among parents'),
(1799, 475, 'Of low educated parents'),
(1800, 475, 'With economic difficulties'),
(1801, 475, 'All of the answeres are correct'),
(1802, 476, 'With economic difficulties'),
(1803, 476, 'Of divorced parents/no biological parents'),
(1804, 476, 'In rural/remote areas'),
(1805, 476, 'All of the answers are correct'),
(1806, 477, '500'),
(1807, 477, '2,000'),
(1808, 477, '5,600'),
(1809, 477, '7,000'),
(1810, 478, '25%'),
(1811, 478, '20%'),
(1812, 478, '10%'),
(1813, 478, '5%'),
(1814, 479, 'January 01'),
(1815, 479, 'June 01'),
(1816, 479, 'September 01'),
(1817, 479, 'November 01'),
(1818, 480, '5%'),
(1819, 480, '18%'),
(1820, 480, '26%'),
(1821, 480, '50%'),
(1822, 481, '5%'),
(1823, 481, '17%'),
(1824, 481, '32%'),
(1825, 481, '57%'),
(1826, 482, 'Poorer sections of the population'),
(1827, 482, 'Wealthier sections of the population'),
(1828, 482, 'There is no difference between wealthy and poor'),
(1829, 482, 'It depends on the country'),
(1830, 483, 'No education'),
(1831, 483, 'Primary school education'),
(1832, 483, 'Secondary school education');
INSERT INTO `choice` (`Id`, `QuestionId`, `Content`) VALUES
(1833, 483, 'University/College education'),
(1834, 484, '12%'),
(1835, 484, '26%'),
(1836, 484, '45%'),
(1837, 484, '53%'),
(1838, 485, '10%'),
(1839, 485, '20%'),
(1840, 485, '25%'),
(1841, 485, '33%'),
(1842, 486, 'Early pregnancy and social isolation'),
(1843, 486, 'Interrupts her schooling'),
(1844, 486, 'Limits her career and vocational options'),
(1845, 486, 'All are negative affects of child marriage'),
(1846, 487, '150 million'),
(1847, 487, '100 million'),
(1848, 487, '50 million'),
(1849, 487, '25 million'),
(1850, 488, 'A. They cannot receive healthcare '),
(1851, 488, 'B. They cannot obtain an education'),
(1852, 488, 'C. They might be hired or conscripted before legal'),
(1853, 488, 'A, B and C'),
(1854, 489, 'A. They cannot obtain healthcare'),
(1855, 489, 'B. They cannot obtain an education'),
(1856, 489, 'C. They might be conscripted or hired under age'),
(1857, 489, 'A, B, and C'),
(1858, 490, '50 million'),
(1859, 490, '100 million'),
(1860, 490, '230 million'),
(1861, 490, '500 million'),
(1862, 491, '5%'),
(1863, 491, '20%'),
(1864, 491, '30%'),
(1865, 491, '45%'),
(1866, 492, '10,000'),
(1867, 492, '100,000'),
(1868, 492, '200,000'),
(1869, 492, '1 million'),
(1870, 493, '10%'),
(1871, 493, '20%'),
(1872, 493, '40%'),
(1873, 493, '60%'),
(1874, 494, '10%'),
(1875, 494, '25%'),
(1876, 494, '50%'),
(1877, 494, '75%'),
(1878, 495, '65%'),
(1879, 495, '50%'),
(1880, 495, '25%'),
(1881, 495, '10%'),
(1882, 496, '5-10%'),
(1883, 496, '25-45%'),
(1884, 496, '15-20%'),
(1885, 496, '45-75%'),
(1886, 497, '4 days before the rash appears'),
(1887, 497, '4 days after the rash appears'),
(1888, 497, 'Measles is not transmittable between people'),
(1889, 497, '4 days before and 4 days after the rash appears'),
(1890, 498, '2 years'),
(1891, 498, '10 years'),
(1892, 498, '25 years'),
(1893, 498, 'over 50 years'),
(1894, 499, '95%'),
(1895, 499, '84%'),
(1896, 499, '75%'),
(1897, 499, '51%'),
(1898, 500, '55 million'),
(1899, 500, '105 million'),
(1900, 500, '205 million'),
(1901, 500, '555 million');

-- --------------------------------------------------------

--
-- Table structure for table `donation`
--

CREATE TABLE IF NOT EXISTS `donation` (
`Id` int(11) NOT NULL,
  `Title` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Description` varchar(8000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RequiredPoint` int(11) DEFAULT NULL,
  `MedalId` int(11) DEFAULT NULL,
  `PartnerId` int(11) DEFAULT NULL,
  `IsApproved` bit(1) DEFAULT b'0',
  `CreateDate` datetime DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `function`
--

CREATE TABLE IF NOT EXISTS `function` (
`Id` int(11) NOT NULL,
  `Name` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IconURL` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FuncURL` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE IF NOT EXISTS `groups` (
`id` mediumint(8) unsigned NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `description` varchar(100) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `name`, `description`) VALUES
(1, 'admin', 'Administrator'),
(2, 'members', 'General User');

-- --------------------------------------------------------

--
-- Stand-in structure for view `leaderboard`
--
CREATE TABLE IF NOT EXISTS `leaderboard` (
`id` int(11)
,`name` varchar(45)
,`avatar` int(11)
,`mark` int(11)
,`facebook_id` varchar(45)
,`current_level` int(11)
,`rank` bigint(22)
);
-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE IF NOT EXISTS `login_attempts` (
`id` int(11) unsigned NOT NULL,
  `ip_address` varbinary(16) NOT NULL,
  `login` varchar(100) CHARACTER SET utf8 NOT NULL,
  `time` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medal`
--

CREATE TABLE IF NOT EXISTS `medal` (
`Id` int(11) NOT NULL,
  `Name` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ImageURL` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Type` int(11) NOT NULL DEFAULT '0' COMMENT 'NOT IN USE. 0: quest, 1: Activity, 2: Donation.',
  `ObjectId` int(11) NOT NULL DEFAULT '0' COMMENT 'NOT IN USE. The id of quest if this is quest medal.'
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `medal`
--

INSERT INTO `medal` (`Id`, `Name`, `ImageURL`, `Type`, `ObjectId`) VALUES
(0, 'Heart Refills', 'http://heroforzero.be/assets/img/profile/05_Donations/buy-heart-icon@2x.png', 2, 11),
(1, 'Add more time', 'http://heroforzero.be/assets/img/profile/05_Donations/buy-skip-icon@2x.png', 2, 12),
(2, 'Skip the question', 'http://heroforzero.be/assets/img/profile/05_Donations/buy-time-icon@2x.png', 2, 13),
(3, 'Guardian Angel', 'http://heroforzero.be/assets/img/profile/05_Donations/donate-guaridan-icon@2x.png', 2, 0),
(4, 'Earn a sword', 'http://heroforzero.be/assets/img/quest/training-sword.png', 0, 1),
(5, 'Earn a shield', 'http://heroforzero.be/assets/img/quest/training-shield.png', 0, 2),
(6, 'Earn a cape', 'http://heroforzero.be/assets/img/quest/training-cape.png', 0, 3),
(7, 'Save Vy from hunger', 'http://heroforzero.be/assets/img/quest/nutrition-minority.png', 0, 5),
(8, 'Help Lau find food', 'http://heroforzero.be/assets/img/quest/nutrition-buddist.png', 0, 6),
(9, 'Give to help Minh eat', 'http://heroforzero.be/assets/img/quest/nutrition-streetkid.png', 0, 14),
(10, 'Help Son get an education', 'http://heroforzero.be/assets/img/quest/education-streetworker.png', 0, 7),
(11, 'Help Mai go to shool', 'http://heroforzero.be/assets/img/quest/education-minority.png', 0, 8),
(12, 'Give Linh sholarships', 'http://heroforzero.be/assets/img/quest/education-lottogirl.png', 0, 9),
(13, 'Save Mai from the wolf', 'http://heroforzero.be/assets/img/quest/3.png', 0, 10),
(14, 'Save Lac from abuse', 'http://heroforzero.be/assets/img/quest/protection-abused.png', 0, 15),
(15, 'Help Wie get treatment', 'http://heroforzero.be/assets/img/quest/health-sick.png', 0, 11),
(16, 'Disease', 'http://heroforzero.be/assets/img/quest/2.png', 0, 12),
(17, 'Donate 10 points to complete the Training', 'http://heroforzero.be/assets/img/awards/award_donations@2x.png', 2, 0),
(18, 'We need 3 new bicycles', 'http://heroforzero.be/assets/img/awards/award_donations2@2x.png', 2, 0),
(19, 'A roof of the house for boys here need replac', 'http://heroforzero.be/assets/img/awards/award_roof@2x.png', 2, 0),
(20, 'Nutritional care', 'http://heroforzero.be/assets/img/awards/award_food@2x.png', 2, 0),
(21, 'Health care', 'http://heroforzero.be/assets/img/awards/award_medical@2x.png', 2, 0),
(22, 'Educational expense', 'http://heroforzero.be/assets/img/awards/award_educational@2x.png', 2, 0),
(23, 'The regular expense of a child', 'http://heroforzero.be/assets/img/awards/award_donations@2x.png', 2, 0),
(24, '$250 for the operational expense of a KNS cou', 'http://heroforzero.be/assets/img/awards/award_donations@2x.png', 2, 0),
(25, '$50 for the financial aid of vocational train', 'http://heroforzero.be/assets/img/awards/award_vocational@2x.png', 2, 0),
(26, '$2 for the financial aid of a child’s study.', 'http://heroforzero.be/assets/img/awards/award_educational@2x.png', 2, 0),
(27, 'Breakfasts', 'http://heroforzero.be/assets/img/awards/award_food@2x.png', 2, 0),
(28, 'School uniforms', 'http://heroforzero.be/assets/img/awards/award_donations@2x.png', 2, 0),
(29, 'Donate 10 points to get Training Award', 'http://heroforzero.be/assets/img/awards/award_donations@2x.png', 2, 0),
(30, 'School uniforms', 'http://heroforzero.be/assets/img/awards/award_donations@2x.png', 2, 0),
(31, 'Help Tu get treatment', 'http://heroforzero.be/assets/img/quest/nutrition-minority.png', 0, 4),
(32, 'General Health', 'http://heroforzero.be/assets/img/quest/3.png', 0, 13),
(33, 'Help Ty away from school bully', 'http://heroforzero.be/assets/img/quest/nutrition-streetkid.png', 0, 0),
(34, 'Help Ty', 'http://heroforzero.be/assets/img/quest/training-sword.png', 0, 0),
(35, 'Help Ty away from school bullying', 'http://heroforzero.be/assets/img/quest/nutrition-streetkid.png', 0, 0),
(36, 'Help Ty away from school bullying', 'http://heroforzero.be/assets/img/quest/nutrition-streetkid.png', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `organizationtype`
--

CREATE TABLE IF NOT EXISTS `organizationtype` (
`Id` int(11) NOT NULL,
  `TypeName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `organizationtype`
--

INSERT INTO `organizationtype` (`Id`, `TypeName`) VALUES
(1, 'Local Non-profit organization'),
(2, 'International Non-profit organization'),
(3, 'Child Care Center or Shelter'),
(4, 'Mass Organization'),
(5, 'Religious Organization');

-- --------------------------------------------------------

--
-- Table structure for table `packet`
--

CREATE TABLE IF NOT EXISTS `packet` (
`Id` int(11) NOT NULL,
  `Title` varchar(140) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ImageURL` varchar(140) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PartnerId` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `packet`
--

INSERT INTO `packet` (`Id`, `Title`, `ImageURL`, `PartnerId`) VALUES
(1, 'Hero Training', 'http://mytempbucket.s3.amazonaws.com/1400216231.jpg', 5),
(2, 'Nutrition', 'http://mytempbucket.s3.amazonaws.com/1400226009.jpg', 5),
(3, 'Education', 'http://mytempbucket.s3.amazonaws.com/1400226826.jpg', 5),
(4, 'Protection', 'http://mytempbucket.s3.amazonaws.com/1400225850.jpg', 5),
(6, 'Health', 'http://mytempbucket.s3.amazonaws.com/1400227503.jpg', 5);

-- --------------------------------------------------------

--
-- Table structure for table `partner`
--

CREATE TABLE IF NOT EXISTS `partner` (
`Id` int(11) NOT NULL,
  `PartnerName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `OrganizationTypeId` int(11) DEFAULT NULL,
  `Address` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneNumber` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `WebsiteURL` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Latitude` float DEFAULT NULL,
  `Longtitude` float DEFAULT NULL,
  `Description` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IsApproved` bit(1) NOT NULL DEFAULT b'0',
  `LogoURL` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IconURL` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AdminName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `partner`
--

INSERT INTO `partner` (`Id`, `PartnerName`, `OrganizationTypeId`, `Address`, `PhoneNumber`, `WebsiteURL`, `Latitude`, `Longtitude`, `Description`, `IsApproved`, `LogoURL`, `IconURL`, `AdminName`) VALUES
(46, 'Organization', 4, '123 Nguyen Hue, Q1', '0987654322', 'www.tada.com', NULL, NULL, 'We come to help', b'0', '0', '0', 'Nguyen Van A'),
(47, 'Admin', 1, '39 Phan Khoi', '0123456789', '', NULL, NULL, 'We will help', b'0', '0', '0', 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `partnerdonation`
--

CREATE TABLE IF NOT EXISTS `partnerdonation` (
`DonationId` int(11) NOT NULL,
  `PartnerId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `partner_ext`
--

CREATE TABLE IF NOT EXISTS `partner_ext` (
  `partner_id` int(11) NOT NULL,
  `fanpage` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `donation_message` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `donation_link` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `donation_paypal` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `donation_address` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Additional information for Partner.';

--
-- Dumping data for table `partner_ext`
--

INSERT INTO `partner_ext` (`partner_id`, `fanpage`, `donation_message`, `donation_link`, `donation_paypal`, `donation_address`) VALUES
(46, 'https://www.facebook.com/AgentsofShield', 'Thank you very much', 'www.tada.com/donate', 'www.paypals.com/tada/donate', '123 Nguyen Hue, Q1');

-- --------------------------------------------------------

--
-- Table structure for table `player_avatar`
--

CREATE TABLE IF NOT EXISTS `player_avatar` (
`id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_url` varchar(100) COLLATE utf8_unicode_ci DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Avatar for play to view in their profile';

--
-- Dumping data for table `player_avatar`
--

INSERT INTO `player_avatar` (`id`, `name`, `avatar_url`) VALUES
(1, 'Boy Hero', 'http://www.heroforzero.be/assets/img/player/boy_hero@2x.png'),
(2, 'Girl Hero', 'http://www.heroforzero.be/assets/img/player/girl_hero@2x.png');

-- --------------------------------------------------------

--
-- Table structure for table `quest`
--

CREATE TABLE IF NOT EXISTS `quest` (
`id` int(11) NOT NULL,
  `name` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT '0',
  `longitude` float DEFAULT '0',
  `movie_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qrcode_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quest_owner_id` int(11) DEFAULT '0',
  `parent_quest_id` int(11) DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `points` int(11) DEFAULT '0',
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reward_id` int(11) DEFAULT NULL,
  `donate_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` int(11) NOT NULL DEFAULT '0' COMMENT 'Determine the state of this quest: pending, active'
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `quest`
--

INSERT INTO `quest` (`id`, `name`, `description`, `latitude`, `longitude`, `movie_url`, `qrcode_url`, `quest_owner_id`, `parent_quest_id`, `image_url`, `points`, `address`, `reward_id`, `donate_url`, `state`) VALUES
(1, 'Big Quest 0', '', 10.7172, 106.73, '', NULL, 0, NULL, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/1fdac2ef-62c7-4d5e-b7c7-7ddadaa37840.jpg', 200, '1SB1-1 Mỹ ViA', 1, NULL, 1),
(2, 'Unicef Fight For Zero', 'UNICEF strives for Zero. That means, zero exploited children, zero abused children, and zero trafficked children.', 10.7739, 106.703, 'https://dl.dropboxusercontent.com/u/3243296/videos/UNICEF.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/497c717d-cc6d-4dfc-b615-90f628d0cb4d.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/b0d330a1-9697-4e90-8294-0a521a0a8e49.jpg', 1000, '115 Nguyen Hue, District 1, Ho Chi Minh City, Vietnam', NULL, 'https://unicef.org.vn/donate/', 1),
(3, 'Koto | Know One Teach One', 'Is a vocational training organisation for street and disadvantaged youth in Vietnam. Accepts youth whose backgrounds are primarily orphans, street kids and the poor in both the city and rural communities.', 10.7772, 106.704, 'https://dl.dropboxusercontent.com/u/3243296/videos/KOTO.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/76def669-8511-427f-abf0-e05656f357bb.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/5a39b469-601a-4344-be67-0eca9dad7f42.jpg', 1000, '89 Hai BA  Trưng, Bến NghA', NULL, NULL, 0),
(4, 'Kristina Nobel Foundation', 'Christina Noble Children''s Foundation is an International Partnership of people dedicated to serving underprivileged children in Vietnam and Mongolia with the hope of helping each child maximize their life potential.', 10.7799, 106.686, 'https://dl.dropboxusercontent.com/u/3243296/videos/CNCF.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/d5c4c7ea-7249-4b89-861a-627057d4861e.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/dbdd9ed2-9482-426c-9191-0605279b7b79.jpg', 1000, '38 Tu Xuong Street \nDistrict 3 \nHO CHI MINH CITY \nVietnam', NULL, NULL, 0),
(5, 'Big Quest 1', '', 10.7172, 106.73, NULL, NULL, 0, NULL, '', 500, '1SB1-1 Mỹ ViA', 1, NULL, 0),
(6, 'American Red Cross in Vietnam', 'the American Red Cross has been working with the Vietnam Red Cross and other partners since early 2008 to improve access to and utilization of HIV information, treatment, care and support services.', 21.0222, 105.843, 'https://dl.dropboxusercontent.com/u/3243296/videos/American%20Red%20Cross_VN.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/5cc4d388-e8a0-4187-9178-f857cebcb0fd.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/b7a95302-5f27-4534-8f98-918c2901ffaa.png', 800, '15 Thiền Quang, HA  Nội, Vietnam', NULL, 'https://www.redcross.org/quickdonate/index.jsp', 1),
(7, 'Blue Dragon Children’s Home', 'Blue Dragon Children''s Foundation is an Australian grassroots charity that reaches out to kids in crisis throughout Vietnam.', 21.0259, 105.847, 'https://dl.dropboxusercontent.com/u/3243296/videos/blueDragonChildrensHome.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/a75d1db9-b5b0-4369-85fd-b85cdbaf819a.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/a09eeafc-5c08-447b-bc36-b763a016ff40.png', 500, '66 Nghĩa Dũng, PhA', NULL, NULL, 1),
(8, 'Care International in Vietnam', 'CARE has worked in Vietnam since 1989. As Vietnam becomes a middle-income country, we are concentrating our work on supporting rights and sustainable development among the most vulnerable groups in Vietnam, for example remote ethnic minorities, poor women and girls, and people vulnerable to climate change.', 21.0681, 105.823, 'https://dl.dropboxusercontent.com/u/3243296/videos/care_international.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/939389c7-3e0f-4071-aa30-9caa2742444d.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/d7c7942e-41fe-4d2d-ab7e-b8583e06c3ca.png', 500, '92 TA', NULL, NULL, 1),
(9, 'UNICEF Next Generation', 'a group of young entrepreneurs that advocate for UNICEF in the United-States, visited UNICEF projects in Ho Chi Minh City and Dong Thap. UNICEF Next Generation United States members are influential and passionate young adults (age 18-35) who are committed to supporting UNICEF''s mission to fulfill the rights of all children through the deliverance of educational and fundraising programmes', 10.7739, 106.703, 'https://dl.dropboxusercontent.com/u/3243296/videos/UNICEF%20next_genmp4.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/2a6b4946-2c8b-441f-93cd-2c61490d1f32.png', 1, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/49aa2afa-4068-42d8-9401-6113e4fa8065.jpg', 2000, '115 Nguyen Hue, District 1, Ho Chi Minh City, Vietnam', NULL, 'https://unicef.org.vn/donate/', 0),
(10, 'Big Quest 0', '', 10.7172, 106.73, '', NULL, 0, NULL, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/1fdac2ef-62c7-4d5e-b7c7-7ddadaa37840.jpg', 200, '1SB1-1 Mỹ ViA', 1, NULL, 1),
(11, 'Unicef Fight For Zero', 'UNICEF strives for Zero. That means, zero exploited children, zero abused children, and zero trafficked children.', 10.7739, 106.703, 'https://dl.dropboxusercontent.com/u/3243296/videos/UNICEF.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/497c717d-cc6d-4dfc-b615-90f628d0cb4d.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/b0d330a1-9697-4e90-8294-0a521a0a8e49.jpg', 1000, '115 Nguyen Hue, District 1, Ho Chi Minh City, Vietnam', NULL, 'https://unicef.org.vn/donate/', 1),
(12, 'Koto | Know One Teach One', 'Is a vocational training organisation for street and disadvantaged youth in Vietnam. Accepts youth whose backgrounds are primarily orphans, street kids and the poor in both the city and rural communities.', 10.7772, 106.704, 'https://dl.dropboxusercontent.com/u/3243296/videos/KOTO.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/76def669-8511-427f-abf0-e05656f357bb.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/5a39b469-601a-4344-be67-0eca9dad7f42.jpg', 1000, '89 Hai BA  Trưng, Bến NghA', NULL, NULL, 0),
(13, 'Kristina Nobel Foundation', 'Christina Noble Children''s Foundation is an International Partnership of people dedicated to serving underprivileged children in Vietnam and Mongolia with the hope of helping each child maximize their life potential.', 10.7799, 106.686, 'https://dl.dropboxusercontent.com/u/3243296/videos/CNCF.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/d5c4c7ea-7249-4b89-861a-627057d4861e.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/dbdd9ed2-9482-426c-9191-0605279b7b79.jpg', 1000, '38 Tu Xuong Street \nDistrict 3 \nHO CHI MINH CITY \nVietnam', NULL, NULL, 0),
(14, 'Big Quest 1', '', 10.7172, 106.73, NULL, NULL, 0, NULL, '', 500, '1SB1-1 Mỹ ViA', 1, NULL, 0),
(15, 'American Red Cross in Vietnam', 'the American Red Cross has been working with the Vietnam Red Cross and other partners since early 2008 to improve access to and utilization of HIV information, treatment, care and support services.', 21.0222, 105.843, 'https://dl.dropboxusercontent.com/u/3243296/videos/American%20Red%20Cross_VN.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/5cc4d388-e8a0-4187-9178-f857cebcb0fd.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/b7a95302-5f27-4534-8f98-918c2901ffaa.png', 800, '15 Thiền Quang, HA  Nội, Vietnam', NULL, 'https://www.redcross.org/quickdonate/index.jsp', 0),
(16, 'Blue Dragon Children’s Home', 'Blue Dragon Children''s Foundation is an Australian grassroots charity that reaches out to kids in crisis throughout Vietnam.', 21.0259, 105.847, 'https://dl.dropboxusercontent.com/u/3243296/videos/blueDragonChildrensHome.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/a75d1db9-b5b0-4369-85fd-b85cdbaf819a.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/a09eeafc-5c08-447b-bc36-b763a016ff40.png', 500, '66 Nghĩa Dũng, PhA', NULL, NULL, 0),
(17, 'Care International in Vietnam', 'CARE has worked in Vietnam since 1989. As Vietnam becomes a middle-income country, we are concentrating our work on supporting rights and sustainable development among the most vulnerable groups in Vietnam, for example remote ethnic minorities, poor women and girls, and people vulnerable to climate change.', 21.0681, 105.823, 'https://dl.dropboxusercontent.com/u/3243296/videos/care_international.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/939389c7-3e0f-4071-aa30-9caa2742444d.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/d7c7942e-41fe-4d2d-ab7e-b8583e06c3ca.png', 500, '92 TA', NULL, NULL, 0),
(18, 'UNICEF Next Generation', 'a group of young entrepreneurs that advocate for UNICEF in the United-States, visited UNICEF projects in Ho Chi Minh City and Dong Thap. UNICEF Next Generation United States members are influential and passionate young adults (age 18-35) who are committed to supporting UNICEF''s mission to fulfill the rights of all children through the deliverance of educational and fundraising programmes', 10.7739, 106.703, 'https://dl.dropboxusercontent.com/u/3243296/videos/UNICEF%20next_genmp4.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/2a6b4946-2c8b-441f-93cd-2c61490d1f32.png', 1, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/49aa2afa-4068-42d8-9401-6113e4fa8065.jpg', 2000, '115 Nguyen Hue, District 1, Ho Chi Minh City, Vietnam', NULL, 'https://unicef.org.vn/donate/', 0),
(19, 'Big Quest 0', '', 10.7172, 106.73, '', NULL, 0, NULL, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/1fdac2ef-62c7-4d5e-b7c7-7ddadaa37840.jpg', 200, '1SB1-1 Mỹ ViA', 1, NULL, 1),
(20, 'Unicef Fight For Zero', 'UNICEF strives for Zero. That means, zero exploited children, zero abused children, and zero trafficked children.', 10.7739, 106.703, 'https://dl.dropboxusercontent.com/u/3243296/videos/UNICEF.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/497c717d-cc6d-4dfc-b615-90f628d0cb4d.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/b0d330a1-9697-4e90-8294-0a521a0a8e49.jpg', 1000, '115 Nguyen Hue, District 1, Ho Chi Minh City, Vietnam', NULL, 'https://unicef.org.vn/donate/', 0),
(21, 'Koto | Know One Teach One', 'Is a vocational training organisation for street and disadvantaged youth in Vietnam. Accepts youth whose backgrounds are primarily orphans, street kids and the poor in both the city and rural communities.', 10.7772, 106.704, 'https://dl.dropboxusercontent.com/u/3243296/videos/KOTO.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/76def669-8511-427f-abf0-e05656f357bb.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/5a39b469-601a-4344-be67-0eca9dad7f42.jpg', 1000, '89 Hai BA  Trưng, Bến NghA', NULL, NULL, 0),
(22, 'Kristina Nobel Foundation', 'Christina Noble Children''s Foundation is an International Partnership of people dedicated to serving underprivileged children in Vietnam and Mongolia with the hope of helping each child maximize their life potential.', 10.7799, 106.686, 'https://dl.dropboxusercontent.com/u/3243296/videos/CNCF.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/d5c4c7ea-7249-4b89-861a-627057d4861e.png', 0, 1, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/dbdd9ed2-9482-426c-9191-0605279b7b79.jpg', 1000, '38 Tu Xuong Street \nDistrict 3 \nHO CHI MINH CITY \nVietnam', NULL, NULL, 0),
(23, 'Big Quest 1', '', 10.7172, 106.73, NULL, NULL, 0, NULL, '', 500, '1SB1-1 Mỹ ViA', 1, NULL, 0),
(24, 'American Red Cross in Vietnam', 'the American Red Cross has been working with the Vietnam Red Cross and other partners since early 2008 to improve access to and utilization of HIV information, treatment, care and support services.', 21.0222, 105.843, 'https://dl.dropboxusercontent.com/u/3243296/videos/American%20Red%20Cross_VN.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/5cc4d388-e8a0-4187-9178-f857cebcb0fd.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/b7a95302-5f27-4534-8f98-918c2901ffaa.png', 800, '15 Thiền Quang, HA  Nội, Vietnam', NULL, 'https://www.redcross.org/quickdonate/index.jsp', 0),
(25, 'Blue Dragon Children’s Home', 'Blue Dragon Children''s Foundation is an Australian grassroots charity that reaches out to kids in crisis throughout Vietnam.', 21.0259, 105.847, 'https://dl.dropboxusercontent.com/u/3243296/videos/blueDragonChildrensHome.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/a75d1db9-b5b0-4369-85fd-b85cdbaf819a.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/a09eeafc-5c08-447b-bc36-b763a016ff40.png', 500, '66 Nghĩa Dũng, PhA', NULL, NULL, 0),
(26, 'Care International in Vietnam', 'CARE has worked in Vietnam since 1989. As Vietnam becomes a middle-income country, we are concentrating our work on supporting rights and sustainable development among the most vulnerable groups in Vietnam, for example remote ethnic minorities, poor women and girls, and people vulnerable to climate change.', 21.0681, 105.823, 'https://dl.dropboxusercontent.com/u/3243296/videos/care_international.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/939389c7-3e0f-4071-aa30-9caa2742444d.png', 0, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/d7c7942e-41fe-4d2d-ab7e-b8583e06c3ca.png', 500, '92 TA', NULL, NULL, 1),
(27, 'UNICEF Next Generation', 'a group of young entrepreneurs that advocate for UNICEF in the United-States, visited UNICEF projects in Ho Chi Minh City and Dong Thap. UNICEF Next Generation United States members are influential and passionate young adults (age 18-35) who are committed to supporting UNICEF''s mission to fulfill the rights of all children through the deliverance of educational and fundraising programmes', 10.7739, 106.703, 'https://dl.dropboxusercontent.com/u/3243296/videos/UNICEF%20next_genmp4.mp4', 'https://s3-us-west-2.amazonaws.com/travelhero/qrcode/2a6b4946-2c8b-441f-93cd-2c61490d1f32.png', 1, 5, 'https://s3-ap-southeast-1.amazonaws.com/singtravelhero/images/questphoto/49aa2afa-4068-42d8-9401-6113e4fa8065.jpg', 2000, '115 Nguyen Hue, District 1, Ho Chi Minh City, Vietnam', NULL, 'https://unicef.org.vn/donate/', 0);

-- --------------------------------------------------------

--
-- Table structure for table `questcondition`
--

CREATE TABLE IF NOT EXISTS `questcondition` (
`Id` int(11) NOT NULL,
  `Type` int(11) DEFAULT NULL,
  `Value` int(11) DEFAULT '0',
  `VirtualQuestId` int(11) DEFAULT NULL,
  `ObjectId` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=753 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `questcondition`
--

INSERT INTO `questcondition` (`Id`, `Type`, `Value`, `VirtualQuestId`, `ObjectId`) VALUES
(693, 0, 20, 17, 6),
(717, 0, 10, 2, 1),
(718, 1, 0, 2, 26),
(724, 0, 20, 4, 8),
(725, 0, 20, 5, 8),
(726, 1, 0, 5, 1),
(727, 1, 0, 5, 1),
(728, 1, 0, 5, 1),
(733, 0, 20, 13, 5),
(734, 0, 20, 14, 5),
(735, 0, 20, 15, 5),
(736, 0, 40, 6, 8),
(737, 1, 0, 6, 1),
(738, 1, 0, 6, 1),
(739, 1, 0, 6, 1),
(740, 0, 20, 7, 7),
(741, 0, 20, 8, 7),
(742, 0, 20, 9, 7),
(743, 2, 0, 9, 21),
(744, 2, 0, 9, 19),
(745, 0, 20, 10, 6),
(746, 1, 0, 10, 17),
(747, 2, 0, 10, 12),
(748, 2, 0, 10, 22),
(749, 0, 20, 11, 6),
(750, 0, 20, 12, 6),
(751, 0, 10, 1, 9),
(752, 0, 20, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE IF NOT EXISTS `quiz` (
`Id` int(11) NOT NULL,
  `CategoryId` int(11) DEFAULT NULL,
  `PartnerId` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `Content` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BonusPoint` int(11) DEFAULT '1',
  `CorrectChoiceId` int(11) DEFAULT NULL,
  `SharingInfo` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LearnMoreURL` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ImageURL` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IsApproved` bit(1) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`Id`, `CategoryId`, `PartnerId`, `CreatedDate`, `Content`, `BonusPoint`, `CorrectChoiceId`, `SharingInfo`, `LearnMoreURL`, `ImageURL`, `IsApproved`) VALUES
(69, 6, 46, '2014-08-28 09:01:02', 'What should you do in Vietnam if you see a child in situation where he/she looks like he/she needs help from an aggressor?', 1, 176, 'Help hotlines in Vietnam  are 113 or 18001567.', '', '', b'1'),
(70, 6, 46, '2014-07-07 05:16:25', 'Who is responsible for of the protection of children?', 1, 181, 'The family carries the main responsibility for its children. However, governmental institutions like schools or hospitals should pay attention to children''s well-being. Furthermore the society should protect its youngest members.  ', '', NULL, b'1'),
(71, 6, 46, '2014-07-07 05:14:30', 'Which group of children is most vulnerable to abuse?', 1, 185, '', 'http://www.unicef.org/vietnam/protection.html', NULL, b'1'),
(72, 6, 46, '2014-08-28 08:37:44', 'If children are being abused to whom should they report?', 1, 187, '', '', '', b'1'),
(81, 6, 46, '2015-03-12 03:30:36', 'According to the Vietnamese Law on Protection, Care and Education of children , what age is considered a child?', 1, 224, '', 'http://www.unicef.org/vietnam/protection.html', '', b'1'),
(82, 6, 46, '2014-07-07 05:08:56', 'When you see something wrong happening in a shelter, to whom should you report it?', 1, 229, '', '', '', b'1'),
(84, 7, 46, '2014-07-03 04:17:35', 'How many different types of schools does the Vietnamese school system consist of? ', 1, 236, 'The Vietnamese school system consists of four different types of school: Preschool, Primary School, Secondary School, High School. ', 'http://vietnam.angloinfo.com/family/schooling-education/school-system/', '', b'1'),
(85, 1, 46, '2014-07-07 05:06:32', 'Which group of children can be found in Buddhist Pagoda Shelters? ', 1, 241, 'Some Buddhist communities in Vietnam offer orphanages, schools or other kinds of shelter to underprivileged children. ', '', '', b'1'),
(88, 6, 46, '2014-07-10 06:23:39', 'Children found at pagodas fall into what category?', 1, 253, '', '', '', b'1'),
(91, 5, 46, '2014-07-10 06:25:08', 'What’s the average life expectancy in Vietnam?', 1, 263, '', '', '', b'1'),
(92, 5, 46, '2014-10-27 05:31:46', 'In Vietnam, Malaria is still a serious problem. What helps prevent this disease?\n', 1, 268, 'Combating malaria is one of the country''s Millenium Development Goals, set by the United Nations.', 'http://www.unicef.org/vietnam/overview_20392.html', '', b'1'),
(93, 5, 46, '2014-10-27 05:31:23', 'How many people in Vietnam die each year from AIDS?\n', 1, 271, 'Around 100,000 Vietnamese are infected with HIV annually. In around 15,000 cases HIV becomes AIDS, and around 10,000 people die each year.', 'http://www.unaids.org.vn/index.php?option=com_content&view=category&layout=blog&id=13&Itemid=27&lang=en', '', b'1'),
(94, 5, 46, '2014-07-07 05:05:18', 'Which of these Institution does NOT deal with health care?\n', 1, 277, 'The North Atlantic Treaty Organization (NATO) is a military alliance which operates mostly in Euorpe and North America. ', 'http://www.google.com.vn/url?sa=t&rct=j&q=&esrc=s&source=web&cd=17&cad=rja&uact=8&ved=0CFkQFjAQ&url=http%3A%2F%2Fwww.nato.int%2Fnato-welcome%2F&ei=CBGYU--9H5Dh8AWRmoKADg&usg=AFQjCNFueu0iKzsuTxyccNxPfg', '', b'1'),
(95, 5, 46, '2014-07-15 05:02:25', 'What are the main causes of death for Vietnamese children under 5 years?\n', 1, 280, '', '', '', b'1'),
(96, 1, 46, '2014-07-15 05:00:24', 'What is the annual birth rate per 1.000 people in Vietnam?\n', 1, 284, '', '', '', b'1'),
(97, 5, 46, '2014-08-28 08:07:35', 'What is the main reason Vietnamese do not go to a hospital when ill?\n', 1, 289, '', '', '', b'1'),
(98, 5, 46, '2014-09-16 03:43:48', 'What is the main issue with Vietnamese medications?\n', 1, 293, '', '', '', b'1'),
(99, 5, 46, '2014-07-15 04:56:30', 'Why do some doctors prefer to work in private hospitals rather than public hospitals?', 1, 295, '', '', '', b'1'),
(100, 5, 46, '2014-07-15 04:55:37', 'How many public hospitals are located in Vietnam’s capital Hanoi?\n', 1, 300, '', '', '', b'1'),
(101, 5, 46, '2014-07-15 04:55:06', 'What does the Vietnamese health system look like?\n', 1, 304, '', '', '', b'1'),
(102, 5, 46, '2014-10-27 05:28:07', 'Which of these areas in Vietnam are supposed to be Malaria free?\n', 1, 309, '', '', '', b'1'),
(103, 5, 46, '2014-08-28 08:54:56', 'How can you protect your skin from intense sun exposure?', 1, 310, '', '', '', b'1'),
(104, 1, 46, '2014-07-15 04:52:26', 'What can you do to avoid traffic accidents?', 1, 317, '', '', '', b'1'),
(105, 5, 46, '2015-03-12 04:42:17', 'Which of these vaccines is not obligatory for travelers to Vietnam?', 1, 320, '', '', '', b'1'),
(106, 5, 46, '2014-07-15 04:51:15', 'What are the health problems most travelers have to deal with in Vietnam?', 1, 325, '', '', '', b'1'),
(107, 5, 46, '2014-07-15 04:50:40', 'How can you prevent bug bites?', 1, 326, '', '', '', b'1'),
(108, 5, 46, '2014-07-15 04:50:01', 'How can gastrointestinal illness be avoided while traveling?', 1, 332, '', '', '', b'1'),
(109, 5, 46, '2014-07-15 04:46:45', 'What does a good travel health kit NOT include?', 1, 336, '', '', '', b'1'),
(110, 5, 46, '2014-07-15 04:43:07', 'What negative affects can malnutrition have?', 1, 341, '', '', '', b'1'),
(111, 1, 46, '2014-07-15 04:34:27', 'What is the median age of Vietnamese?', 1, 342, '', '', '', b'1'),
(112, 5, 46, '2014-07-15 04:33:56', 'What is the fertility rate per woman in VN?\n', 1, 346, '', '', '', b'1'),
(113, 5, 46, '2014-07-15 04:29:36', 'What percentage of Vietnamese DO NOT have access to clean drinking water?', 1, 350, '', '', '', b'1'),
(114, 5, 46, '2014-07-15 04:28:08', 'What percentage of Vietnamese DO NOT have access to improved sanitation facilities?', 1, 357, '', '', '', b'1'),
(115, 5, 46, '2014-07-15 04:25:42', 'Which hospital is one of two public children''s hospitals in HCMC?\n', 1, 358, '', '', '', b'1'),
(116, 5, 46, '2014-07-15 04:24:51', 'What is correct about the Ho Chi Minh Ung Buou Cancer Hospital?', 1, 364, '', '', '', b'1'),
(117, 5, 46, '2014-07-15 04:20:44', 'Where is the Ho Chi Minh Ung Buou Cancer Hospital?', 1, 366, '', '', '', b'1'),
(119, 6, 46, '2014-07-15 04:20:02', 'When you see something wrong happening in a shelter, to whom should you report?', 1, 377, '', '', '', b'1'),
(121, 6, 46, '2014-09-16 03:18:37', 'If they are being abused, what should children do?\n', 1, 385, '', '', '', b'1'),
(122, 6, 46, '2014-07-15 03:46:25', 'What could reduce the youth crime rate in Vietnam?', 1, 389, '', '', '', b'1'),
(123, 1, 46, '2014-09-16 03:20:55', 'What legal system prevails in VN?\n', 1, 390, '', '', '', b'1'),
(124, 1, 46, '2014-07-15 03:35:04', 'What is the legal voting age in Vietnam?', 1, 395, '', '', '', b'1'),
(125, 1, 46, '2014-07-15 03:33:36', 'How often are Vietnamese government elections held?\n', 1, 400, '', '', '', b'1'),
(126, 1, 46, '2014-07-15 03:29:59', 'What are the most common crimes tourists have to deal with while traveling in VN?\n', 1, 402, '', '', '', b'1'),
(127, 6, 46, '2014-07-15 03:29:18', 'What is the name of the main police and security force in VN?\n', 1, 407, '', '', '', b'1'),
(128, 1, 46, '2014-07-15 03:28:14', 'What color are the VN police uniforms?\n', 1, 413, '', '', '', b'1'),
(129, 1, 46, '2014-07-15 03:27:08', 'How many traffic accident related deaths does VN count per year?', 1, 417, '', '', '', b'1'),
(130, 6, 46, '2014-09-16 03:23:24', 'Where are the main destinations of trafficked Vietnamese?', 1, 420, '', '', '', b'1'),
(131, 6, 46, '2014-07-15 03:24:20', 'What are Vietnamese women, children and newborn babies trafficked for?\n', 1, 425, '', '', '', b'1'),
(132, 6, 46, '2014-07-15 03:11:22', 'What percent of Vietnamese trafficking victims are children? (according to UK’s National Referral Mechanism record)', 1, 428, '', '', '', b'1'),
(133, 6, 46, '2014-07-15 03:10:48', 'Why are girls easily trafficked?', 1, 433, '', '', '', b'1'),
(134, 6, 46, '2014-09-16 03:22:36', 'How do sex traffickers recruit victims?', 1, 437, '', '', '', b'1'),
(135, 6, 46, '2014-07-15 03:06:46', 'From what age does Vietnamese law prohibit the employment of children?\n', 1, 438, '', '', '', b'1'),
(136, 6, 46, '2014-08-28 09:00:27', 'What is the typical job of a child laborer?', 1, 445, 'The International Labour Organisation (ILO) defines child labour as "work that deprives children of their childhood, their potential and their dignity, and that is harmful to physical and mental development." ', 'http://www.ilo.org/ipec/facts/lang--en/index.htm', '', b'1'),
(137, 6, 46, '2014-07-15 03:06:22', 'What percent of child laborers in manufacturing factories are under the age of 15?\n', 1, 449, '', '', '', b'1'),
(138, 6, 46, '2014-09-16 03:21:14', 'How is the working environment in manufacturing factories?\n', 1, 453, '', '', '', b'1'),
(139, 6, 46, '2014-07-07 04:54:33', 'According to a Human Rights Watch Report on Street Children in Vietnam published in 2006, how many street children were living in Vietnam?', 1, 455, 'In Vietnam street children are called "bui doi", which means "Children of the Dust". In 2006, Human Rights Watch published a report on the situation of "bui doi" throughout the whole country. ', 'http://www.hrw.org/reports/2006/vietnam1106/2.htm', '', b'1'),
(140, 6, 46, '2014-07-15 03:04:55', 'What is the main cause of street children in Vietnam?', 1, 461, '', '', '', b'1'),
(141, 1, 46, '2014-07-07 04:58:21', 'How many SOS Children’s Villages are there  in Vietnam?\n', 1, 463, 'In 2014, there are thirteen SOS Children''s Villages, ten SOS Youth Facilities, eleven SOS Hermann Gmeiner Schools, twelve SOS Kindergartens, two SOS Vocational Training Centres, five SOS Social Centres and one SOS Medical Centre. ', 'http://www.sos-childrensvillages.org/where-we-help/asia/vietnam', '', b'1'),
(142, 6, 46, '2014-09-16 03:47:01', 'What is the function of SOS children’s villages in Vietnam?\n', 1, 466, '', '', '', b'1'),
(143, 1, 46, '2014-07-07 04:59:37', 'When was SOS Children’s Villages Vietnam established?\n', 1, 470, 'In Vietnam, SOS Children''s Villages started in 1967. However,  nine years of hard work they had to stop their services. In 1987 they were finally able to continue their activities.', 'http://www.sos-childrensvillages.org/where-we-help/asia/vietnam', '', b'1'),
(144, 6, 46, '2014-11-20 09:02:21', 'How many children does a "mother” take care of in SOS village?\n', 1, 475, 'The SOS mother builds a close relationship with every child entrusted to her, and provides security, love and  stability for each child.', 'http://www.sos-childrensvillages.org/getmedia/57e18754-f07c-45e6-b9a3-176359847fbc/SOS-CV-MissionStatement-EN.pdf?ext=.pdf', '', b'1'),
(145, 1, 46, '2014-07-07 05:01:14', 'How many SOS Children''s Villages are located in Vietnam (2014)?', 1, 479, 'SOS Children''s Villages help children who are orphaned, neglected or abandoned. Their goal is to integrate children in need into a family. In Vietnam SOS Children''s  Villages began in 1967. ', 'http://www.sos-childrensvillages.org/where-we-help/asia/vietnam', '', b'1'),
(146, 7, 46, '2014-08-25 03:23:00', 'What are the main education goals in Vietnam?\n', 1, 482, '', '', '', b'1'),
(147, 7, 46, '2014-07-13 12:58:11', 'How old are Vietnamese children when they enter primary school?', 1, 486, '', '', '', b'1'),
(148, 7, 46, '2014-07-15 02:43:42', 'Which is NOT a school subject in Vietnam?\n', 1, 492, '', '', '', b'1'),
(149, 7, 46, '2014-07-15 02:44:17', 'Which teaching method is practiced in VN universities?\n', 1, 496, '', '', '', b'1'),
(150, 7, 46, '2014-07-15 02:45:50', 'What are the three most popular foreign countries for Vietnamese to study abroad?\n', 1, 498, '', '', '', b'1'),
(151, 7, 46, '2014-09-16 03:26:34', 'What are the main reasons Vietnamese drop out of school?\n', 1, 505, '', '', '', b'1'),
(152, 7, 46, '2014-07-15 02:47:53', 'What is the most popular foreign language taught in Vietnamese schools?\n', 1, 508, '', '', '', b'1'),
(153, 7, 46, '2014-07-15 02:49:32', 'What is the illiteracy rate among Vietnamese 15 years and older?', 1, 510, '', '', '', b'1'),
(154, 1, 46, '2014-09-16 03:50:39', 'What form of state prevails in VN?\n', 1, 517, '', '', '', b'1'),
(155, 1, 46, '2014-07-15 02:50:28', 'What is the predominant religion in Vietnam?\n', 1, 521, '', '', '', b'1'),
(156, 5, 46, '2014-07-15 02:51:10', 'What’s the average age at first birth of Vietnamese women?\n', 1, 522, '', '', '', b'1'),
(157, 7, 46, '2014-08-28 08:30:10', 'What are the Vietnamese government’s education expenditures?\n', 1, 527, '', '', '', b'1'),
(158, 6, 46, '2014-08-28 08:30:27', 'How many Vietnamese children (5-14 years) are working?\n', 1, 531, '', '', '', b'1'),
(159, 7, 46, '2014-07-15 02:54:02', 'What is the test that enables Vietnamese students to attend Colleges and Universities?\n', 1, 535, '', '', '', b'1'),
(160, 7, 46, '2014-07-15 02:54:34', 'What is the estimated ratio between government and private kindergartens?', 1, 538, '', '', '', b'1'),
(161, 7, 46, '2014-07-13 12:41:12', 'What  school levels are compulsory in VN?\n', 1, 542, '', '', '', b'1'),
(162, 7, 46, '2014-08-28 08:31:46', 'What is NOT a benefit of school uniforms?\n', 1, 548, '', '', '', b'1'),
(163, 7, 46, '2014-07-11 09:52:23', 'How many years is formal Vietnamese education?\n', 1, 552, '', '', '', b'1'),
(164, 7, 46, '2014-07-10 06:21:00', 'How many subjects are on the National High Graduation Examination?', 1, 556, '', '', '', b'1'),
(165, 7, 46, '2014-08-28 07:58:18', 'What does the Vietnamese education system lack?\n', 1, 559, '', '', '', b'1'),
(166, 7, 46, '2014-09-16 03:27:32', 'How are Vietnamese students expected to act in class?', 1, 562, '', '', '', b'1'),
(167, 7, 46, '2014-07-10 06:15:02', 'What is the average monthly salary of local Vietnamese public teachers?\n', 1, 566, '', '', '', b'1'),
(168, 7, 46, '2014-09-16 03:28:29', 'What can a teacher do to earn more money to make his/her living besides a monthly salary?\n', 1, 573, '', '', '', b'1'),
(169, 7, 46, '2014-08-28 08:32:12', 'How many basic groups can the students choose to take for their university entrance exams?', 1, 575, '', '', '', b'1'),
(170, 7, 46, '2014-07-10 05:47:12', 'Which fixed subjects are included in the National High Graduation Examination?\n', 1, 578, '', '', '', b'1'),
(171, 7, 46, '2014-08-28 08:32:46', 'When is the National High Graduation Examination held?\n', 1, 583, '', '', '', b'1'),
(172, 7, 46, '2014-07-10 05:45:31', 'When is Vietnamese Teacher’s Day?\n', 1, 588, '', '', '', b'1'),
(173, 7, 46, '2014-09-16 03:51:25', 'What do students usually do on Teacher’s day?\n', 1, 593, '', '', '', b'1'),
(174, 7, 46, '2014-07-10 05:33:39', 'According to the World Bank, in 2010 what was the gross enrollment rate at upper-secondary schools in Vietnam?', 1, 594, '', '', '', b'1'),
(175, 7, 46, '2014-07-10 05:26:46', 'When is the Vietnamese University entrance examination held?\n', 1, 600, '', '', '', b'1'),
(177, 7, 46, '2014-08-28 08:33:38', 'If they want to enter the University of Technology in HCM, what subjects must students take exams in?', 1, 606, '', '', '', b'1'),
(178, 7, 46, '2014-07-10 05:10:40', 'What subjects does group A consist of?', 1, 610, '', '', '', b'1'),
(179, 5, 46, '2014-08-28 08:34:00', 'What are the main health problems Vietnamese children deal with today?', 1, 617, '', '', '', b'1'),
(180, 7, 46, '2014-07-10 05:08:55', 'When did Vietnam’s Ministry of Education and Training start to use the multiple choice exam format for the entrance exam for several subject', 1, 618, '', '', '', b'1'),
(181, 7, 46, '2014-07-10 05:07:54', 'How high are the average annual university fees in VN?\n', 1, 624, '', '', '', b'1'),
(182, 8, 46, '2014-08-28 08:33:00', 'How many children under the age of 5 suffer from malnutrition?', 1, 628, '', '', '', b'1'),
(183, 7, 46, '2014-09-16 03:31:19', 'What is the definition of literacy?', 1, 630, '', '', '', b'1'),
(184, 7, 46, '2014-07-10 05:04:44', 'What is Vietnam’s average pupil:teacher ratio?\n', 1, 636, '', '', '', b'1'),
(185, 8, 46, '2014-07-10 05:02:24', 'What are possible symptoms of chronic malnutrition?', 1, 641, '', '', '', b'1'),
(186, 8, 46, '2014-07-13 13:20:49', 'Which areas of VN suffer the most from malnutrition?', 1, 642, '', '', '', b'1'),
(187, 7, 46, '2014-09-16 03:33:38', 'What are the main educational barriers for VN children?', 1, 649, '', '', '', b'1'),
(188, 8, 46, '2014-07-10 04:59:42', 'How can malnutrition be avoided?', 1, 653, '', '', '', b'1'),
(189, 7, 46, '2014-08-28 08:36:05', 'What is a traditional Vietnamese value in education?', 1, 655, '', '', '', b'1'),
(190, 8, 46, '2014-07-10 04:56:52', 'Which food intolerance do most Asians and Africans suffer from?', 1, 659, '', '', '', b'1'),
(191, 7, 46, '2014-07-10 04:55:06', 'Which English skills do Vietnamese schools focus on?\n', 1, 662, '', '', '', b'1'),
(192, 8, 46, '2014-07-10 04:54:33', 'What parts of the world have the highest malnutrition rates?', 1, 668, '', '', '', b'1'),
(193, 7, 46, '2014-07-10 04:54:07', 'What percent of children in rural areas do not continue education after they reach age of 14?', 1, 671, '', '', '', b'1'),
(194, 7, 46, '2014-08-28 08:36:31', 'When do students take vacation?', 1, 674, '', '', '', b'1'),
(196, 1, 46, '2014-07-10 04:51:55', 'Where do Vietnamese civil weddings take place?', 1, 685, '', '', '', b'1'),
(197, 1, 46, '2015-03-12 04:03:35', 'What’s the minimum age a vietnamese man can get married?', 1, 689, 'A Vietnamese female can legally get married at 18. A Vietnamese male must be 20 or older to legally get married. ', '', '', b'1'),
(198, 1, 46, '2014-07-10 04:48:05', 'How high is the NEW international poverty line determined by the World Bank?', 1, 692, '', '', '', b'1'),
(199, 1, 46, '2014-07-10 04:46:05', 'Which one is NOT a UN Millennium Development Goal?', 1, 697, '', '', '', b'1'),
(200, 1, 46, '2014-07-10 04:47:05', 'What does the Human Development Index measure?', 1, 698, '', '', '', b'1'),
(201, 1, 46, '2014-07-10 04:42:22', 'What is VN’s biggest city?', 1, 703, '', '', '', b'1'),
(202, 1, 46, '2014-07-10 04:41:12', 'What are VN’s main export goods?', 1, 709, '', '', '', b'1'),
(204, 1, 46, '2014-09-16 03:37:45', 'What do children usually do during the Tet holiday?', 1, 717, '', '', '', b'1'),
(205, 1, 46, '2014-07-10 04:35:57', 'What traditional values are children taught in their families?', 1, 721, '', '', '', b'1'),
(206, 7, 46, '2014-08-28 09:01:27', 'Why do Vietnamese parents encourage their children study and excel in their education?', 1, 725, '', '', '', b'1'),
(208, 1, 46, '2014-07-10 04:33:10', 'What are children expected to do when their parents grow old?', 1, 733, '', '', '', b'1'),
(209, 1, 46, '2014-07-10 04:32:11', 'What is VN’s largest city?', 1, 735, '', '', '', b'1'),
(210, 1, 46, '2014-07-10 04:37:28', 'Which country has a population greater than 1 billion? ', 1, 740, '', '', '', b'1'),
(212, 1, 46, '2014-08-28 08:52:16', 'What is the Tet holiday?', 1, 746, '', '', '', b'1'),
(213, 1, 46, '2014-08-28 08:53:14', 'What do children usually do during the Tet holiday?', 1, 750, '', '', '', b'1'),
(214, 1, 46, '2014-07-07 05:29:28', 'What are traditional values children are taught in their families?', 1, 757, '', '', '', b'1'),
(215, 1, 46, '2014-09-16 03:41:44', 'What are parents allowed to do when children are disobedient?', 1, 758, '', '', '', b'1'),
(217, 1, 46, '2014-09-16 03:35:47', ' What is the traditional role of the wife in the family?', 1, 769, '', '', '', b'1'),
(218, 1, 46, '2014-08-28 09:02:14', 'Which is a traditional Vietnamese game?', 1, 770, '', '', '', b'1'),
(219, 9, 46, '2015-03-12 03:57:28', 'What is the mission of the HEROforZERO app?', 1, 775, 'HEROforZERO aims to help reduce the number of children dying preventable deaths to ZERO by educating, connecting and activating its users. ', 'http://www.unicef.org/vietnam/', '', b'1'),
(221, 9, 46, '2014-10-29 03:42:24', 'What is the total number of virtual children under 5 that must be saved in the HEROforZERO app?', 1, 784, 'It is estimated that in Vietnam there are 7,000,000 under 5 years old in need of health care, nutritious food, protection, and education. ', '', '', b'1'),
(223, 9, 46, '2015-03-12 04:08:21', 'In the HEROforZERO app, how do you earn points? ', 1, 793, 'There are still many more ways to earn points. Some of these include: sign up for a newsletter, like a facebook page and donate your time. ', '', '', b'1'),
(224, 9, 46, '2015-03-12 04:04:29', 'In the HEROforZERO app what happens after we reach ZERO virtual children in need?', 1, 795, 'The mission of the game is to work together as a global group of people and organizations to help children. ', '', '', b'1'),
(225, 9, 46, '2014-10-29 04:26:08', 'During a quiz in the HEROforZERO app what does the image below mean?', 1, 798, 'During the quiz game if you have lost a heart you can recover it by hitting the heart icon in the middle. This will help you to stay alive longer.', '', 'http://heroforzero.be/assets/uploads/1bab4b074975dc2b23788620610c8e63.png', b'1'),
(226, 9, 46, '2014-10-29 04:26:25', 'During a quiz in HEROforZERO, what does the image below mean?', 1, 803, 'During the quiz game if you need more time you can slow down the enemy by hitting the stop watch icon in the middle. This will help you to stay alive longer.', '', 'http://heroforzero.be/assets/uploads/78910cc38354c492c52329c09b420d10.png', b'1'),
(227, 9, 46, '2014-10-29 04:23:40', 'During a quiz in the HEROforZERO app, what does the image below mean?', 1, 807, 'During the quiz game if you don''t know the answer to a question you can skip it by hitting this icon and you won''t be penalized.', '', 'http://heroforzero.be/assets/uploads/49c5c38135d580727e85dbdd1871eb44.png', b'1'),
(228, 9, 46, '2014-10-29 03:45:15', 'In the HEROforZERO app, how do you access the user''s profile?', 1, 810, 'The user''s profile is located on the left side with the Facebook photo of the user and a blue arrow. If the user taps the photo, she will be taken to a list of other functions she can perform such as ranking, awards and settings.', '', '', b'1'),
(229, 5, 46, '2015-03-12 04:29:55', 'How many people are living with HIV/AIDS in Vietnam? (2013)', 1, 815, 'Number of people living with HIV: 250,000 [230,000 - 280,000]. Adults aged 15 to 49 prevalence rate: 0.4% [0.4% - 0.4%]', 'http://www.unaids.org/en/regionscountries/countries/vietnam', '', b'1'),
(230, 5, 46, '2014-10-27 05:40:02', 'Which is not a way to transmit HIV?', 1, 821, '', 'UNAIDS.org', '', b'1'),
(231, 5, 46, '2014-10-27 05:40:16', 'How many people worldwide are currently living with HIV/ADS?', 1, 823, '', 'UNAIDS.org', '', b'1'),
(232, 5, 46, '2014-10-27 05:32:56', 'What are ways to prevent HIV transmission?', 1, 829, '', 'http://www.cdc.gov/hiv/basics/index.html', '', b'1'),
(233, 5, 46, '2014-10-27 05:33:39', 'What percent risk is there that a pregnant woman will pass HIV to her baby? ', 1, 831, '', 'http://www.cdc.gov/hiv/basics/index.html', '', b'1'),
(234, 5, 46, '2015-03-12 04:25:12', 'How can a pregnant woman prevent passing HIV to her baby?\n', 1, 837, '', 'http://aidsinfo.nih.gov/education-materials/fact-sheets/20/50/preventing-mother-to-child-transmission-of-hiv', '', b'1'),
(235, 5, 46, '2015-03-12 04:22:46', 'If infected pregnant women receive the appropriate treatment what chance is there that they will pass HIV to their babies?', 1, 839, 'Without any treatment, transmission rates from mother to child range from 15-45%. This rate can be reduced to levels below 5% with treatment', 'http://www.who.int/hiv/topics/mtct/en/', '', b'1'),
(236, 5, 46, '2014-10-27 05:40:59', 'What does HIV stand for?', 1, 843, '', 'http://www.cdc.gov/hiv/basics/index.html', '', b'1'),
(237, 5, 46, '2014-10-27 05:34:08', 'What does AIDS stand for?', 1, 849, '', 'http://www.cdc.gov/hiv/basics/index.html', '', b'1'),
(238, 8, 46, '2014-07-15 05:19:24', 'What percent of children were severely to moderately underweight in Vietnam in 2008-2012?', 1, 852, '', 'http://www.unicef.org/vietnam/overview.html', '', b'1'),
(240, 14, 46, '2014-07-15 10:33:07', 'What percent of rice crops in the Mekong Delta could be lost due to a 30 centimeter rise in sea level?', 1, 861, 'The	 Asian	Development	Bank	(ADB)	estimates	that	the	number	of	people	living	in	cities	in	Asia	at	risk	 of coastal	flooding	will	 increase	from	300	to	410	million	by	2025.	A	30	centimetre	sea	level	rise 	in	Vietnam’s	\nMekong	Delta,	a	global	rice	producing	area,	could	see	the	loss	of	around	11%	of	crop	production	and	 subsequent	rises	in	food	prices.	\n', 'http://plan-international.org/files/Asia/publications/act-to-adapt', '', b'1'),
(241, 7, 46, '2014-07-15 07:16:54', 'Upon the request of the Vietnamese Ministry of Education, how many teachers were trained in climate change education material?', 1, 862, 'These include teacher manuals and student books, cartoons and animation films,	and	games. The materials have been widely adopted by governments and other	organisations.	For	example, upon request of the Vietnamese Ministry of Education, over 380 teachers from almost 250 schools were trained on the climate change education material using explorative teaching methods.	\n', 'http://plan-international.org/files/Asia/publications/act-to-adapt', '', b'1'),
(242, 14, 46, '2014-07-15 07:25:17', 'In which Vietnamese province will “Climate Change Communicators”-- a group of trained children-- train other children in climate change?', 1, 866, 'In Quang Tri province in Vietnam, ‘Climate Change Communicators’ – a group	 of trained	children – will	lead and train other children on climate change adaptation and mitigation through games and films and other communication activities.', 'http://plan-international.org/files/Asia/publications/act-to-adapt', '', b'1'),
(243, 14, 46, '2014-08-28 08:03:51', 'What type of child-centered adaptation projects received seed grants?\n', 1, 873, '', '', '', b'1'),
(244, 1, 46, '2014-09-16 03:10:40', 'What is the website: thehexanh.net?', 1, 875, 'http://www.thehexanh.net/index.asp?lang=1', 'http://plan-international.org/files/Asia/publications/act-to-adapt', '', b'1'),
(245, 8, 46, '2014-07-15 07:19:32', 'What percentage of Vietnamese children suffer from stunting (2008-2012)?', 1, 878, '', 'http://www.unicef.org/vietnam/overview.html', '', b'1'),
(246, 5, 46, '2014-10-27 05:34:35', 'What percentage of children in Vietnam have had a polio vaccine?', 1, 885, '', 'http://www.unicef.org/vietnam/overview.html', '', b'1'),
(247, 5, 46, '2014-10-27 05:41:11', 'What is the prevalence of HIV among 15-24 year olds in Vietnam?', 1, 886, '', 'http://www.unicef.org/vietnam/overview.html', '', b'1'),
(248, 7, 46, '2014-07-15 07:14:21', 'What is the literacy rate of youth (15-24 year olds) in Vietnam?', 1, 893, '', 'http://www.unicef.org/vietnam/overview.html', '', b'1'),
(249, 5, 46, '2014-10-27 05:35:03', 'What are ways other than a mosquito bite to catch malaria?', 1, 897, 'Because the parasites that cause malaria affect red blood cells, people can also catch malaria from exposures to infected blood, including:\n\nFrom mother to unborn child\nThrough blood transfusions\nBy sharing needles used to inject drugs', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/causes/con-20013734', '', b'1'),
(250, 5, 46, '2015-03-12 04:39:40', 'Malaria is a parasite that lives in your........?', 1, 899, 'The parasites travel to your liver — where they can lie dormant for as long as a year.', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/causes/con-20013734', '', b'1'),
(251, 5, 46, '2015-03-12 04:34:36', 'For which of these diseases is there not a vaccine?', 1, 902, 'Scientists around the world are trying to develop a safe and effective vaccine for malaria. As of yet, however, there is still no malaria vaccine approved for human use.', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/prevention/con-20013734', '', b'1'),
(252, 5, 46, '2015-03-12 04:34:18', 'How can you prevent the spread of malaria?', 1, 908, 'In countries where malaria is common, prevention also involves keeping mosquitoes away from humans. Strategies include:\nSpraying your home. Treating your home''s walls with insecticide can help kill adult mosquitoes that come inside.\nSleeping under a net. Bed nets, particularly those treated with insecticide, are especially recommended for pregnant women and young children.\nCovering your skin. During active mosquito times, usually from dusk to dawn, wear pants and long-sleeved shirts.\nSpraying clothing and skin. Sprays containing permethrin are safe to use on clothing, while sprays containing DEET can be used on skin.', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/prevention/con-20013734', '', b'1'),
(253, 5, 46, '2015-03-12 04:33:28', 'What is a growing problem in malaria treatment?', 1, 910, 'There is a constant struggle between evolving drug-resistant parasites and the search for new drug formulations. ', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/treatment/con-20013734', '', b'1'),
(254, 5, 46, '2015-03-12 04:32:41', 'What characteristics determine the treatment of malaria?', 1, 917, 'The types of drugs and the length of treatment will vary, depending on: type of malaria parasite, \nseverity of your symptoms, age, pregnant', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/treatment/con-20013734', '', b'1'),
(255, 5, 46, '2014-10-27 05:43:02', 'Malaria can be fatal. What complications usually cause death?', 1, 921, 'In most cases, malaria deaths are related to one or more of these serious complications:\n\nCerebral malaria. If parasite-filled blood cells block small blood vessels to your brain (cerebral malaria), swelling of your brain or brain damage may occur. Cerebral malaria may cause coma.\nBreathing problems. Accumulated fluid in your lungs (pulmonary edema) can make it difficult to breathe.\nOrgan failure. Malaria can cause your kidneys or liver to fail, or your spleen to rupture. Any of these conditions can be life-threatening.\nSevere anemia. Malaria damages red blood cells, which can result in severe anemia.\nLow blood sugar. Severe forms of malaria itself can cause low blood sugar, as can quinine — one of the most common medications used to combat malaria. Very low blood sugar can result in coma or death.', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/complications/con-20013734', '', b'1'),
(256, 5, 46, '2014-10-27 05:42:46', 'Which statement about polio is true?', 1, 923, 'Although polio can cause paralysis and death, the vast majority of people who are infected with the poliovirus don''t become sick and are never aware they''ve been infected with polio.', 'http://www.mayoclinic.org/diseases-conditions/polio/basics/symptoms/con-20030957', '', b'1'),
(257, 5, 46, '2015-03-12 04:17:34', 'Which isn''t a symptom of polio?', 1, 929, 'Post-polio syndrome is a cluster of disabling signs and symptoms that affect some people several years — an average of 35 years — after they had polio. Common signs and symptoms include:\n\nProgressive muscle or joint weakness and pain\nGeneral fatigue and exhaustion after minimal activity\nMuscle atrophy\nBreathing or swallowing problems\nSleep-related breathing disorders, such as sleep apnea\nDecreased tolerance of cold temperatures\nCognitive problems, such as concentration and memory difficulties\nDepression or mood swings', 'http://www.mayoclinic.org/diseases-conditions/polio/basics/symptoms/con-20030957', '', b'1'),
(258, 5, 46, '2015-03-12 04:19:04', 'How long can malaria remain dormant (without symptoms) in the human body?', 1, 932, 'For most people, symptoms begin 10 days to 4 weeks after infection, although a person may feel ill after 7 days or as late as 1 year later. ', 'http://www.cdc.gov/malaria/about/faqs.html', '', b'1'),
(259, 5, 46, '2014-10-27 05:41:40', 'What are the signs and symptoms of measles?', 1, 937, 'Measles signs and symptoms appear 10 to 14 days after exposure to the virus. Signs and symptoms of measles typically include:\n\nFever\nDry cough\nRunny nose\nSore throat\nInflamed eyes (conjunctivitis)\nTiny white spots with bluish-white centers on a red background found inside the mouth on the inner lining of the cheek — also called Koplik''s spots\nA skin rash made up of large, flat blotches that often flow into one another.', 'http://www.mayoclinic.org/diseases-conditions/measles/basics/symptoms/con-20019675', '', b'1'),
(260, 5, 46, '2015-03-12 05:15:11', 'What treatment can get rid of an established measles infection?', 1, 938, 'Severe complications from measles can be avoided through supportive care that ensures good nutrition,   and treatment of dehydration. ', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1'),
(261, 9, 46, '2014-10-29 03:47:21', 'What is the mission of HEROforZERO?', 1, 943, 'In collaboration with UNICEF Vietnam, HEROforZERO aims to help reduce the number of children dying of preventable causes to 0. \n', 'http://www.unicef.org/vietnam/', '', b'1'),
(262, 9, 46, '2014-10-29 03:51:47', 'Who has HEROforZERO worked in collaboration with to accomplish it’s mission?', 1, 947, 'HEROforZERO is  supported by UNICEF but depends on the collaboration of many NGOS, Non-profits and You to accomplish its mission.\n', '', '', b'1'),
(264, 9, 46, '2014-10-29 03:54:08', 'In the HEROforZERO app, how can you save a virtual child?', 1, 954, 'In the HEROforZERO app to save a child you must complete a quest in one of several categories, such as health, protection or nutrition. \n', '', '', b'1'),
(265, 9, 46, '2014-10-29 04:04:17', 'In the HEROforZERO app, do I have to spend money to donate? ', 1, 960, 'The purpose of donation in the app is not to raise money but to educate people about how much impact small amounts of money can have. ', '', '', b'1'),
(266, 6, 46, '2014-07-22 16:43:44', 'What percent of females in Vietnam believe that a husband is justified in beating his wife in certain circumstances (2002-2010)?', 1, 965, 'UNICEF The State of the World’s Children (2012): Children in an Urban World', '', '', b'1'),
(267, 1, 46, '2014-08-28 08:17:41', 'What is the under five mortality rate in Vietnam out of 1000 live births (2010)?', 1, 968, 'UNICEF The State of the World’s Children (2012): Children in an Urban World', '', '', b'1'),
(268, 6, 46, '2014-07-22 16:43:13', 'What percentage of children in Vietnam ages 2-14 years old experience violent discipline (2010)?', 1, 972, 'UNICEF The State of the World’s Children (2012): Children in an Urban World', '', '', b'1'),
(269, 1, 46, '2014-07-16 03:26:14', 'What percent of the population in Vietnam lives under the poverty line ($1.25/day, 2002-2009)?\n', 1, 975, 'UNICEF The State of the World’s Children (2012): Children in an Urban World', '', '', b'1'),
(270, 1, 46, '2014-07-16 03:46:45', 'What is the life expectancy at birth in Vietnam (2010)?', 1, 978, 'Life expectancy at birth - The number of years newborn children would live if subject to the mortality risks prevailing for the cross-section of population at the time of their birth..', 'http://www.unicef.org/infobycountry/stats_popup1.html', '', b'1'),
(271, 8, 46, '2014-07-16 03:44:15', 'What is the percentage of under-fives in Vietnam that suffer from wasting (2010)?\n', 1, 984, 'Wasting, or low weight for height, is a strong predictor of mortality among children under five. It is usually the result of acute significant food shortage and/or disease. ', 'http://www.unicef.org/sowc2012/', '', b'1'),
(272, 1, 46, '2014-08-28 08:18:08', 'What percentage of the Vietnamese population lives in an urban setting?', 1, 987, '', 'http://www.unicef.org/sowc2012/', '', b'1'),
(273, 1, 46, '2014-07-16 03:42:16', 'What portion of  people living in cities live in slums?', 1, 993, 'Children''s health primarily determined by the socio-economic conditions in which they are born, grow, and live, and these are in turn shaped by the distribution of power and resources. The consequences of having too little of both are most readily evident in informal settlements and slums, where roughly 1.4 billion people will live by 2020. ', 'http://www.unicef.org/sowc2012/', '', b'1'),
(274, 1, 46, '2014-07-16 03:38:28', 'In 2050, how many people out of 10 will live in urban areas?', 1, 997, 'By 2050, 7 in 10 people will live in urban areas. Every year, the world''s population increases by approximately 60 million people. Most of this growth is taking place in low- and middle-income countries.', 'http://www.unicef.org/sowc2012/', '', b'1'),
(275, 1, 46, '2014-08-04 09:45:57', 'What percentage of the Vietnamese population lives in an urban setting?', 1, 999, 'UNICEF The State of the World’s Children (2012): Children in an Urban World\n', 'http://www.unicef.org/sowc2012/pdfs/SOWC%202012-Executive%20Summary_EN_13Mar2012.pdf', '', b'1'),
(276, 1, 46, '2014-08-04 09:47:34', 'What portion of the people living in cities live in slums?', 1, 1005, 'About one third of the world''s urban population lives in slum conditions. Some 1.4 billion people will live in informal settlements and slums by 2020.The difficulties the poor face are exacerbated by such factors as illegality, limited voice in decision-making and lack of secure tenure and legal protection.', 'http://www.unicef.org/sowc2012/pdfs/SOWC%202012-Executive%20Summary_EN_13Mar2012.pdf', '', b'1'),
(277, 1, 46, '2014-08-04 09:42:05', 'In 2050, how many people out of 10 will live in urban areas?', 1, 1009, 'By 2050, 7 in 10 people will live in urban areas, Every year, the world''s urban population increases by approximately 60 million people. Asia is home to half of the world''s urban population.', 'http://www.unicef.org/sowc2012/', '', b'1'),
(278, 6, 46, '2014-08-04 09:41:48', 'How does UNICEF define an adolescent?', 1, 1012, 'UNICEF and partners define adolescents as people between the ages of 10 and 19. : The United Nations define youth as persons between the ages of 15 and 24.\n', 'http://www.itu.int/osg/csd/cybersecurity/gca/cop/', '', b'1'),
(279, 6, 46, '2014-08-04 09:41:33', 'How does UNICEF define a child?', 1, 1014, 'The Convention on the Rights of the Child, defines a child as every human being below the age of 18 \nyears unless, under the country-specific law applicable to the child, majority is attained earlier.', 'http://www.itu.int/osg/csd/cybersecurity/gca/cop/', '', b'1'),
(280, 6, 46, '2014-08-04 09:41:13', 'What is cyberbullying?', 1, 1021, '', 'http://www.itu.int/osg/csd/cybersecurity/gca/cop/', '', b'1'),
(281, 6, 46, '2014-08-04 09:40:52', 'What is grooming?', 1, 1023, 'Both adults and young people can use the Internet to seek out children or other young people who are vulnerable. Frequently their goal is to convince them that they have a meaningful relationship but the underlying purpose is to manipulate them into performing sexual or other abusive acts either in real life following a meeting, or online using a web cam or some other recording device. This process is often referred to as grooming. ', 'http://www.itu.int/osg/csd/cybersecurity/gca/cop/', '', b'1'),
(282, 6, 46, '2014-07-22 17:27:11', 'What does ICT stand for?', 1, 1028, 'Over the past twenty years, new information and communication technologies (ICTs) have profoundly \nchanged the ways in which today’s young people interact with and participate in the world around them. \nThe proliferation of Internet access points, mobile technology and the growing array of Internet-enabled \ndevices combined with the immense resources to be found in cyberspace provide children and young \npeople with unprecedented opportunities to learn, share and communicate. ', 'http://business-humanrights.org/sites/default/files/media/documents/itu-unicef-guidelines-child-online-protection.pdf', '', b'1'),
(283, 6, 46, '2014-07-22 17:36:20', 'How is ‘child pornography’ defined?\n', 1, 1030, 'The Optional Protocol to the Convention on the Rights of the Child on the sale of children, child prostitution \nand child pornography defines child abuse material as any representation, by whatever means, of a child\nengaged in real or simulated explicit sexual activities or any representation of the sexual parts of a child for \nprimarily sexual purposes.', 'http://www.itu.int/osg/csd/cybersecurity/gca/cop/', '', b'1'),
(284, 9, 46, '2015-03-12 04:06:45', 'In the HEROforZERO app, how do you earn awards?', 1, 1035, 'In the HEROforZERO app, virtual donations are used to help you understand the needs of NGOs. ', '', '', b'1'),
(285, 9, 46, '2014-10-29 03:56:43', 'The HEROforZERO app was developed in what country?', 1, 1040, 'The HEROforZERO app was developed by a team of developers in Vietnam in collaboration with UNICEF.', '', '', b'1'),
(286, 9, 46, '2014-10-29 03:58:35', 'In the HEROforZERO app, how can you lose a quiz?', 1, 1045, '', '', '', b'1'),
(287, 9, 46, '2014-10-29 04:01:32', 'In the HEROforZERO app, how can you help NGOs help children?', 1, 1049, '', '', '', b'1'),
(290, 1, 46, '2015-03-12 04:05:48', 'How does playing HEROforZERO make you a HERO in real life?', 1, 1061, '', '', '', b'1'),
(291, 9, 46, '2014-10-29 04:03:08', 'In the HEROforZERO app, who are examples of some of the children you must save?', 1, 1065, '', '', '', b'1'),
(292, 9, 46, '2014-10-29 03:57:26', 'How many lives do I have in the HEROforZERO app?', 1, 1069, '', '', '', b'1'),
(294, 1, 46, '2014-09-16 04:07:26', 'What does UNICEF stand for?', 1, 1076, 'http://www.unicef.org/ourstory2013/', 'http://unicef.org', '', NULL),
(295, 1, 46, '2014-09-16 04:12:53', 'When was UNICEF established?', 1, 1081, 'On 11 December 1946, the global community establishing the UNICEF to respond to the the millions of displaced and refugee children.', '', '', NULL),
(296, 1, 46, '2014-09-16 04:14:12', 'Which objectives are UNICEF’s priorities?', 1, 1085, '', 'http://www.unicef.org/education/bege_61625.html', '', NULL),
(297, 1, 46, '2014-09-16 04:15:27', 'What is the official website of UNICEF?', 1, 1086, '', 'unicef.org', '', NULL),
(298, 1, 46, '2014-09-16 09:40:07', 'Which celebrity was NOT a UNICEF Goodwill Ambassador?', 1, 1093, '', 'http://www.unicef.org/people/people_ambassadors_international.html', '', NULL),
(299, 9, 46, '2015-03-12 03:29:50', 'UNICEF''s Next Generation shares a commitment to UNICEF''s future and a belief in ZERO.  What does ZERO mean?', 1, 1095, 'UNICEF''s NextGen aims to help reduce the number of children in Vietnam dying of preventable deaths to ZERO.', 'http://www.unicefusa.org/supporters/donors/nextgen', '', b'1'),
(300, 1, 46, '2014-09-16 09:51:29', 'What is the mission of the UNICEF Next Generation Vietnam?', 1, 1098, '', '', '', NULL),
(301, 7, 46, '2014-09-16 09:56:41', 'UNICEF has partnered with the Child-to-Child Trust to develop Getting Ready for School Which child group has the program targeted?', 1, 1103, 'Learn more about the about the benefits of ''Child-to-Child'' program at this website: unicef.org/education/bege_61646.html', 'http://www.unicef.org/education/bege_61646.html', '', NULL),
(302, 7, 46, '2014-09-16 09:58:33', 'There are currently an estimated 57 million primary school-age children who are not in school. Which children worldwide?\n', 1, 1109, 'There are currently an estimated 57 million primary school-age children who are not in school.  Learn more at: unicef.org/education/bege_616', 'http://www.unicef.org/education/bege_61657.html', '', NULL),
(303, 7, 46, '2014-09-16 10:10:07', 'UNICEF’s education programs are working to progress towards the achievement of two of the Millennium Development Goals. What are they? ', 1, 1111, '', 'http://www.unicef.org/education/bege_61721.html', '', NULL),
(304, 7, 46, '2014-09-16 10:10:58', 'How many general levels is the Vietnamese educational system divided into?', 1, 1114, 'Source: Vietnam Report: High Quality Education For All By 2020', '', '', NULL),
(305, 7, 46, '2014-09-16 10:11:57', 'Do Vietnamese children have to complete all the educational levels?', 1, 1119, '', '', '', NULL),
(306, 7, 46, '2014-09-16 10:12:29', 'What factors contribute to children’s educational performance?', 1, 1125, '', '', '', NULL),
(307, 7, 46, '2014-09-16 10:14:03', 'What factors can constrain children’s educational performance?', 1, 1129, 'Source: Vietnam Report: High Quality Education For All By 2020', '', '', NULL),
(308, 7, 46, '2014-09-16 10:15:11', 'On average how long does a girl’s education last in Vietnam?\n', 1, 1131, 'Source: http://www.savethechildren.org/site/c.8rKLIXMGIpI4E/b.6150551/k.C9F9/Vietnam.htm', 'http://www.savethechildren.org/site/c.8rKLIXMGIpI4E/b.6150551/k.C9F9/Vietnam.htm', '', NULL),
(310, 5, 46, '2014-09-16 10:16:25', 'What is usually the first sign of measles?', 1, 1138, '', '', '', NULL),
(311, 5, 46, '2014-09-16 10:17:02', 'Who is mostly at risk of getting measles?', 1, 1144, '', '', '', NULL),
(312, 5, 46, '2014-09-16 10:17:46', 'How much does a measles vaccine cost?', 1, 1146, '', '', '', NULL),
(313, 5, 46, '2014-09-16 10:18:36', 'What kind of vitamin supplements has been shown to reduce the number of deaths from measles by 50%?', 1, 1151, '', '', '', NULL),
(314, 5, 46, '2014-09-16 10:20:18', 'How is the measles virus transmitted?', 1, 1156, '', '', '', NULL),
(315, 5, 46, '2014-09-16 10:20:56', 'What is FALSE about measles?', 1, 1159, '', '', '', NULL),
(316, 5, 46, '2014-09-16 10:22:19', 'What is the MMR vaccine?', 1, 1164, 'Source: WHO (http://www.who.int/mediacentre/factsheets/fs286/en/)', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', NULL),
(317, 5, 46, '2014-09-16 10:23:08', 'What vaccine does an infant receive within the first 24 hours after birth?', 1, 1166, 'Source: http://ivac.com.vn/tin-tuc/2/16/12-loai-vacxin-can-tiem-cho-tre/vien-vac-xin.html', '', '', NULL),
(318, 5, 46, '2014-09-16 10:23:51', 'What is NOT a key principle to safer food?', 1, 1173, '(Source: http://www.wpro.who.int/vietnam/topics/food_safety/factsheet/en/)', 'http://www.wpro.who.int/vietnam/topics/food_safety/factsheet/en/', '', NULL),
(319, 5, 46, '2014-09-16 10:24:40', 'At what age do children most commonly become infected with Hand, Foot and Mouth Disease (HFMD)?', 1, 1174, '(Source: http://www.wpro.who.int/vietnam/topics/hand_foot_mouth/factsheet/en/)', 'http://www.wpro.who.int/vietnam/topics/hand_foot_mouth/factsheet/en/', '', NULL),
(320, 5, 46, '2014-09-16 10:26:47', 'What are the three steps of protection, all of which have been proposed by World Immunization Week 2014 of WHO?', 1, 1179, 'Source: http://www.wpro.who.int/vietnam/mediacentre/events/world_immunization_week/en/', 'http://www.wpro.who.int/vietnam/mediacentre/events/world_immunization_week/en/', '', NULL),
(321, 5, 46, '2014-09-16 10:27:47', 'In developing countries, what percentage of mothers and newborns do not receive skilled care during and immediately after birth?', 1, 1185, '(Source: http://www.wpro.who.int/vietnam/topics/newborn_health/factsheet/en/)', ' http://www.wpro.who.int/vietnam/topics/newborn_health/factsheet/en/', '', NULL),
(322, 5, 46, '2014-09-16 10:28:33', 'Who is the world’s largest buyer of vaccines?', 1, 1186, 'Source: http://www.unicefusa.org/mission/survival/immunization', 'http://www.unicefusa.org/mission/survival/immunization', '', NULL),
(323, 5, 46, '2014-09-16 10:31:14', 'Around the world, 1 in...... children under five remain unvaccinated.', 1, 1191, '(Source: http://www.unicefusa.org/mission/survival/immunization)', 'http://www.unicefusa.org/mission/survival/immunization', '', NULL),
(324, 5, 46, '2014-09-16 10:31:55', 'Where do most cases and deaths of malaria occur in Vietnam?', 1, 1197, '(Source: http://www.wpro.who.int/vietnam/topics/malaria/factsheet/en/)', 'http://www.wpro.who.int/vietnam/topics/malaria/factsheet/en/', '', NULL),
(325, 5, 46, '2014-09-16 10:32:35', 'On average, how many newborn babies die in Vietnam every year?', 1, 1199, '(Source: http://www.wpro.who.int/vietnam/topics/newborn_health/factsheet/en/)', 'http://www.wpro.who.int/vietnam/topics/newborn_health/factsheet/en/', '', NULL),
(326, 5, 46, '2014-09-16 10:33:58', 'Since 1988, UNICEF has eradicated polio in ______ countries.', 1, 1204, '(Source: http://www.unicefusa.org/mission/survival/immunization)', 'http://www.unicefusa.org/mission/survival/immunization', '', NULL),
(327, 5, 46, '2014-09-16 10:35:12', 'How many Vietnamese children don’t have access to clean water?', 1, 1207, '(Source: UNICEF Next Generation Vietnam: http://www.unicef.org/vietnam/media_20690.html', 'http://www.unicef.org/vietnam/media_20690.html', '', NULL),
(328, 5, 46, '2014-09-16 10:36:19', 'Where can a child/infant receive proper vaccines?', 1, 1213, '', '', '', NULL),
(329, 5, 46, '2014-10-27 05:24:47', 'When does World Immunization Week take place every year?', 1, 1217, 'immunization averts 2-3 million deaths each year from diseases such as diphtheria,\nmeasles, pertussis, pneumonia, polio, rotavirus, etc..', 'http://www.who.int/campaigns/immunization-week/2014/overview/en/', '', b'1'),
(330, 5, 46, '2014-09-16 10:40:27', 'What is the slogan for World Immunization Week 2014?', 1, 1219, 'Past theme: 2014: “Are you up-to-date?”, 2013: "Protect your world – get vaccinated", 2012: "Protect your world – get vaccinated".', 'http://en.wikipedia.org/wiki/World_Immunization_Week', '', NULL),
(331, 5, 46, '2014-10-27 05:25:16', 'What should newborns receive after the first hour of life?', 1, 1225, '', '', '', b'1'),
(332, 5, 46, '2014-09-16 10:42:38', 'Who does not receive optimal care during labour, birth and the immediate postnatal period?', 1, 1228, '', '', '', NULL),
(333, 5, 46, '2014-09-16 10:43:06', 'Which newborns should receive special attention?', 1, 1233, '', '', '', NULL),
(334, 5, 46, '2014-09-17 03:10:34', 'Who needs blood transfusions?', 1, 1237, 'Source: http://www.who.int/features/qa/61/en', 'http://www.who.int/features/qa/61/en', '', NULL),
(335, 5, 46, '2014-10-27 05:26:27', 'When are children at the greatest risk for death?', 1, 1239, 'Newborns are at the greatest risk of death. ', 'http://www.who.int/features/qa/13/en', '', b'1');
INSERT INTO `quiz` (`Id`, `CategoryId`, `PartnerId`, `CreatedDate`, `Content`, `BonusPoint`, `CorrectChoiceId`, `SharingInfo`, `LearnMoreURL`, `ImageURL`, `IsApproved`) VALUES
(336, 5, 46, '2014-10-27 05:26:53', 'What is the main cause of death in children under-five in Southeast Asia (2010)?', 1, 1242, 'Neonatal deaths (52%), Measles (3%), Phneumonia (15%), Malaria (1%): Source: WHO. Global Health Observatory (http://www.who.int/gho/child_he', 'http://www.who.int/gho/child_he', '', b'1'),
(337, 5, 46, '2014-09-17 03:17:10', 'Where do one third of all child deaths occur?', 1, 1248, '', '', '', NULL),
(338, 5, 46, '2014-09-17 03:17:54', 'What causes pneumonia?', 1, 1253, '', '', '', NULL),
(339, 5, 46, '2014-09-17 03:19:21', 'What is TRUE about diarrheal disease?', 1, 1254, '', '', '', NULL),
(340, 5, 46, '2014-09-17 03:20:43', 'What is TRUE about diarrheal disease?', 1, 1260, '', '', '', NULL),
(341, 5, 46, '2014-09-17 03:21:09', 'What are the most critical periods for newborn and maternal survival?', 1, 1265, '', '', '', NULL),
(342, 5, 46, '2014-09-17 03:21:30', 'What type of liquid helps to treat diarrhea?', 1, 1269, '', '', '', NULL),
(343, 5, 46, '2014-09-17 03:21:53', 'How can you prevent pneumonia?', 1, 1273, '', '', '', NULL),
(344, 5, 46, '2014-09-17 03:22:31', 'Which group of countries has never stopped the transmission of polio?', 1, 1274, 'Source: http://www.who.int/features/qa/07/en', 'http://www.who.int/features/qa/07/en', '', NULL),
(345, 5, 46, '2014-09-17 03:23:11', 'What TRUE about polio?', 1, 1280, 'Source: http://www.who.int/features/qa/07/en', 'http://www.who.int/features/qa/07/en', '', NULL),
(346, 5, 46, '2014-09-17 03:23:54', 'What is TRUE about tuberculosis (TB)?', 1, 1285, 'Source: http://www.who.int/features/qa/08/en', 'http://www.who.int/features/qa/08/en', '', NULL),
(347, 5, 46, '2014-09-17 03:24:24', 'What are the symptoms of tuberculosis?', 1, 1286, '', '', '', NULL),
(348, 5, 46, '2014-09-17 03:24:46', 'What is the yellow fever 17D vaccine for?', 1, 1291, '', '', '', NULL),
(349, 5, 46, '2014-09-17 03:25:21', 'What is the mortality rate of newborns in VN? (2009)', 1, 1294, 'Source: http://www.un.org.vn/vi/about-viet-nam/basic-statistics.html', 'http://www.un.org.vn/vi/about-viet-nam/basic-statistics.html', '', NULL),
(350, 5, 46, '2014-09-17 03:25:51', 'What is childbirth mortality rate of mothers in VN ? (2009)', 1, 1299, '', '', '', NULL),
(351, 5, 46, '2014-09-17 03:26:47', 'What day is Global Handwashing Day?', 1, 1302, '21 Feb: International Mother Language Day\n\n30 November: World AIDS Day\n\n22 Macrh: World Water Day', '', '', NULL),
(352, 8, 46, '2014-09-17 03:27:39', 'Every day, approximately................children die from starvattion and malnutrition.', 1, 1306, 'Source: http://30hourfamine.org/hunger-facts/?\n\ncons_id=0&ts=1400942956&signature=b1e84c539cec5784c6271a12918826ee', ' http://30hourfamine.org/hunger-facts/?  cons_id=0&ts=1400942956&signature=b1e84c539cec5784c6271a12918826ee', '', NULL),
(353, 8, 46, '2014-09-17 03:28:39', 'How can childhood malnutrition be avoided?', 1, 1313, '', '', '', NULL),
(354, 8, 46, '2014-09-17 03:29:01', 'What percent of children are underweight in VN?', 1, 1314, '', '', '', NULL),
(355, 8, 46, '2014-09-17 03:29:34', 'Out of every 6 children in Vietnam, how many of them don’t drink pure water?', 1, 1321, 'Source: UNICEF NEXT GENERATION VN', '', '', NULL),
(356, 8, 46, '2014-09-17 03:30:01', 'What common illness contributes to malnutrition?', 1, 1322, 'Source: http://www.un.org.vn/vi/feature-articles-press-centre-submenu-252/339-dinh-dung-\nba-m-va-tr-em--vit-nam.html', '', '', NULL),
(357, 8, 46, '2014-09-17 03:30:40', 'At what\n\nmilk?', 1, 1327, 'WHO recommends that infants start receiving complementary foods at\n\nsix months (180 days) of age in addition to breast milk', 'http://www.who.int/features/qa/21/en', '', NULL),
(358, 6, 46, '2014-09-17 03:31:09', 'What does ICT stand for?', 1, 1332, '', 'http://business-humanrights.org/sites/default/files/media/documents/itu-unicef-guidelines-child-online-protection.pdf', '', NULL),
(359, 8, 46, '2014-09-17 03:31:14', 'Malnutrition is responsible for what portion of all child deaths?', 1, 1335, '', '', '', NULL),
(360, 8, 46, '2014-09-17 03:31:37', 'What are the benefits of breast feeding?', 1, 1341, '', '', '', NULL),
(361, 8, 46, '2014-09-17 03:32:05', 'Which is the first natural food for babies?', 1, 1344, '', '', '', NULL),
(362, 8, 46, '2014-09-17 03:33:05', 'Which age group receives Vitamin A supplement in VN?', 1, 1346, 'Source: http://www.un.org.vn/vi/feature-articles-press-centre-submenu-252/339-dinh-dung-\nba-m-va-tr-em--vit-nam.html', 'http://www.un.org.vn/vi/feature-articles-press-centre-submenu-252/339-dinh-dung- ba-m-va-tr-em--vit-nam.html', '', NULL),
(363, 8, 46, '2014-09-17 03:33:40', 'What percent of mothers use a Vitamin A supplement after giving birth in VN?', 1, 1352, 'Source: http://www.un.org.vn/vi/feature-articles-press-centre-submenu-252/339-dinh-dung-\nba-m-va-tr-em--vit-nam.html', 'http://www.un.org.vn/vi/feature-articles-press-centre-submenu-252/339-dinh-dung- ba-m-va-tr-em--vit-nam.html', '', NULL),
(364, 8, 46, '2014-09-17 03:34:07', 'What is the leading cause of preventable blindness in children?', 1, 1354, '', '', '', NULL),
(365, 6, 46, '2014-09-17 03:34:23', 'What percent of child pornography victims are under the age of 10?', 1, 1359, '81 per cent of child victims are 10 years or under and 53 percent of the images depicted sexual activity between adults and children.', 'http://business-humanrights.org/sites/default/files/media/documents/itu-unicef-guidelines-child-online-protection.pdf', '', NULL),
(366, 8, 46, '2014-09-17 03:34:30', 'What effect does VAD (Vitamin A deficiency) have in children?', 1, 1365, '', '', '', NULL),
(367, 8, 46, '2014-09-17 03:34:53', 'What percent of children are breastfed within the 1 first hour of life?', 1, 1368, '', '', '', NULL),
(368, 8, 46, '2014-09-17 03:35:21', 'What helps to prevent diarrhea among newborns?', 1, 1371, 'Source: http://www.who.int/features/qa/13/en', ' http://www.who.int/features/qa/13/en', '', NULL),
(369, 6, 46, '2014-09-17 03:36:12', 'What percentage of the pornographic images depict a child with an adult?', 1, 1376, '53 per cent of the images depicted sexual activity between adults and children including rape and sexual torture. ', 'http://business-humanrights.org/sites/default/files/media/documents/itu-unicef-guidelines-child-online-protection.pdf', '', NULL),
(370, 5, 46, '2014-10-27 05:23:44', 'When is World AIDS Day?', 1, 1379, 'Share link: http://www.worldaidsday.org/', 'http://www.worldaidsday.org/', '', b'1'),
(371, 5, 46, '2014-10-27 05:23:29', 'How long does it take for a person infected with HIV to develop AIDS?', 1, 1383, 'The majority of people infected with HIV will develop signs of HIV-related illness within 5–10 years, although this can be shorter.', 'http://www.who.int/features/qa/71/en/', '', NULL),
(372, 6, 46, '2014-09-17 03:39:42', 'What makes online parental oversight difficult?', 1, 1389, 'Convergence of mobile phones and Internet services makes parental oversight much more difficult. Industry can work with governments, adults ', 'http://business-humanrights.org/sites/default/files/media/documents/itu-unicef-guidelines-child-online-protection.pdf', '', NULL),
(373, 5, 46, '2015-03-12 04:42:59', 'What is the most common life-threatening infection affecting people living with HIV/AIDS?', 1, 1391, 'Tuberculosis (TB) kills nearly a quarter of a million people living with HIV each year.', 'http://www.who.int/features/qa/71/en/', '', b'1'),
(374, 1, 46, '2014-09-17 03:40:35', 'The United Nations'' (UN) Universal Children''s Day, which was established in 1954,\n\ncelebrates and promotes international togetherness, child', 1, 1396, 'Share link: http://www.un.org/en/events/childrenday/', ' http://www.un.org/en/events/childrenday/', '', NULL),
(375, 1, 46, '2014-09-17 03:41:04', 'Body mass index (BMI) is a measure of body fat based on height and weight that \n\napplies to adult men and women. How is BMI calculated?', 1, 1400, '', '', '', NULL),
(376, 5, 46, '2014-10-27 05:20:12', 'What is the normal range for Body Mass Index (BMI) for adult males and females?', 1, 1403, 'Share link: http://www.nhlbi.nih.gov/guidelines/obesity/BMI/bmicalc.htm', 'http://www.nhlbi.nih.gov/guidelines/obesity/BMI/bmicalc.htm', '', b'1'),
(377, 1, 46, '2014-09-17 03:42:17', 'What day is the International Day of Happiness?', 1, 1406, 'Link: https://www.facebook.com/unicefvietnam', 'https://www.facebook.com/unicefvietnam', '', NULL),
(378, 8, 46, '2014-09-17 07:05:49', 'What does the SUN Movement stand for?', 1, 1413, 'Scaling Up Nutrition, or SUN, is a unique Movement founded on the principle that all people have a right to food and good nutrition. ', 'http://scalingupnutrition.org/', '', b'1'),
(379, 1, 46, '2014-09-17 07:03:48', 'What is Vietnam’s ranking among SUN countries?', 1, 1417, 'Scaling Up Nutrition, or SUN, is a unique Movement founded on the principle that all people have a right to food and good nutrition. ', 'http://scalingupnutrition.org/', '', b'1'),
(380, 1, 46, '2014-09-17 03:44:24', 'What is the name of the main police and security force in VN?', 1, 1419, '', '', '', b'1'),
(381, 1, 46, '2014-09-17 07:01:47', 'What is the date of World Humanitarian Day?', 1, 1422, 'Link: https://www.facebook.com/unicefvietnam', 'https://www.facebook.com/unicefvietnam', '', b'1'),
(382, 1, 46, '2014-09-17 03:45:33', 'What does UNICEF stand for?', 1, 1428, '', '', '', b'1'),
(383, 5, 46, '2014-09-17 06:48:43', 'How many people worldwide die from tobacco-related illnesses each year?', 1, 1431, '', '', '', b'1'),
(384, 1, 46, '2014-09-17 06:47:45', 'When was UNICEF established?', 1, 1437, '', '', '', b'1'),
(385, 1, 46, '2014-09-17 06:45:00', 'How many Millennium Development Goals (MDGs) are there?', 1, 1441, '', '', '', b'1'),
(386, 1, 46, '2014-09-17 06:44:14', 'What is the official website of UNICEF?', 1, 1442, '', 'www.unicef.org', '', b'1'),
(387, 6, 46, '2014-09-17 03:48:44', 'When did all the countries in the United Nations General Assembly agree on the\n\nConvention on the Rights of the Child?', 1, 1447, '', '', '', b'1'),
(388, 6, 46, '2014-09-17 03:49:09', 'When did the Vietnamese Government signthe Convention on the Rights of the Child?', 1, 1451, '', '', '', b'1'),
(389, 6, 46, '2014-09-17 03:49:48', 'To date, how many countries have signed the Convention on the Rights of the Child?', 1, 1456, '', '', '', b'1'),
(390, 1, 46, '2014-09-17 03:50:14', 'Which objectives are UNICEF''s priorities?', 1, 1461, '', 'http://www.unicef.org/education/bege_61625.html', '', b'1'),
(391, 6, 46, '2014-09-17 06:40:40', 'Which are the three countries in the world that have not yet signed the Convention on the Rights of the Child?', 1, 1464, '', '', '', b'1'),
(392, 6, 46, '2014-09-17 03:51:13', 'Which is best place for a child to grow up?', 1, 1467, '', '', '', NULL),
(394, 1, 46, '2014-10-15 06:19:51', 'A child under the Convention on the Rights of the Child is every human being under the age of...?', 1, 1476, 'The Convention on the Rights of the Child is the most rapidly and widely ratified international human rights treaty in history.', 'http://www.unicef.org/crc/', '', b'1'),
(395, 6, 46, '2015-03-12 03:51:44', 'The children’s rights in the Convention on the Rights of the Child do not include:', 1, 1480, 'The Convention of the Rights of the Child was adopted by the UN General Assembly in November of 1989. ', 'http://www.ohchr.org/en/professionalinterest/pages/crc.aspx', '', b'1'),
(396, 6, 46, '2014-09-17 06:37:14', 'According to the Convention on the Rights of the Child, every child has the right to participation. This means:', 1, 1485, '', '', '', b'1'),
(397, 9, 46, '2015-03-12 03:58:08', 'UNICEF''s NextGen believes in ZERO. What does ZERO mean?', 1, 1487, 'UNICEF Vietnam''s NextGen aims to help reduce the number of children in Vietnam dying of preventable deaths to ZERO.', 'http://www.unicefusa.org/supporters/donors/nextgen', '', b'1'),
(398, 6, 46, '2014-09-17 03:56:09', 'Child participation does not mean:', 1, 1490, '', '', '', b'1'),
(399, 1, 46, '2014-09-17 03:56:16', ' What is the mission of the UNICEF Next Generation Vietnam?', 1, 1497, '', '', '', b'1'),
(400, 6, 46, '2014-09-17 03:56:31', 'Which of the following is not a core principle of the Convention on the Rights of the\n\nChild?', 1, 1501, '', '', '', b'1'),
(401, 6, 46, '2015-03-12 03:52:33', 'Which are examples of violence against children?', 1, 1505, '', '', '', b'1'),
(403, 7, 46, '2014-12-05 06:00:32', 'UNICEF has partnered with the Child-to-Child trust to develop Getting Ready for School since 1997. What age group has the program targeted?', 1, 1511, '''Getting Ready for School: A child‐to‐child approach'' is an innovative and cost‐effective way of preparing preschool-aged children.', 'http://www.unicef.org/education/bege_61646.html', '', b'1'),
(404, 6, 46, '2014-09-17 06:26:14', 'How can we address violence against children?', 1, 1517, '', '', '', b'1'),
(405, 7, 46, '2014-12-05 05:59:21', 'Which region accounts for the largest proportion of all out-of-school children worldwide?', 1, 1521, 'There are currently an estimated 57 million primary school-age children who are not in school. Sub-Saharan Africa accounts for more than 1/2', 'http://www.unicef.org/education/bege_61657.html', '', b'1'),
(406, 6, 46, '2015-03-12 04:02:08', 'What was the number of children living in poverty in Vietnam in 2010 according to the Ministry of Labor, Invalids and Social Affairs (MOLISA', 1, 1523, '', '', '', b'1'),
(407, 6, 46, '2014-09-17 04:02:38', 'Child maltreatment can cause:', 1, 1529, '', '', '', b'1'),
(408, 7, 46, '2015-03-12 03:46:17', 'UNICEF’s education programs are working to accelerate progress towards the achievement of two of the Millennium Development Goals. They are?', 1, 1533, 'At the international level, UNICEF is part of four core partnerships that work to accelerate progress towards Goal 2 and Goal 3. ', 'http://www.unicef.org/education/bege_61721.html', '', b'1'),
(409, 7, 46, '2015-03-12 03:46:52', 'Do vietnamese children have to complete all the educational levels?\n', 1, 1535, 'Ethnic minorities, girls, children with disabilities, migrants and children affected by HIV have fewer opportunities to attend school.', 'http://www.unicef.org/vietnam/girls_education.html', '', b'1'),
(411, 7, 46, '2015-03-12 03:47:26', 'What factors can constrain a child''s educational performance?', 1, 1545, 'Vietnam Report: High Quality Education For All By 2020', 'http://www-wds.worldbank.org/external/default/WDSContentServer/WDSP/IB/2012/04/18/000333038_20120418014333/Rendered/PDF/680920v20WP0P10oduc0tap20Engl012012.pdf', '', b'1'),
(412, 7, 46, '2015-03-12 04:03:12', 'On average how long does a girl''s education last in Vietnam?', 1, 1547, 'In Vietnam, girls, especially those who are part of a minority group, are less likely to complete their education than boys. ', 'http://www.savethechildren.org/site/c.8rKLIXMGIpI4E/b.6150551/k.C9F9/Vietnam.htm', '', b'1'),
(413, 7, 46, '2014-09-17 04:11:56', 'What percentage of Vietnamese children are enrolled in primary school?', 1, 1551, '', 'http://www.unicef.org/vietnam/girls_education.html', '', b'1'),
(414, 5, 46, '2014-10-27 05:16:07', 'What is usually the first sign of measles?', 1, 1554, '', '', '', b'1'),
(415, 5, 46, '2014-10-27 05:15:42', 'Who is at the highest risk of getting measles?', 1, 1560, '', '', '', b'1'),
(416, 5, 46, '2014-10-27 05:13:34', 'How much does a measles vaccine cost?', 1, 1562, '', '', '', b'1'),
(417, 5, 46, '2015-03-12 04:54:38', 'What kind of vitamin supplements has been shown to reduce the number of measles deaths by 50%?', 1, 1566, 'All children in developing countries diagnosed with measles should receive two doses of vitamin A supplements, given 24 hours apart.', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1'),
(418, 5, 46, '2015-03-12 05:18:37', 'How is the measles virus transmitted?', 1, 1570, 'Measles is spread by coughing and sneezing, close personal contact or direct contact with infected nasal or throat fluid', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1'),
(419, 6, 46, '2014-09-17 06:14:23', 'Which of these is related to child maltreatment?', 1, 1577, '', '', '', b'1'),
(420, 6, 46, '2014-11-20 08:20:28', 'The consequences of violence against children can obstruct economic growth because of: ', 1, 1581, '', '', '', b'1'),
(421, 6, 46, '2014-09-17 04:35:35', 'What can be taught in schools to prevent and respond to child sexual abuse?', 1, 1585, '', '', '', b'1'),
(422, 6, 46, '2014-09-17 04:36:30', 'What are the possible consequences for children who were victims of violence?', 1, 1589, '', '', '', b'1'),
(423, 6, 46, '2014-09-17 04:37:06', 'Which of the things below are forms of child maltreatment?', 1, 1593, '', '', '', b'1'),
(424, 6, 46, '2014-09-17 04:37:35', 'What is the percentage of children 12-14 in Vietnam who experienced violent punishment by parents?', 1, 1595, '', '', '', b'1'),
(425, 6, 46, '2014-09-17 04:38:01', 'What does Corporal or Physical Punishment Include?', 1, 1601, '', '', '', b'1'),
(426, 5, 46, '2014-10-27 05:14:23', 'What is FALSE about measles?', 1, 1603, '', '', '', b'1'),
(427, 6, 46, '2014-09-17 04:39:17', 'What alternatives to corporal punishment will ensure good/positive discipline?', 1, 1609, '', '', '', b'1'),
(428, 5, 46, '2014-10-27 05:14:51', 'What is the MMR vaccine?', 1, 1612, '', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1'),
(429, 6, 46, '2014-09-17 04:39:42', 'What is a possible sign of emotional abuse?', 1, 1616, '', '', '', b'1'),
(430, 6, 46, '2014-09-17 06:00:07', 'How much more likely are children with disabilities to suffer from violence or sexual abuse, compared with others?', 1, 1620, '', '', '', b'1'),
(431, 6, 46, '2014-09-17 04:40:51', 'How many children are exploited in the commercial sex trade in the world?', 1, 1624, '(Source: http://www.unicefusa.org/mission/protect/violence)', 'http://www.unicefusa.org/mission/protect/violence', '', b'1'),
(432, 6, 46, '2014-09-17 04:41:19', 'What is the percentage of women who have been sexually abused as children?', 1, 1628, '', '', '', b'1'),
(433, 5, 46, '2015-03-12 04:47:53', 'What vaccine does an infant receive within the first 24 hours after birth?', 1, 1630, 'All newborns should receive a Hepatitis B vaccine before leaving being discharged. Vietnam has reduced its numbers of Hepatitis B cases. ', 'http://www.wpro.who.int/vietnam/topics/immunization/factsheet/en/', '', b'1'),
(434, 6, 46, '2014-11-20 08:19:38', 'If a child discloses that he or she has been abused by someone, what should you do?', 1, 1637, '', '', '', b'1'),
(435, 6, 46, '2014-09-17 04:42:43', 'If a child discloses that he or she has been abused by someone, what SHOULD you NOT\n\nDO?', 1, 1641, '', '', '', b'1'),
(436, 6, 46, '2014-09-17 04:42:58', 'How many children die every day as a result of abuse and neglect?', 1, 1643, '', '', '', b'1'),
(437, 6, 46, '2014-09-17 04:43:23', 'Approximately how many child abuse cases reported every year?', 1, 1648, '', '', '', b'1'),
(439, 7, 46, '2014-12-05 05:58:54', 'How many children under the age of 5 worldwide are not achieving their developmental potential?', 1, 1656, 'They do not reach their potential because of the lack of adequate nutrition, poor health and stimulating, nurturing, responsive environments', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(440, 1, 46, '2014-10-27 05:11:26', 'Nature or Nurture? Nurture? Nature? Which is the most important in child development?', 1, 1661, 'It is nature with nurture, the degree of interdependence is even greater than we ever imagined.', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(441, 5, 46, '2014-10-27 05:11:04', 'When does the human brain develop most rapidly?', 1, 1662, 'In young children, neurons form new connections at the astounding rate of 700 to 1,000 per second. ', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(442, 5, 46, '2015-03-12 04:57:01', 'When is it hardest to fix brain development and set it back on track?', 1, 1669, 'The extent and severity of problems in later life linked with early deprivation can be remediated through early intervention.', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(443, 6, 46, '2015-03-12 04:57:23', 'What is the main experience the brain depends on for optimal development?', 1, 1673, 'The brain relies on multiple experiences to develop: Nutrition, Stimulation, Healthy Interactions, and Protection', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(444, 8, 46, '2014-10-27 05:04:11', 'In gestation and infancy how much of the total energy used by the body is used by the brain?', 1, 1676, 'It consumes between 50 and 75 per cent of all the energy absorbed by the body from food, including fats, proteins, vitamins and minerals.', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(445, 8, 46, '2014-10-15 08:41:46', 'What do high levels of stress do to a child''s body?', 1, 1681, 'Smarter interventions should therefore link nutrition with stress reduction, improving a child’s nutritional status and brain development.', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(446, 6, 46, '2014-10-15 08:47:45', 'What is toxic stress?', 1, 1683, 'Toxic stress produces high levels of cortisol, which damages health, learning and behavior.', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(447, 7, 46, '2015-03-12 03:48:33', 'What permanently strengthens a child''s ability to learn?', 1, 1689, 'Stimulating interaction between young children and their parents and caregivers positively and permanently strengthens the ability to learn.', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(448, 5, 46, '2014-10-27 05:02:09', 'When is the foundation of a brain''s network and pathways established?', 1, 1691, 'The “Heckman Curve” graph shows that the highest return on investments in education and training is pre-primary learning, from zero to three', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(449, 8, 46, '2014-10-27 05:01:40', 'What are some developmental benefits of breastfeeding?', 1, 1697, 'Better nutrition, stimulation, nurturing and a strengthened bond between mother and child support healthy brain development.', 'http://www.unicef.org/protection/57929_58022.html', '', b'1'),
(450, 5, 46, '2014-10-27 05:01:16', 'What fraction of children worldwide are not reaching their developmental potential?', 1, 1699, 'One third of all children3 are not achieving their development potential, with a profound effect on their lives and long-term consequences.', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(451, 5, 46, '2014-10-27 05:00:49', 'What is interesting about a child''s brain at age 3?', 1, 1704, 'At 3 years of age, a child’s brain is twice as active as an adult brain (Brotherson, 2009).', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(452, 8, 46, '2014-10-27 05:00:03', 'What percent of brain weight is acquired by 3 years of age?', 1, 1709, '87% of brain weight is acquired by 3 years of age (1,100 grams; Dekaban, 1978).', 'http://blogs.unicef.org/2014/05/14/how-childrens-brains-develop-new-insights/', '', b'1'),
(453, 5, 46, '2015-03-12 04:15:42', 'At what age do children most commonly become infected with Hand, Foot and Mouth Disease?', 1, 1713, 'Hand, foot, and mouth disease is a common viral illness that usually affects infants and children younger than 5 years old. ', 'http://www.wpro.who.int/vietnam/topics/hand_foot_mouth/factsheet/en/', '', b'1'),
(454, 1, 46, '2015-03-12 05:08:58', 'In developing countries, what percentage of mothers and newborns do not receive skilled care during and immediately after child birth?', 1, 1717, 'In developing countries nearly half of all mothers and newborns do not receive skilled care during and immediately after birth.', 'http://www.who.int/mediacentre/factsheets/fs333/en/', '', b'1'),
(455, 0, 46, '2014-10-27 06:26:08', 'Who is the world''s largest purchaser of vaccines?', 1, 1718, '', 'http://www.unicefusa.org/mission/survival/immunization', '', NULL),
(456, 1, 46, '2014-10-27 06:28:20', 'On average, how many newborn babies die every year in Vietnam?', 1, 1723, '', 'http://www.wpro.who.int/vietnam/topics/newborn_health/factsheet/en/', '', NULL),
(457, 1, 46, '2014-10-27 06:30:24', 'Since 1988, UNICEF has eradicated polio in ____ countries.', 1, 1728, '', 'http://www.unicefusa.org/mission/survival/immunization', '', NULL),
(458, 1, 46, '2015-03-12 04:09:54', 'How many vietnamese children do not have access to clean water?', 1, 1731, '', '', '', b'1'),
(459, 5, 46, '2015-03-12 04:09:38', 'Where can a child/infant receive proper vaccines?', 1, 1737, '', '', '', b'1'),
(460, 1, 46, '2014-10-27 06:37:46', 'When does World Immunization Week take place every year?', 1, 1740, 'World Immunization Week is an opportunity to remind families and communities how effective vaccines are in preventing dangerous diseases. ', 'http://www.who.int/campaigns/immunization-week/2014/overview/en/', '', NULL),
(461, 5, 46, '2015-03-12 04:09:02', 'What was the slogan for World Immunization Week 2014?', 1, 1742, 'Each World Immunization Week focuses on a theme. Previous themes have included the following:\n    2014: “Are you up-to-date?”', 'http://en.wikipedia.org/wiki/World_Immunization_Week', '', b'1'),
(462, 0, 46, '2014-10-27 06:48:05', 'Who does not receive optimal care during labour, birth and immediate postnatal period?', 1, 1748, '', '', '', NULL),
(475, 0, 46, '2015-01-02 13:52:31', 'Children are likely to be physically and emotionally abused\nif they live in families:', 1, 1801, '', 'http://www.svri.org/InnocentiVACInstitutional.pdf', '', NULL),
(476, 0, 46, '2015-01-02 13:54:20', 'Children are likely to be physically and emotionally abused\nif they live in families:', 1, 1805, '', 'http://www.svri.org/InnocentiVACInstitutional.pdf', '', NULL),
(477, 6, 46, '2015-01-05 06:46:41', 'From 2006-2011 how many reported cases of sexual abuse against children were there?', 1, 1808, 'In Vietnam, from 2006-2011 5,600 cases of sexual abuse against children were reported to police. ', 'http://unicefvietnam.blogspot.com/2014/06/viet-nam-responds-to-unicefs-global.html', 'http://heroforzero.be/assets/uploads/835557feda3d1d33118e02c19ec54b73.jpg', b'1'),
(478, 6, 46, '2015-03-12 04:00:24', 'What percentage of women in Vietnam with children under 15 witnessed violence against their children by their husbands? ', 1, 1810, 'A quarter of all married women in Vietnam with children under the age of 15 witnessed their husbands use violence against their children.', 'http://unicefvietnam.blogspot.com/2014/06/viet-nam-responds-to-unicefs-global.html', 'http://heroforzero.be/assets/uploads/b90563fb6fd7c3693f1ca7272dbf1639.jpg', b'1'),
(479, 0, 46, '2015-01-05 06:53:17', 'Which day is national Children''s Day in Vietnam?', 1, 1815, 'In Viet Nam, the first day of summer, 1st June, traditionally marks the national Children’s Day and the start of the national Month of Actio', 'http://unicefvietnam.blogspot.com/2014/06/viet-nam-responds-to-unicefs-global.html', '', NULL),
(480, 0, 46, '2015-01-05 07:18:47', 'What percentage of mothers in Vietnam think that physical punishment is necessary to raise/educate children?', 1, 1819, 'About 18% of mothers in Vietnam believe that physical punishment is necessary to educate and raise their children. ', 'http://files.unicef.org/publications/files/Hidden_in_plain_sight_statistical_analysis_EN_3_Sept_2014.pdf', '', NULL),
(481, 6, 46, '2015-01-05 07:31:48', 'What percentage of fathers in Viet Nam believe that physical punishment is necessary to raise and educate children?', 1, 1823, 'About 17% of fathers in Vietnam think that physical punishment is necessary to raise and educate children. ', 'http://files.unicef.org/publications/files/Hidden_in_plain_sight_statistical_analysis_EN_3_Sept_2014.pdf', '', NULL),
(482, 6, 46, '2015-03-12 03:44:59', 'Based on income distribution, which group is more likely to believe that corporal punishment is necessary?', 1, 1826, 'In most countries, the wealthier section of\nthe population is less likely to believe that\ncorporal punishment is necessary than the poorer', 'http://files.unicef.org/publications/files/Hidden_in_plain_sight_statistical_analysis_EN_3_Sept_2014.pdf', '', b'1'),
(483, 6, 46, '2015-01-05 07:43:07', 'Parents of which educational background are more likely to think that physical punishment is necessary?', 1, 1831, 'Overall, adults with little or no education are more likely than their more educated peers to think that physical punishment is necessary.', 'http://files.unicef.org/publications/files/Hidden_in_plain_sight_statistical_analysis_EN_3_Sept_2014.pdf', '', b'1'),
(484, 6, 46, '2015-01-05 09:56:14', 'What percentage of children in Vietnam between the ages of 2-14 have experienced physical punishment?', 1, 1837, 'Although only about 17% of parents think that physical punishment is necessary, 53% of children experienced physical punishment. ', 'http://files.unicef.org/publications/files/Hidden_in_plain_sight_statistical_analysis_EN_3_Sept_2014.pdf', '', b'1'),
(485, 6, 46, '2015-03-12 03:43:20', 'What percentage of women worldwide are child brides (married before the age of 18)?', 1, 1840, 'Women aged 20 to 24 worldwide, about one in three were child brides.  Many factors interact to place a girl at risk of marriage.', 'http://data.unicef.org/child-protection/child-marriage', '', b'1'),
(486, 6, 46, '2015-03-12 03:42:30', 'In what ways can child marriage (marriage under the age of 18) compromise a girl''s development?', 1, 1845, 'Child marriage often results in early pregnancy and social isolation, interrupted her schooling, limited career and vocational options', 'http://data.unicef.org/child-protection/child-marriage', '', b'1'),
(487, 6, 46, '2015-01-05 08:59:41', 'How many children worldwide are engaged in child labour?', 1, 1846, 'In the least developed countries, nearly one in four children (5-14) are engaged in labour that is considered detrimental to their health', 'http://data.unicef.org/child-protection/child-labour', '', b'1'),
(488, 0, 46, '2015-01-05 09:10:42', 'Why is it important that children be registered at birth?', 1, 1853, 'Registering children at birth is the first step in securing their recognition before the law, safeguarding their rights. ', 'http://data.unicef.org/child-protection/birth-registration', '', NULL),
(489, 6, 46, '2015-03-12 03:41:34', 'Why is it important that children be registered at birth?', 1, 1857, 'Registering children at birth is the first step in securing their recognition before the law and safeguarding their rights.', 'http://data.unicef.org/child-protection/birth-registration', '', b'1'),
(490, 6, 46, '2015-03-12 03:41:11', 'How many children worldwide under the age of five were not registered at birth?', 1, 1861, 'A name and nationality is every child’s right, enshrined in the Convention on the Rights of the Child and other international treaties. ', 'http://data.unicef.org/child-protection/birth-registration', '', b'1'),
(491, 6, 46, '2015-01-05 09:34:21', 'What percentage of adolescent girls in Southeast Asia believe that wife-beating can be justified in certain circumstances?', 1, 1865, 'Nearly half of adolescent girls worldwide say\nwife-beating can be justified under certain circumstances. ', 'http://files.unicef.org/publications/files/Hidden_in_plain_sight_statistical_analysis_EN_3_Sept_2014.pdf', '', b'1'),
(492, 5, 46, '2015-03-12 04:37:43', 'How many people worldwide die each year from malaria?', 1, 1869, 'Malaria is caused by a parasite, transmitted by the bite of infected mosquitoes. Malaria kills an estimated 1 million people a year. ', 'http://www.mayoclinic.org/diseases-conditions/malaria/basics/definition/con-20013734', '', NULL),
(493, 1, 46, '2015-03-12 05:08:43', 'What percentage of under 5 deaths happen in the first 28 days of life?', 1, 1872, 'Every year nearly 40% of all under-five child deaths are among newborn infants, babies in their first 28 days of life or the neonatal period', 'http://www.who.int/mediacentre/factsheets/fs333/en/', '', b'1'),
(494, 1, 46, '2015-03-12 05:08:28', 'What percentage of newborn deaths occur in the first week of life?', 1, 1877, 'Three quarters of all newborn deaths occur in the first week of life.', 'http://www.who.int/mediacentre/factsheets/fs333/en/', '', b'1'),
(495, 1, 46, '2015-03-12 05:08:13', 'In the developing world what percentage of newborn deaths can be prevented?', 1, 1878, 'Up to two thirds of newborn deaths can be prevented if known, effective health measures are provided at birth and during the first week of l', 'http://www.who.int/mediacentre/factsheets/fs333/en/', '', b'1'),
(496, 1, 46, '2015-03-12 05:07:23', 'What percentage of newborn deaths occur within the first 24 hours?', 1, 1883, 'The majority of all neonatal deaths (75%) occur during the first week of life, and between 25% to 45% occur within the first 24 hours.', 'http://www.who.int/mediacentre/factsheets/fs333/en/', '', b'1'),
(497, 5, 46, '2015-03-12 05:12:41', 'When can a person infected with measles transmit the infection to another?', 1, 1889, 'Measles can be transmitted by an infected person from 4 days prior to the onset of the rash to 4 days after the rash erupts.', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1'),
(498, 5, 46, '2015-03-12 05:20:16', 'How long has a measles vaccine been available?', 1, 1893, 'The measles vaccine has been in use for 50 years. It is safe, effective and inexpensive. It costs approximately one US dollar.', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1'),
(499, 5, 46, '2015-03-12 05:22:34', 'In 2013 what percentage of children worldwide received a measles vaccination before their first birthday?', 1, 1895, 'In 2013, about 84% of the world''s children received 1 dose of measles vaccine by their first birthday through routine health services. ', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1'),
(500, 5, 46, '2015-03-12 05:24:32', 'How many children were vaccinated against measles in 2013?', 1, 1900, 'During 2013, about 205 million children were vaccinated against measles during mass vaccination campaigns in 34 countries, including Vietnam', 'http://www.who.int/mediacentre/factsheets/fs286/en/', '', b'1');

-- --------------------------------------------------------

--
-- Table structure for table `quizcategory`
--

CREATE TABLE IF NOT EXISTS `quizcategory` (
`Id` int(11) NOT NULL,
  `CategoryName` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `quizcategory`
--

INSERT INTO `quizcategory` (`Id`, `CategoryName`) VALUES
(1, 'General'),
(5, 'Health'),
(6, 'Protection'),
(7, 'Education'),
(8, 'Nutrition'),
(9, 'Training'),
(10, 'Nutrition_Statistics'),
(11, 'Health_Diseases'),
(12, 'Health_SexEd'),
(13, 'Internet Protection'),
(14, 'Environment');

-- --------------------------------------------------------

--
-- Table structure for table `reward`
--

CREATE TABLE IF NOT EXISTS `reward` (
  `id` int(11) NOT NULL,
  `reward_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `reward`
--

INSERT INTO `reward` (`id`, `reward_name`, `image_url`) VALUES
(1, 'Medal of HONOR', 'http://ec2-54-200-123-156.us-west-2.compute.amazonaws.com/travelhero/images/medals/d6cd052f-273b-4192-9af2-5769db01ed04.png'),
(2, 'Trophy of HONOR', 'http://ec2-54-200-123-156.us-west-2.compute.amazonaws.com/travelhero/images/medals/e266579b-df4c-49a4-9146-eba7a8a11961.png');

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE IF NOT EXISTS `role` (
`Id` int(11) NOT NULL,
  `Name` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`Id`, `Name`) VALUES
(1, 'hyper-admin'),
(2, 'super-admin'),
(3, 'admin'),
(4, 'ngo'),
(5, 'user');

-- --------------------------------------------------------

--
-- Table structure for table `rolefunction`
--

CREATE TABLE IF NOT EXISTS `rolefunction` (
`RoleId` int(11) NOT NULL,
  `FunctionId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
`Id` int(11) NOT NULL,
  `FullName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `RegisterDate` datetime DEFAULT NULL,
  `PhoneNumber` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AvatarId` int(11) DEFAULT '1'
) ENGINE=InnoDB AUTO_INCREMENT=494 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`Id`, `FullName`, `Email`, `RegisterDate`, `PhoneNumber`, `Address`, `AvatarId`) VALUES
(24, 'Ngọc Tân', '0', '2014-05-12 00:00:00', '', NULL, 1),
(492, NULL, 'anguyen@gmail.com', '2015-05-26 16:50:29', '0987654322', NULL, 1),
(493, NULL, 'admin@organization.com', '2015-05-26 16:56:03', '0123456789', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `userapplication`
--

CREATE TABLE IF NOT EXISTS `userapplication` (
  `UserId` int(11) NOT NULL,
  `FacebookId` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Points` int(11) DEFAULT '0',
  `CurrentLevel` int(11) DEFAULT '0',
  `device_id` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `userapplication`
--

INSERT INTO `userapplication` (`UserId`, `FacebookId`, `Points`, `CurrentLevel`, `device_id`) VALUES
(24, '100002989569961', 437, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `usercondition`
--

CREATE TABLE IF NOT EXISTS `usercondition` (
  `UserId` int(11) NOT NULL,
  `ConditionId` int(11) NOT NULL,
  `AchievingPoints` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Keep track user - condition on each quest. If user have record here, means that user have completed this condition. :)';

--
-- Dumping data for table `usercondition`
--

INSERT INTO `usercondition` (`UserId`, `ConditionId`, `AchievingPoints`) VALUES
(24, 0, 437);

-- --------------------------------------------------------

--
-- Table structure for table `usermedal`
--

CREATE TABLE IF NOT EXISTS `usermedal` (
`Id` int(11) NOT NULL,
  `UserId` int(11) DEFAULT NULL,
  `MedalId` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=454 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `usermedal`
--

INSERT INTO `usermedal` (`Id`, `UserId`, `MedalId`) VALUES
(138, 24, 4),
(141, 24, 5),
(142, 24, 6);

-- --------------------------------------------------------

--
-- Table structure for table `userpartner`
--

CREATE TABLE IF NOT EXISTS `userpartner` (
`UserId` int(11) NOT NULL,
  `PartnerId` int(11) DEFAULT NULL,
  `UserName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Password` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=494 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `userpartner`
--

INSERT INTO `userpartner` (`UserId`, `PartnerId`, `UserName`, `Password`) VALUES
(492, 46, 'organization', 'e10adc3949ba59abbe56e057f20f883e'),
(493, 47, 'adminsite', 'e10adc3949ba59abbe56e057f20f883e');

-- --------------------------------------------------------

--
-- Table structure for table `userrole`
--

CREATE TABLE IF NOT EXISTS `userrole` (
  `UserId` int(11) NOT NULL,
  `RoleId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `userrole`
--

INSERT INTO `userrole` (`UserId`, `RoleId`) VALUES
(2, 4),
(493, 3);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`id` int(11) unsigned NOT NULL,
  `ip_address` varbinary(16) NOT NULL,
  `username` varchar(100) CHARACTER SET utf8 NOT NULL,
  `password` varchar(80) CHARACTER SET utf8 NOT NULL,
  `salt` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8 NOT NULL,
  `activation_code` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `forgotten_password_code` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `forgotten_password_time` int(11) unsigned DEFAULT NULL,
  `remember_code` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `created_on` int(11) unsigned NOT NULL,
  `last_login` int(11) unsigned DEFAULT NULL,
  `active` tinyint(1) unsigned DEFAULT NULL,
  `first_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `last_name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `company` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `gender` int(1) NOT NULL,
  `url` varchar(256) CHARACTER SET utf8 NOT NULL,
  `bio` text CHARACTER SET utf8 NOT NULL,
  `birthday` date NOT NULL,
  `location` varchar(56) CHARACTER SET utf8 NOT NULL,
  `full_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `hero_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `phone_number` varchar(20) CHARACTER SET utf8 NOT NULL,
  `facebook_id` varchar(100) CHARACTER SET utf8 NOT NULL,
  `address` varchar(200) CHARACTER SET utf8 NOT NULL,
  `current_level` int(11) NOT NULL DEFAULT '0',
  `point` int(11) NOT NULL DEFAULT '0',
  `accept_tou` bit(1) NOT NULL DEFAULT b'0',
  `register_date` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `forgotten_password_time`, `remember_code`, `created_on`, `last_login`, `active`, `first_name`, `last_name`, `company`, `phone`, `gender`, `url`, `bio`, `birthday`, `location`, `full_name`, `hero_name`, `phone_number`, `facebook_id`, `address`, `current_level`, `point`, `accept_tou`, `register_date`) VALUES
(1, 0x7f000001, 'administrator', '59beecdf7fc966e2f17fd8f65a4a9aeb09d4a3d4', '9462e8eee0', 'admin@admin.com', '', NULL, NULL, '9d029802e28cd9c768e8e62277c0df49ec65c48c', 1268889823, 1393398559, 1, 'Admin', 'istrator', 'ADMIN', '0', 0, '', '', '0000-00-00', '', '', '', '', '', '', 0, 0, b'1', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `users_groups`
--

CREATE TABLE IF NOT EXISTS `users_groups` (
`id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `group_id` mediumint(8) unsigned NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users_groups`
--

INSERT INTO `users_groups` (`id`, `user_id`, `group_id`) VALUES
(1, 1, 1),
(2, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `uservirtualquest`
--

CREATE TABLE IF NOT EXISTS `uservirtualquest` (
  `UserId` int(11) NOT NULL,
  `QuestId` int(11) NOT NULL,
  `Status` int(11) NOT NULL COMMENT 'Status: 1 = lock, 1 = unlock, 2 = solve'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `uservirtualquest`
--

INSERT INTO `uservirtualquest` (`UserId`, `QuestId`, `Status`) VALUES
(24, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `user_quest`
--

CREATE TABLE IF NOT EXISTS `user_quest` (
  `user_id` int(11) DEFAULT NULL,
  `quest_id` int(11) DEFAULT NULL,
  `parent_quest_id` int(11) DEFAULT NULL,
  `status_quest` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user_quest`
--

INSERT INTO `user_quest` (`user_id`, `quest_id`, `parent_quest_id`, `status_quest`) VALUES
(1, 2, 1, 0),
(27, 8, 5, 0),
(1, 3, 1, 0),
(27, 6, 5, 0),
(27, 9, 5, 0),
(27, 2, 1, 0),
(6, 2, 1, 0),
(1, 7, 5, 0),
(1, 4, 1, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_userinfo`
--
CREATE TABLE IF NOT EXISTS `view_userinfo` (
`uUserId` int(11)
,`uFacebookId` varchar(45)
,`uPoints` int(11)
,`uCurrentLevel` int(11)
,`vId` int(11)
,`vQuestName` varchar(45)
,`vPacketId` int(11)
,`vPartnerId` int(11)
,`vAnimationId` int(11)
,`vUnlockPoint` int(11)
,`vCreateDate` datetime
,`qStatus` int(11)
,`cId` int(11)
,`cType` int(11)
,`cValue` int(11)
,`cVirtualQuestId` int(11)
,`cObjectId` int(11)
);
-- --------------------------------------------------------

--
-- Table structure for table `virtualquest`
--

CREATE TABLE IF NOT EXISTS `virtualquest` (
`Id` int(11) NOT NULL,
  `QuestName` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PacketId` int(11) DEFAULT NULL,
  `PartnerId` int(11) DEFAULT NULL,
  `AnimationId` int(11) DEFAULT '1',
  `UnlockPoint` int(11) DEFAULT NULL,
  `CreateDate` datetime DEFAULT NULL,
  `ImageURL` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MedalId` int(11) NOT NULL DEFAULT '0' COMMENT 'Id connect to Medal table.'
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `virtualquest`
--

INSERT INTO `virtualquest` (`Id`, `QuestName`, `PacketId`, `PartnerId`, `AnimationId`, `UnlockPoint`, `CreateDate`, `ImageURL`, `MedalId`) VALUES
(1, 'Earn a sword', 1, 5, 6, 0, NULL, 'http://heroforzero.be/assets/img/quest/training-sword.png', 4),
(2, 'Earn a shield', 1, 5, 5, 10, NULL, 'http://heroforzero.be/assets/img/quest/training-shield.png', 5),
(3, 'Earn a cape', 1, 5, 4, 15, NULL, 'http://heroforzero.be/assets/img/quest/training-cape.png', 6),
(4, 'Help Tu get treatment', 2, 5, 8, 20, NULL, 'http://heroforzero.be/assets/img/quest/nutrition-minority.png', 31),
(5, 'Save Nam from hunger', 2, 5, 2, 25, NULL, 'http://heroforzero.be/assets/img/quest/nutrition-buddist.png', 7),
(6, 'Help Ty find food', 2, 5, 2, 30, NULL, 'http://heroforzero.be/assets/img/quest/nutrition-streetkid.png', 8),
(7, 'Help Son get an education', 3, 5, 3, 30, NULL, 'http://heroforzero.be/assets/img/quest/education-streetworker.png', 10),
(8, 'Help Mai go to school', 3, 5, 3, 35, NULL, 'http://heroforzero.be/assets/img/quest/education-minority.png', 11),
(9, 'Give Linh scholarships', 3, 5, 3, 35, NULL, 'http://heroforzero.be/assets/img/quest/education-minority.png', 12),
(10, 'Save Mai from the wolf', 4, 5, 4, 40, '2014-05-05 07:31:44', 'http://heroforzero.be/assets/img/quest/training-sword.png', 13),
(11, 'Save Lac from abuse', 4, 5, 4, 40, '2014-08-25 04:33:28', 'http://heroforzero.be/assets/img/quest/protection-abused.png', 14),
(12, 'Help Ty away from school bullying', 4, 5, 2, 40, '2014-09-04 07:41:07', 'http://heroforzero.be/assets/img/quest/nutrition-streetkid.png', 36),
(13, 'General Health', 6, 5, 1, 40, '2014-07-16 02:47:30', 'http://heroforzero.be/assets/img/quest/training-sword.png', 32),
(14, 'Help Wie get treatment', 6, 5, 1, 40, '2014-07-16 02:45:38', 'http://heroforzero.be/assets/img/quest/health-sick.png', 15),
(15, 'Disease', 6, 5, 1, 50, '2014-07-16 02:46:52', 'http://heroforzero.be/assets/img/quest/training-sword.png', 16);

-- --------------------------------------------------------

--
-- Structure for view `leaderboard`
--
DROP TABLE IF EXISTS `leaderboard`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `leaderboard` AS select `a`.`UserId` AS `id`,`u`.`FullName` AS `name`,`u`.`AvatarId` AS `avatar`,`a`.`Points` AS `mark`,`a`.`FacebookId` AS `facebook_id`,`a`.`CurrentLevel` AS `current_level`,(1 + (select count(0) from `userapplication` `r` where ((`r`.`Points` > `a`.`Points`) or ((`r`.`Points` = `a`.`Points`) and (`r`.`UserId` < `a`.`UserId`))))) AS `rank` from (`userapplication` `a` join `user` `u`) where (`a`.`UserId` = `u`.`Id`) order by (1 + (select count(0) from `userapplication` `r` where ((`r`.`Points` > `a`.`Points`) or ((`r`.`Points` = `a`.`Points`) and (`r`.`UserId` < `a`.`UserId`)))));

-- --------------------------------------------------------

--
-- Structure for view `view_userinfo`
--
DROP TABLE IF EXISTS `view_userinfo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_userinfo` AS select `u`.`UserId` AS `uUserId`,`u`.`FacebookId` AS `uFacebookId`,`u`.`Points` AS `uPoints`,`u`.`CurrentLevel` AS `uCurrentLevel`,`v`.`Id` AS `vId`,`v`.`QuestName` AS `vQuestName`,`v`.`PacketId` AS `vPacketId`,`v`.`PartnerId` AS `vPartnerId`,`v`.`AnimationId` AS `vAnimationId`,`v`.`UnlockPoint` AS `vUnlockPoint`,`v`.`CreateDate` AS `vCreateDate`,`q`.`Status` AS `qStatus`,`c`.`Id` AS `cId`,`c`.`Type` AS `cType`,`c`.`Value` AS `cValue`,`c`.`VirtualQuestId` AS `cVirtualQuestId`,`c`.`ObjectId` AS `cObjectId` from (((`userapplication` `u` join `uservirtualquest` `q` on((`u`.`UserId` = `q`.`UserId`))) join `virtualquest` `v` on((`q`.`QuestId` = `v`.`Id`))) join `questcondition` `c` on((`c`.`VirtualQuestId` = `v`.`Id`)));

--
-- Indexes for dumped tables
--

--
-- Indexes for table `action`
--
ALTER TABLE `action`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `activity`
--
ALTER TABLE `activity`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `animation`
--
ALTER TABLE `animation`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `app_sessions`
--
ALTER TABLE `app_sessions`
 ADD PRIMARY KEY (`session_id`), ADD KEY `last_activity_idx` (`last_activity`);

--
-- Indexes for table `choice`
--
ALTER TABLE `choice`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `donation`
--
ALTER TABLE `donation`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `function`
--
ALTER TABLE `function`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medal`
--
ALTER TABLE `medal`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `organizationtype`
--
ALTER TABLE `organizationtype`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `packet`
--
ALTER TABLE `packet`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `partner`
--
ALTER TABLE `partner`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `partnerdonation`
--
ALTER TABLE `partnerdonation`
 ADD PRIMARY KEY (`DonationId`);

--
-- Indexes for table `partner_ext`
--
ALTER TABLE `partner_ext`
 ADD PRIMARY KEY (`partner_id`);

--
-- Indexes for table `player_avatar`
--
ALTER TABLE `player_avatar`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quest`
--
ALTER TABLE `quest`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questcondition`
--
ALTER TABLE `questcondition`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `quiz`
--
ALTER TABLE `quiz`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `quizcategory`
--
ALTER TABLE `quizcategory`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `reward`
--
ALTER TABLE `reward`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `rolefunction`
--
ALTER TABLE `rolefunction`
 ADD PRIMARY KEY (`RoleId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `userapplication`
--
ALTER TABLE `userapplication`
 ADD PRIMARY KEY (`UserId`);

--
-- Indexes for table `usercondition`
--
ALTER TABLE `usercondition`
 ADD PRIMARY KEY (`UserId`,`ConditionId`);

--
-- Indexes for table `usermedal`
--
ALTER TABLE `usermedal`
 ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `userpartner`
--
ALTER TABLE `userpartner`
 ADD PRIMARY KEY (`UserId`);

--
-- Indexes for table `userrole`
--
ALTER TABLE `userrole`
 ADD PRIMARY KEY (`UserId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users_groups`
--
ALTER TABLE `users_groups`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `uc_users_groups` (`user_id`,`group_id`), ADD KEY `fk_users_groups_users1_idx` (`user_id`), ADD KEY `fk_users_groups_groups1_idx` (`group_id`);

--
-- Indexes for table `uservirtualquest`
--
ALTER TABLE `uservirtualquest`
 ADD PRIMARY KEY (`UserId`,`QuestId`);

--
-- Indexes for table `virtualquest`
--
ALTER TABLE `virtualquest`
 ADD PRIMARY KEY (`Id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `action`
--
ALTER TABLE `action`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `activity`
--
ALTER TABLE `activity`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT for table `animation`
--
ALTER TABLE `animation`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `choice`
--
ALTER TABLE `choice`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1902;
--
-- AUTO_INCREMENT for table `donation`
--
ALTER TABLE `donation`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT for table `function`
--
ALTER TABLE `function`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `groups`
--
ALTER TABLE `groups`
MODIFY `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `medal`
--
ALTER TABLE `medal`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=37;
--
-- AUTO_INCREMENT for table `organizationtype`
--
ALTER TABLE `organizationtype`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `packet`
--
ALTER TABLE `packet`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `partner`
--
ALTER TABLE `partner`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=48;
--
-- AUTO_INCREMENT for table `partnerdonation`
--
ALTER TABLE `partnerdonation`
MODIFY `DonationId` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `player_avatar`
--
ALTER TABLE `player_avatar`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `quest`
--
ALTER TABLE `quest`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `questcondition`
--
ALTER TABLE `questcondition`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=753;
--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=501;
--
-- AUTO_INCREMENT for table `quizcategory`
--
ALTER TABLE `quizcategory`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `rolefunction`
--
ALTER TABLE `rolefunction`
MODIFY `RoleId` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=494;
--
-- AUTO_INCREMENT for table `usermedal`
--
ALTER TABLE `usermedal`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=454;
--
-- AUTO_INCREMENT for table `userpartner`
--
ALTER TABLE `userpartner`
MODIFY `UserId` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=494;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `users_groups`
--
ALTER TABLE `users_groups`
MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `virtualquest`
--
ALTER TABLE `virtualquest`
MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `users_groups`
--
ALTER TABLE `users_groups`
ADD CONSTRAINT `fk_users_groups_groups1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_users_groups_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

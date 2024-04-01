--[[
键★断片 - 库特莉亚芙卡 〔异国风情（自称）般的吉祥物〕
==【K.E.Y Fragments - Kudryavka 〔Exotic (self-proclaimed) Mascot〕】==
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_KEYFRAGMENT_LOADED then
	GLITCHYLIB_KEYFRAGMENT_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
Duel.LoadScript("glitchylib_helper.lua")
function s.initial_effect(c)
	STICKERS_TABLE[STICKER_EXOTIC_SELF_PROCLAIMED_MASCOT] 	= {id,0}
	STICKERS_TABLE[STICKER_LOST_TO_KUD] 					= {id,6}
	aux.SpawnGlitchyHelper(GLITCHY_HELPER_STICKER_FLAG)
	aux.RegisterKeyFragmentStickerQE(c,100,STICKER_EXOTIC_SELF_PROCLAIMED_MASCOT)
	aux.RegisterKeyFragmentStickerContinuous(c,id,STICKER_EXOTIC_SELF_PROCLAIMED_MASCOT,STICKER_LOST_TO_KUD)
	
	--[[A monster with this sticker gains the following effect.
	● You can Tribute this card; Special Summon 1 "Strelka Token" (FIRE/Beast/Level 4/ATK 1800/DEF 1200) and 1 "Belka Token" (FIRE/Beast/Level 4/ATK 1200/DEF 1800).
	These Tokens cannot be used as material for the Special Summon of a monster from the Extra Deck, except of "K.E.Y" monsters.]]
	aux.RegisterStickerEffect(STICKER_EXOTIC_SELF_PROCLAIMED_MASCOT,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORIES_TOKEN)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCost(aux.TributeSelfCost)
		e1:SetTarget(s.sptg)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1
	end
	)
	
	--[[A card with this Sticker gains the following effects.
	● All monsters you control must attack Tokens, if able.
	● During the Battle Phase, if your opponent does not control a Token: They can activate this effect; they Special Summon 1 "Strelka Token" (FIRE/Beast/Level 4/ATK 1800/DEF 1200)
	or 1 "Belka Token" (FIRE/Beast/Level 4/ATK 1200/DEF 1800). These Tokens cannot be used as material for the Special Summon of a monster from the Extra Deck, except of "K.E.Y" monsters.]]
	aux.RegisterStickerEffect(STICKER_LOST_TO_KUD,function(owner)
		local e1=Effect.CreateEffect(owner)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetCondition(s.forcecon)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		local e1x=e1:Clone()
		e1x:SetCode(EFFECT_MUST_ATTACK_MONSTER)
		e1x:SetTargetRange(LOCATION_MZONE,0)
		e1x:SetValue(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
		local e2=Effect.CreateEffect(owner)
		e2:SetDescription(aux.Stringid(id,6))
		e2:SetCategory(CATEGORIES_TOKEN)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetProperty(EFFECT_FLAG_BOTH_SIDE|EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_ONFIELD)
		e2:SetCondition(s.discon)
		e2:SetTarget(s.distg)
		e2:SetOperation(s.disop)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		return e1,e1x,e2
	end
	)
end

--E1
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return false end
		local exc=nil
		if e:IsCostChecked() then
			exc=e:GetHandler()
		end
		return Duel.GetMZoneCount(tp,exc)>=2 and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_STRELKA,0,TYPES_TOKEN_MONSTER,1800,1200,4,RACE_BEAST,ATTRIBUTE_FIRE)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_BELKA,0,TYPES_TOKEN_MONSTER,1200,1800,4,RACE_BEAST,ATTRIBUTE_FIRE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetMZoneCount(tp)>=2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_STRELKA,0,TYPES_TOKEN_MONSTER,1800,1200,4,RACE_BEAST,ATTRIBUTE_FIRE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_BELKA,0,TYPES_TOKEN_MONSTER,1200,1800,4,RACE_BEAST,ATTRIBUTE_FIRE) then
		local c=e:GetHandler()
		local codes={TOKEN_STRELKA,TOKEN_BELKA}
		for _,code in ipairs(codes) do
			local token=Duel.CreateToken(tp,code)
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
				aux.CannotBeEDMaterial(token,s.matlim,nil,false,RESET_EVENT|RESETS_STANDARD,c,nil,false,true)
			end
		end
		Duel.SpecialSummonComplete()
	end
end
function s.matlim(c)
	return c:IsSetCard(ARCHE_KEY)
end

--E2
function s.atklimit(e,c)
	return c:IsType(TYPE_TOKEN)
end
function s.forcecon(e)
	return Duel.IsExists(false,Card.IsType,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,TYPE_TOKEN)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==1-e:GetHandlerPlayer() and Duel.IsBattlePhase() and Duel.GetCurrentChain()==0 and not Duel.IsExists(false,Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMZoneCount(tp)>0
			and (Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_STRELKA,0,TYPES_TOKEN_MONSTER,1800,1200,4,RACE_BEAST,ATTRIBUTE_FIRE)
			or Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_BELKA,0,TYPES_TOKEN_MONSTER,1200,1800,4,RACE_BEAST,ATTRIBUTE_FIRE))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		local codes={}
		if Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_STRELKA,0,TYPES_TOKEN_MONSTER,1800,1200,4,RACE_BEAST,ATTRIBUTE_FIRE) then
			table.insert(codes,TOKEN_STRELKA)
		end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_BELKA,0,TYPES_TOKEN_MONSTER,1200,1800,4,RACE_BEAST,ATTRIBUTE_FIRE) then
			table.insert(codes,TOKEN_BELKA)
		end
		if #codes>0 then
			local c=e:GetHandler()
			local g=Group.CreateGroup()
			for _,code in ipairs(codes) do
				g:AddCard(Duel.CreateToken(tp,code))
			end
			if #g==0 then return end
			Duel.HintMessage(tp,HINTMSG_SPSUMMON)
			local token=#g==1 and g:GetFirst() or g:Select(tp,1,1,nil):GetFirst()
			g:RemoveCard(token)
			if #g>0 then
				Duel.Exile(g:GetFirst(),REASON_RULE)
			end
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
				aux.CannotBeEDMaterial(token,s.matlim,nil,false,RESET_EVENT|RESETS_STANDARD,c,nil,false,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
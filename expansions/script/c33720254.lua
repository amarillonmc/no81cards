--[[
黄金的GUARDIAN
The Golden GUARDIAN
Card Author: nemoma
Scripted by: XGlitchy30
]]
local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	--[[When this card is Link Summoned to an Extra Monster Zone: You can Special Summon up to 2 "Golden Sauryman Token" (WATER/Fish/Level 4/ATK 2000 DEF 2000)
	to your Main Monster Zones this card points to]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e1)
	--[[Once per turn: You can destroy any number of cards you control, and if you do, destroy the same number of cards your opponent controls,
	and if you do that, Special Summon the same number of "Golden Sauryman Tokens" to both players' fields.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_DESTROY|CATEGORIES_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:OPT()
	e2:SetFunctions(nil,nil,s.destg,s.desop)
	c:RegisterEffect(e2)
	--Gains 500 ATK for each "Golden Sauryman Token" on the field.
	c:UpdateATK(aux.ForEach(s.atkfilter,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,500))
	--Your opponent takes no battle damage, except from battles involving Tokens.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN)))
	c:RegisterEffect(e3)
end
--E1
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSequence()>4
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_GOLDEN_SAURYMAN,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local zone=c:GetLinkedZone(tp)&0x1f
	if zone==0 then return end
	
	for i=1,2 do
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_GOLDEN_SAURYMAN,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER)
			or (i>1 and (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not Duel.SelectYesNo(tp,aux.Stringid(id,1)))) then
			break
		end
		local token=Duel.CreateToken(tp,TOKEN_GOLDEN_SAURYMAN)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone) then
			aux.CannotBeTributeOrMaterial(token,true,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE)
		end
	end
	Duel.SpecialSummonComplete()
end

--E2
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1,g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0),Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then
		return #g1>0 and #g2>0
			and Duel.GetMZoneCount(tp,g1)>0 and Duel.GetMZoneCount(1-tp,g2,tp)>0
			and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_GOLDEN_SAURYMAN,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_GOLDEN_SAURYMAN,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP,1-tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1+g2,2,PLAYER_ALL,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.gcheck1(g2,check)
	return	function(g1,e,tp,mg1,c)
				local ft=Duel.GetMZoneCount(tp,g1)
				if c and ft<#g1 then
					return false,true
				end
				return not check or aux.SelectUnselectGroup(g2,e,tp,#g1,#g1,s.gcheck2,0)
			end
end
function s.gcheck2(g2,e,tp,mg2,c)
	local ft=Duel.GetMZoneCount(1-tp,g2,tp)
	if c and ft<#g2 then
		return false,true
	end
	return true
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1,g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0),Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g1==0 then return end
	local sg1
	if #g2<=0 then
		Duel.HintMessage(tp,HINTMSG_DESTROY)
		sg1=g1:Select(tp,1,#g1,nil)
	else
		local maxc=math.min(#g1,#g2)
		sg1=aux.SelectUnselectGroup(g1,e,tp,1,maxc,s.gcheck1(g2,true),1,tp,HINTMSG_DESTROY)
		if #sg1==0 then
			sg1=aux.SelectUnselectGroup(g1,e,tp,1,maxc,s.gcheck1(g2,false),1,tp,HINTMSG_DESTROY)
		end
	end
	if #sg1==0 then return end
	Duel.HintSelection(sg1)
	local ct1=Duel.Destroy(sg1,REASON_EFFECT)
	if ct1==0 then return end
	g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local sg2=aux.SelectUnselectGroup(g2,e,tp,ct1,ct1,s.gcheck2,1,tp,HINTMSG_DESTROY)
	if #sg2==0 then
		Duel.HintMessage(tp,HINTMSG_DESTROY)
		sg2=g2:Select(tp,ct1,ct1,nil)
		if #sg2==0 then return end
	end
	Duel.HintSelection(sg2)
	local ct2=Duel.Destroy(sg2,REASON_EFFECT)
	if ct2>0 and Duel.GetMZoneCount(tp)>=ct2 and Duel.GetMZoneCount(1-tp,nil,tp)>=ct2 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_GOLDEN_SAURYMAN,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_GOLDEN_SAURYMAN,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FISH,ATTRIBUTE_WATER,POS_FACEUP,1-tp) then
		for p in aux.TurnPlayers() do
			for i=1,ct2 do
				local token=Duel.CreateToken(tp,TOKEN_GOLDEN_SAURYMAN)
				if Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP) then
					aux.CannotBeTributeOrMaterial(token,true,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE)
				end
			end
		end
		Duel.SpecialSummonComplete()
	end
end

--E3
function s.atkfilter(c)
	return c:IsFaceup() and c:IsCode(TOKEN_GOLDEN_SAURYMAN)
end
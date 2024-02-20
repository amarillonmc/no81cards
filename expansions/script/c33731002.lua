--[[
动物朋友调谐
Harmonized Anifriends
Aniamici Armonizzati
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
function s.initial_effect(c)
	Duel.LoadScript("glitchylib_vsnemo.lua")
	--[[Apply 1 of the following effects:
	● Send from your hand to the GY, any number of "Anifriends" monster(s), and if you do, Special Summon 1 "Anifriends" Synchro Monster from your Extra Deck, whose Level equals the total Levels the sent monsters had in the hand.
	● Send 2 "Anifriends" monsters with the same Level from your hand to the GY, and if you do, Special Summon 1 "Anifriends" Xyz Monster from your Extra Deck, and if you do that, attach the sent monsters from the GY to that monster as material.
	● If your opponent controls a monster, send cards from your Deck to the GY, up to the number of monster your opponent controls.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOGRAVE|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_MAIN_END|TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--If you control no cards, you can activate this card from your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
--E1
function s.filter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:HasLevel()
end
function s.synfilter(c,e,tp,lv)
	return c:IsSetCard(0x442) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.syncheck(ct)
	return	function(g,e,tp)
				local res=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=ct
				return res and Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g:GetSum(Card.GetLevel)), not res
			end
end
function s.xyzfilter(c,e,tp)
	return c:IsSetCard(0x442) and c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xyzcheck(ct)
	return	function(g)
				local res=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=ct and g:GetClassCount(Card.GetLevel)==1
				return res, not res
			end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local loc=ct>0 and LOCATION_DECK|LOCATION_HAND or LOCATION_HAND
	local g=Duel.GetMatchingGroup(s.filter,tp,loc,0,nil)
	local b1=aux.SelectUnselectGroup(g,e,tp,1,#g,s.syncheck(ct),0)
	local b2=aux.SelectUnselectGroup(g,e,tp,2,2,s.xyzcheck(ct),0) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then
		return b1 or b2
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local loc=ct>0 and LOCATION_DECK|LOCATION_HAND or LOCATION_HAND
	local g=Duel.GetMatchingGroup(s.filter,tp,loc,0,nil)
	local b1=aux.SelectUnselectGroup(g,e,tp,1,#g,s.syncheck(ct),0)
	local b2=aux.SelectUnselectGroup(g,e,tp,2,2,s.xyzcheck(ct),0) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,id,2,b1,b2)
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=aux.SelectUnselectGroup(g,e,tp,1,#g,s.syncheck(ct),1,tp,HINTMSG_REMOVE,nil,nil,false)
		if #tg>0 then
			local lv=tg:GetSum(Card.GetLevel)
			if Duel.SendtoGrave(tg,REASON_EFFECT)>0 and tg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,s.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	
	elseif opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=aux.SelectUnselectGroup(g,e,tp,2,2,s.xyzcheck(ct),1,tp,HINTMSG_REMOVE,nil,nil,false)
		if #tg>0 then
			if Duel.SendtoGrave(tg,REASON_EFFECT)==2 then
				local gg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				if #gg==2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tc=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
					if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsType(TYPE_XYZ) then
						local og=gg:Filter(aux.Necro(Card.IsCanOverlay),nil,tp)
						if #og>0 then
							Duel.Attach(og,tc)
						end
					end
				end
			end
		end
	end
end

--E2
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
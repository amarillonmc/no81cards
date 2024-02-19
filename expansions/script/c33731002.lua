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
function s.syncheck(g,e,tp)
	return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g:GetSum(Card.GetLevel))
end
function s.xyzfilter(c,e,tp)
	return c:IsSetCard(0x442) and c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function s.tgfilter(c)
	return c:IsSetCard(0x442) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local b1=g:CheckSubGroup(s.syncheck,1,#g,e,tp)
	local b2=g:CheckSubGroup(s.xyzcheck,2,2) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=ct>0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then
		return b1 or b2 or b3
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local b1=g:CheckSubGroup(s.syncheck,1,#g,e,tp)
	local b2=g:CheckSubGroup(s.xyzcheck,2,2) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=ct>0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	if not b1 and not b2 and not b3 then return end
	local opt=aux.Option(tp,id,2,b1,b2,b3)
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:SelectSubGroup(tp,s.syncheck,false,1,#g,e,tp)
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
		local tg=g:SelectSubGroup(tp,s.xyzcheck,false,2,2)
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
	
	elseif opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,ct,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

--E2
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
--[[
键★高潮 遥远彼方
K.E.Y Climax - Faraway
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
	--[[When this effect resolves, if you control no FIRE "K.E.Y" monsters, Special Summon 1 "K.E.Y Fragments - Riki" or "K.E.Y Fragments - Rin" from your Deck or GY.
	Also, banish, from your GY, any number (min. 5) of FIRE "K.E.Y Fragments" monsters with different names and with an effect that places exactly 1 Sticker on themselves when Summoned, and if you do, place those Stickers on 1 FIRE "K.E.Y" monster you control, then take 1000 damage for each card banished by this effect.
	If exactly 10 monsters were banished by this effect, send all cards your opponent controls and in their hand to the GY instead of taking damage, also send an equal number of cards from the top of their Deck to the GY.  ]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_REMOVE|CATEGORY_TOGRAVE|CATEGORY_DECKDES|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

--E1
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.spfilter(c,e,tp)
	return c:IsCode(CARD_KEY_FRAGMENTS_RIKI,CARD_KEY_FRAGMENTS_RIN) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rmfilter(c)
	return c:IsSetCard(ARCHE_KEY) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsHasEffect(33730147)
end
function s.rescon(check)
	local loc=check and LOCATION_MZONE or LOCATION_MZONE|LOCATION_DECK|LOCATION_GRAVE
	return	function(g,e,tp,mg,c)
				local ce=c:IsHasEffect(33730147)
				local sticker=ce:GetValue()
				local res=g:GetClassCount(Card.GetCode)==#g and Duel.IsExists(false,s.skfilter,tp,loc,0,1,g,sticker,e,tp)
				return res, not res
			end
end
function s.skfilter(c,sticker,e,tp)
	return s.cfilter(c) and c:IsCanAddSticker(sticker,1,e,tp,REASON_EFFECT)
end
function s.skfilter_total(c,stickers,e,tp)
	if not s.cfilter(c) then return false end
	for _,sticker in ipairs(stickers) do
		if not c:IsCanAddSticker(sticker,1,e,tp,REASON_EFFECT) then
			return false
		end
	end
	return true
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExists(false,s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		local g=Duel.Group(s.rmfilter,tp,LOCATION_GRAVE,0,nil)
		return (check or (Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.spfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp)))
			and aux.SelectUnselectGroup(g,e,tp,5,#g,s.rescon(check),0)
	end
	if Duel.IsExists(false,s.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,5000)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD|LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExists(false,s.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetMZoneCount(tp)>0 then
		local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local g=Duel.Group(aux.Necro(s.rmfilter),tp,LOCATION_GRAVE,0,nil)
	local rg=aux.SelectUnselectGroup(g,e,tp,5,#g,s.rescon(true),1,tp,HINTMSG_REMOVE,s.finishcon,false,false)
	if #rg>0 then
		Duel.HintSelection(rg)
		local ct=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		if ct>0 then
			local stickers={}
			local og=Duel.GetOperatedGroup()
			for tc in aux.Next(og) do
				local ce=tc:IsHasEffect(33730147)
				if ce then
					local sticker=ce:GetValue()
					table.insert(stickers,sticker)
				end
			end
			local tc=Duel.Select(HINTMSG_OPERATECARD,false,tp,s.skfilter_total,tp,LOCATION_MZONE,0,1,1,nil,stickers,e,tp):GetFirst()
			if tc then
				Duel.HintSelection(Group.FromCards(tc))
				for _,sticker in ipairs(stickers) do
					tc:AddSticker(sticker,1,e,tp,REASON_EFFECT,true)
				end
				if tc:AddStickerComplete()>0 then
					if ct~=10 then
						Duel.BreakEffect()
						Duel.Damage(tp,ct*1000,REASON_EFFECT)
					else
						local tg=Duel.Group(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD|LOCATION_HAND,nil)
						if #tg>0 then
							Duel.BreakEffect()
							local ct2=Duel.SendtoGrave(tg,REASON_EFFECT)
							if ct2>0 then
								Duel.DiscardDeck(1-tp,ct2,REASON_EFFECT)
							end
						end
					end
				end
			end
		end
	end
end
function s.finishcon(g,e,tp,mg)
	local stickers={}
	for tc in aux.Next(g) do
		local ce=tc:IsHasEffect(33730147)
		if ce then
			local sticker=ce:GetValue()
			table.insert(stickers,sticker)
		end
	end
	local res=g:GetClassCount(Card.GetCode)==#g and Duel.IsExists(false,s.skfilter_total,tp,LOCATION_MZONE,0,1,g,stickers,e,tp)
	return res
end
--[[
秘密结社337的猛拳，乔纳森
Jonathan, Fist of MYTH-337
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[When this card is Summoned: You can look at your opponent's Extra Deck, then you can add 1 card from your Extra Deck to their Extra Deck, and if you do that, send 1 other card from their Extra
	Deck to the GY]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOEXTRA|CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	e1:FlipSummonEventClone(c)
	--[[If this card is destroyed by your opponent: You can Special Summon 1 "MYTH-337, K.U.N.G.F.U." from your hand or Deck (this is treated as a Ritual Summon).]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e2)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetExtraDeckCount(1-tp)>0 
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_EXTRA,1-tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetExtraDeck(1-tp)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		if Duel.IsExists(false,Card.IsAbleToExtra,tp,LOCATION_EXTRA,0,1,nil) and g:IsExists(Card.IsAbleToGrave,1,nil) and Duel.SelectYesNo(tp,STRING_ASK_TO_EXTRA) then
			local tc=Duel.Select(HINTMSG_TOEXTRA,false,tp,Card.IsAbleToExtra,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
			if tc then
				local ct=0
				Duel.BreakEffect()
				Duel.Exile(tc,REASON_RULE)
				if tc:IsFaceup() and tc:IsType(TYPE_PENDULUM) then
					ct=Duel.SendtoExtraP(tc,1-tp,REASON_EFFECT)
				else
					ct=Duel.SendtoDeck(tc,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
				end
				if ct>0 and tc:IsLocation(LOCATION_EXTRA) and tc:IsControler(1-tp) then
					local tg=Duel.Select(HINTMSG_TOGRAVE,false,tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,1,tc)
					if #tg>0 then
						Duel.SendtoGrave(tg,REASON_EFFECT)
					end
				end
			end
		end
	end	
end

--E2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.spfilter(c,e,tp)
	return c:IsMonster(TYPE_RITUAL) and c:IsCode(id+1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
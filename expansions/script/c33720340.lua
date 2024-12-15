--[[
秘密结社337的俊足，埃德蒙德
Edmund, Leg of MYTH-337
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[When this card is Summoned: You can banish 1 card from either player's GY, and if you do, you can place 1 card from that player's GY to the bottom of their Deck]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	e1:FlipSummonEventClone(c)
	--[[If this card is destroyed by your opponent: You can Special Summon 1 "MYTH-337, B.U.T.T.E.R.F.L.Y." from your hand or Deck (this is treated as a Ritual Summon).]]
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
		return Duel.IsExists(false,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Select(HINTMSG_REMOVE,false,tp,aux.Necro(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local p=g:GetFirst():GetControler()
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsExists(false,Card.IsAbleToDeck,p,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,STRING_ASK_TO_DECK) then
			local tg=Duel.Select(HINTMSG_TODECK,false,tp,aux.Necro(Card.IsAbleToDeck),p,LOCATION_GRAVE,0,1,1,nil)
			if #tg>0 then
				Duel.HintSelection(tg)
				Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
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
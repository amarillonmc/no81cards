--[[
晦空士 ～逃亡的红流～
Sepialife - Runaway On Red
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--During the End Phase, if you control a "Sepialife" monster while this card is in your hand or GY: Discard 1 card from your hand; excavate a number of cards from your and your opponent's top of the Deck, equal to the number of "Sepialife" monsters with different names you control, and apply the following effects (simultaneously).
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:OPT()
	e1:SetFunctions(s.condition,aux.DiscardCost(),s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_SEPIALIFE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExists(false,s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.cfilter,tp,LOCATION_MZONE,0,nil)
		local ct=g:GetClassCount(Card.GetCode)
		return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function s.tdfilter(c)
	return c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToDeck()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(ARCHE_SEPIALIFE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if not (ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct) then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,ct)
	Duel.ConfirmDecktop(1-tp,ct)
	Duel.DisableShuffleCheck(true)
	local self,o=Duel.GetDecktopGroup(tp,ct),Duel.GetDecktopGroup(1-tp,ct)
	if o:IsExists(Card.IsSetCard,1,nil,ARCHE_SEPIALIFE) and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,aux.Necro(s.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local tc=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if self:IsExists(s.tdfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local tg=self:Filter(s.tdfilter,nil)
		for tc in aux.Next(o) do
			tc:RegisterFlagEffect(id,RESET_CHAIN,0,1,tc:GetSequence())
		end
		if Duel.SendtoDeck(tg,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT|REASON_EXCAVATE)>0 then
			Duel.ShuffleDeck(1-tp)
			local og=Duel.GetOperatedGroup():Filter(aux.PLChk,nil,1-tp,LOCATION_DECK)
			self:Sub(og)
		end
	end
	for i=1,#self do
		local tc=self:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,SEQ_DECKTOP)
	end
	for i=1,#o do
		local tc=o:GetMinGroup(Card.GetFlagEffectLabel,id):GetFirst()
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		tc:ResetFlagEffect(id)
		o:RemoveCard(tc)
	end
end
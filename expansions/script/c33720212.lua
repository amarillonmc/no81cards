--[[
晦空士 ～返血的蓝怨～
Sepialife - Blood On Blue
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--During the End Phase, if you did not activate a non-"Sepialife" card effect this turn: You can reveal this card in your hand; excavate a number of cards from your and your opponent's top of the Deck, equal to the number of "Sepialife" cards you control, and apply the following effects (simultaneously).
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:OPT()
	e1:SetFunctions(s.condition,aux.RevealSelfCost(),s.target,s.operation)
	c:RegisterEffect(e1)
	aux.RegisterTriggeringArchetypeCheck(c,ARCHE_SEPIALIFE)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.CheckArchetypeReasonEffect(s,re,ARCHE_SEPIALIFE) then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE|PHASE_END,0,1)
	end
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.PlayerHasFlagEffect(tp,id)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,ARCHE_SEPIALIFE),tp,LOCATION_ONFIELD,0,nil)
		return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function s.tdfilter(c)
	return c:IsSetCard(ARCHE_SEPIALIFE) and c:IsAbleToDeck()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,ARCHE_SEPIALIFE),tp,LOCATION_ONFIELD,0,nil)
	if not (ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct) then return end
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,ct)
	Duel.ConfirmDecktop(1-tp,ct)
	Duel.DisableShuffleCheck(true)
	local self,o=Duel.GetDecktopGroup(tp,ct),Duel.GetDecktopGroup(1-tp,ct)
	if o:IsExists(Card.IsSetCard,1,nil,ARCHE_SEPIALIFE) and c:IsRelateToChain() and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
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
		local tc=self:GetMaxGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
	end
	for i=1,#o do
		local tc=o:GetMaxGroup(Card.GetFlagEffectLabel,id):GetFirst()
		Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		tc:ResetFlagEffect(id)
		o:RemoveCard(tc)
	end
end
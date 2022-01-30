-- 迷魂汤 卷之章 / Confusione Totale - Sovrasforzo -
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,0)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()==tp and (Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))>=20
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 or (Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))<20 then return end
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.DisableShuffleCheck()
	if Duel.SendtoDeck(g,1-tp,SEQ_DECKTOP,REASON_EFFECT)>0 then
		local ct=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK):FilterCount(Card.IsControler,nil,1-tp)
		local sg=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if sg<0 then sg=0 end
		Duel.SetLP(1-tp,sg*200)
	end
end
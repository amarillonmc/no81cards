--DEchoes #A3 - Narrative
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	DEchoes.AddTechCounterPermit(c)
	DEchoes.AddHandKernelProc(c,id,2)
	DEchoes.AddBattleTrigger(c,aux.Stringid(id,0),CATEGORY_TODECK,s.tdtg,s.tdop)
end
function s.tdfilter(c)
	return c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,math.min(5,#g),nil)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
	local ct0=sg:FilterCount(Card.IsControler,nil,0)
	local ct1=sg:FilterCount(Card.IsControler,nil,1)
	if ct0>1 then Duel.SortDecktop(tp,0,ct0) end
	if ct1>1 then Duel.SortDecktop(tp,1,ct1) end
end

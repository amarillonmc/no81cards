local m=53796010
local cm=_G["c"..m]
cm.name="直触"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil,1-tp) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local d2=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #d1==0 or #d2==0 then return end
	Duel.ConfirmCards(tp,d2)
	Duel.ConfirmCards(1-tp,d1)
	d1,d2=d1:Filter(Card.IsAbleToHand,nil,1-tp),d2:Filter(Card.IsAbleToHand,nil,tp)
	local g1,g2=Group.CreateGroup(),Group.CreateGroup()
	for tc in aux.Next(d1) do
		local g=d2:Filter(Card.IsCode,nil,tc:GetCode())
		if #g>0 then
			g1:AddCard(tc)
			g2:Merge(g)
		end
	end
	local b1,b2=#g1>0,#g2>0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0)) elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local tg1=g1:SelectSubGroup(tp,aux.dncheck,false,1,g1:GetClassCount(Card.GetCode))
		Duel.SendtoDeck(tg1,1-tp,2,REASON_EFFECT)
	else
		local tg2=Group.CreateGroup()
		for gc in aux.Next(g2) do if not tg2:IsExists(Card.IsCode,1,nil,gc:GetCode()) then tg2:AddCard(gc) end end
		Duel.SendtoDeck(tg2,tp,2,REASON_EFFECT)
	end
end

--世代碾替
local m=33701375
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_REVERSE_DECK)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
		if rg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end
		local tg=Duel.GetFieldGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0)
		if tg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,tg:GetCount(),REASON_EFFECT)
		end
		tg=tg:Filter(Card.IsAbleToDeck,nil)
		if tg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SortDecktop(tp,tp,tg:GetCount())
			for i=1,tg:GetCount() do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
		end
	else
		Duel.Recover(tp,4000,REASON_EFFECT,true)
		Duel.Recover(1-tp,4000,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end

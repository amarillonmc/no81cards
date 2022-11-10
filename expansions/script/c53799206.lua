local m=53799206
local cm=_G["c"..m]
cm.name="Web"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetTurnPlayer()==tp and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)end)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetFlagEffect(0,m)==0 then
		Duel.BreakEffect()
		Duel.RegisterFlagEffect(0,m,0,0,0)
		Duel.Hint(HINT_CARD,0,m)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetOperation(cm.regop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m+333,0,0,0)
	if Duel.GetFlagEffect(0,m+333)%5==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		if #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			local sg=g:RandomSelect(rp,1)
			if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 and Duel.GetFlagEffect(0,m+666)==0 then
				Duel.RegisterFlagEffect(0,m+666,RESET_CHAIN,0,0)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_END)
				e1:SetOperation(cm.sovop)
				e1:SetLabel(1-rp)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function cm.sovop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
	e:Reset()
end

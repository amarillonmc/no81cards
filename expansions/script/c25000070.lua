local m=25000070
local cm=_G["c"..m]
cm.name="蜂之武藏慷慨就义"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	if not cm.Bees_Musahashi_Dead then
		cm.Bees_Musahashi_Dead=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.cfilter(c)
	return rp~=c:GetPreviousControler()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,rp) then Duel.RegisterFlagEffect(1-rp,m,RESET_PHASE+PHASE_END,0,1) end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)==0 then return false end
	local ph=Duel.GetCurrentPhase()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 and e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=sg:Select(tp,1,1,nil)
	sg:RemoveCard(hg:GetFirst())
	sg=sg:Filter(Card.IsCode,nil,hg:GetFirst():GetCode())
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=sg:Select(tp,1,2,nil)
		hg:Merge(tg)
	end
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
end

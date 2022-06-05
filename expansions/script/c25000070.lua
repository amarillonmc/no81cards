local m=25000070
local cm=_G["c"..m]
cm.name="蜂之武藏慷慨就义"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,m)
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
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m)==0 then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
	if Duel.GetFlagEffect(1,m)==0 then Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1) end
	for tc in aux.Next(eg) do
		local p1,p2,p3=tc:GetControler(),tc:GetPreviousControler(),tc:GetReasonPlayer()
		if p2~=p3 and p1==p2 then
			local flag=Duel.GetFlagEffectLabel(p1,m)
			Duel.SetFlagEffectLabel(p1,m,flag|(tc:GetPreviousTypeOnField()&0x7))
		end
	end
end
function cm.filter(c,flag)
	return c:IsType(flag) and c:IsAbleToHand()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)==0 then return false end
	local ph=Duel.GetCurrentPhase()
	local flag=Duel.GetFlagEffectLabel(tp,m)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>3 and e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,flag) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
	local flag=Duel.GetFlagEffectLabel(tp,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,flag):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

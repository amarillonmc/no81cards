--大陆的使者
local m=33711902
local cm=_G["c"..m]
function cm.initial_effect(c)
   --
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3442)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and (g:GetClassCount(Card.GetCode)>=15 or g2:CheckSubGroup(aux.dncheck,5))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
	   e1:SetCondition(cm.spcon2)
	   e1:SetLabel(Duel.GetTurnCount())
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.spfilter(c)
	local code=c:GetOriginalCode()
	return c:IsSetCard(0x3442) and c:IsAbleToHand()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)>0 and tc:IsAbleToHand() then
		sg:AddCard(tc)
	end
	sg:Merge(g)
	return Duel.GetTurnCount()>e:GetLabel() and Duel.GetTurnPlayer()==tp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rg=g:SelectSubGroup(tp,aux.dncheck,false,5,5,nil)
		Duel.SendtoHand(rg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
	end
	e:Reset()
end
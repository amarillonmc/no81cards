local m=11110109
local cm=_G["c"..m]
cm.name="Vesta, Royal Knight of Ichyaltas"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.dspcon)
	e1:SetOperation(cm.dspop)
	e1:SetValue(1)
	e1:SetCountLimit(1,m)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetTarget(cm.rltg)
	e3:SetOperation(cm.rlop)
	e3:SetCountLimit(1,m+100000000)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsReleasable() and c:IsSetCard(0x6313) and not c:IsCode(m)
end
function cm.dspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(e:GetHandlerPlayer(),cm.cfilter,1,nil)
end
function cm.dspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x6313) and c:IsAbleToHand()
end
function cm.rltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.rlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
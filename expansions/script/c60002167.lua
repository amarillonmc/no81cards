--肃清之器 梅希亚
local m=60002167
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x9620)
	aux.AddLinkProcedure(c,cm.matfilter,2)
	c:EnableReviveLimit()
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.incon)
	e3:SetValue(cm.attackup)
	c:RegisterEffect(e3)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x9620)>=1
end
function cm.attackup(e,c)
	local atkup=(Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)*200)+(Duel.GetFlagEffect(tp,60002148)*400)+(Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)*800)
	if Duel.GetTurnCount()>=8 then
		atkup=atkup+(Duel.GetTurnCount()-8)*10000
	end
	return atkup
end
function cm.matfilter(c)
	return c:IsCanHaveCounter(0x9620) and Duel.IsCanAddCounter(tp,0x9620,1,c)
end
function cm.thfilter(c,tp)
	return c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c63288573.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if Card.IsCanHaveCounter(tc,0x9620) and e:GetHandler():IsRelateToEffect(e) then
			e:GetHandler():AddCounter(0x9620,1)
			Duel.RegisterFlagEffect(tp,60002148,RESET_PHASE+PHASE_END,0,1000)
		end
	end
end















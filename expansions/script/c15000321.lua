local m=15000321
local cm=_G["c"..m]
cm.name="内核危害 奥尔特"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_TO_GRAVE)  
	e1:SetCountLimit(1,15000321)  
	e1:SetCondition(cm.spcon)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetCondition(cm.spcon2)  
	c:RegisterEffect(e2)
	--remove overlay replace  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)  
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15010321)  
	e3:SetCondition(cm.rcon)  
	e3:SetOperation(cm.rop)  
	c:RegisterEffect(e3)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():IsReason(REASON_COST) and (re:GetHandler():IsSetCard(0xf39) or (re:GetHandler():IsRace(RACE_FIEND) and re:GetHandler():IsAttribute(ATTRIBUTE_DARK) and re:GetHandler():IsType(TYPE_MONSTER)))
end  
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()  
	return (e:GetHandler():IsReason(REASON_BATTLE) or e:GetHandler():IsReason(REASON_EFFECT)) and Duel.IsPlayerAffectedByEffect(tp,15000330)  
end
function cm.spfilter(c)  
	return c:IsAbleToGrave()
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()  
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and cm.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,1-tp,LOCATION_ONFIELD)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandler():GetControler()  
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then  
		Duel.SendtoGrave(tc,REASON_EFFECT) 
	end  
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)  
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer() and re:GetHandler():IsSetCard(0xf39)
end  
function cm.rop(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end
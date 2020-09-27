local m=82228628
local cm=_G["c"..m]
cm.name="孑影之棺椁"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1) 
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetCode(EVENT_LEAVE_FIELD_P)  
	e2:SetOperation(cm.checkop)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e3:SetCode(EVENT_LEAVE_FIELD)  
	e3:SetOperation(cm.desop)  
	e3:SetLabelObject(e2)  
	c:RegisterEffect(e3)  
	--Atk up  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_EQUIP)  
	e4:SetCode(EFFECT_UPDATE_ATTACK)  
	e4:SetValue(500)  
	c:RegisterEffect(e4)
	--attack all  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_EQUIP)  
	e5:SetCode(EFFECT_ATTACK_ALL)  
	e5:SetValue(1)  
	c:RegisterEffect(e5) 
	--to hand  
	local e6=Effect.CreateEffect(c)  
	e6:SetCategory(CATEGORY_TOHAND)  
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e6:SetCode(EVENT_TO_GRAVE)  
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.thcon)  
	e6:SetTarget(cm.thtg)  
	e6:SetOperation(cm.thop)  
	c:RegisterEffect(e6 )  
end
function cm.filter(c,e,tp)  
	return c:IsSetCard(0x3299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then  
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end  
		Duel.Equip(tp,c,tc)  
		--Add Equip limit  
		local e1=Effect.CreateEffect(tc)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_EQUIP_LIMIT)  
		e1:SetValue(cm.eqlimit)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.eqlimit(e,c)  
	return e:GetOwner()==c  
end  
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsDisabled() then  
		e:SetLabel(1)  
	else e:SetLabel(0) end  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetLabelObject():GetLabel()~=0 then return end  
	local tc=e:GetHandler():GetFirstCardTarget()  
	if tc and tc:IsLocation(LOCATION_MZONE) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  
function cm.thfilter(c)  
	return  (c:IsCode(82204200) or aux.IsCodeListed(c,82204200)) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x3299) and not c:IsCode(m) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
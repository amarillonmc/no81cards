--化野·蛇之魔眼
local m=77000121
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Equip limit
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_SINGLE)
	e24:SetCode(EFFECT_EQUIP_LIMIT)
	e24:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e24:SetValue(cm.eqlimit)
	c:RegisterEffect(e24)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--Effect 2  
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(m,0))
	e14:SetCategory(CATEGORY_DESTROY)
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetRange(LOCATION_SZONE)
	e14:SetCountLimit(1)
	e14:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e14:SetCondition(cm.lckcon)
	e14:SetTarget(cm.lcktg)
	e14:SetOperation(cm.lckop)
	c:RegisterEffect(e14)
	--Effect 3 
	--Effect 4 
	--Effect 5 
end
--Effect 1
function cm.eqlimit(e,c) --c:IsSetCard(0x5ee0)
	return c:IsSetCard(0x5ee0)
end
function cm.filter(c) --and c:IsSetCard(0x132)
	return c:IsFaceup() and c:IsSetCard(0x5ee0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--Effect 2
function cm.lckcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function cm.lcktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE)
	and chkc:IsControler(1-tp) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetChainLimit(cm.limit(g:GetFirst()))
end
function cm.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function cm.lckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local flag=false
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		flag=true 
	end
	if flag==true then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end 
end
--Effect 3 
--Effect 4 
--Effect 5   

--方舟骑士·雪峰之影 崖心
function c82567870.initial_effect(c)
	--pos change
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1,82567870)
	e3:SetCost(c82567870.cost)
	e3:SetTarget(c82567870.target)
	e3:SetOperation(c82567870.operation)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(82567870,ACTIVITY_SPSUMMON,c82567870.counterfilter)
	--synchro material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SYNCHRO_MATERIAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c82567870.synfilter)
	c:RegisterEffect(e6)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
	
end
function c82567870.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK))
end
function c82567870.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() and c82567870.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82567870.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c82567870.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c82567870.synfilter(e,c)
	return c:GetCounter(0x5825)>0
end
function c82567870.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) and Duel.GetCustomActivityCount(82567870,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c82567870.splimit2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c82567870.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK)) and c:IsLocation(LOCATION_EXTRA)
end
function c82567870.filter(c)
	return c:IsFaceup() and c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c82567870.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() and c82567870.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82567870.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c82567870.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c82567870.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tcc=tc:GetCode()
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
	  e:GetHandler():SetCardTarget(tc)
	   if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_TARGET)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e:GetHandler():RegisterEffect(e1)
	tc:AddCounter(0x5825,1)
end
end
end
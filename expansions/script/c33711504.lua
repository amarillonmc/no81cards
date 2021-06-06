--稳重的龙之子 柯拉尔
local m=33711504
local cm=_G["c"..m]
local gl=0x144a
function cm.initial_effect(c)
   aux.EnableDualAttribute(c)
	--Special Summon
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1) 
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,gl)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
			if tc:AddCounter(gl,1) then
				local e0=Effect.CreateEffect(c)
				e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
				e0:SetDescription(aux.Stringid(m,1))
				e0:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
				e0:SetCode(EVENT_LEAVE_FIELD)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE)
				e0:SetCondition(cm.spcon)
				e0:SetTarget(cm.sptg)
				e0:SetOperation(cm.spop)	
				tc:RegisterEffect(e0)
			end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(gl)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spfilter(c,e,tp,code1,code2)
	return c:IsCode(code1,code2) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=e:GetHandler():GetCode()
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,code1,code2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,code1,code2)
		Duel.SpecialSummon(spg,0,tp,tp,true,false)
	end
	e:Reset()
end
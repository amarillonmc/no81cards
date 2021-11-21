--仲裁之机兵 正义骑士号
function c76029033.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,76029033+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c76029033.hspcon)
	e1:SetOperation(c76029033.hspop)
	c:RegisterEffect(e1)  
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c76029033.lvtg)
	e1:SetOperation(c76029033.lvop)
	c:RegisterEffect(e1)
end
c76029033.named_with_Kazimierz=true 
function c76029033.spfilter(c,ft)
	return c:IsRace(RACE_WINDBEAST+RACE_BEASTWARRIOR) and c:IsAbleToRemoveAsCost()
		and (ft>0 or (c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE)))
end
function c76029033.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c76029033.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,ft)
end
function c76029033.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76029033.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c,ft)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c76029033.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:GetLevel()>0
end
function c76029033.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c76029033.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c76029033.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c76029033.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local lv=g:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	e:SetLabel(Duel.AnnounceLevel(tp,1,8,lv))
end
function c76029033.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_ADD_RACE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(RACE_WINDBEAST+RACE_BEASTWARRIOR)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2) 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_NONTUNER)
		e3:SetValue(c76029033.tnval)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
function c76029033.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end











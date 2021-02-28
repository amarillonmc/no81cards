--时机龙骑·原点回归
--local m=40009199
--local c40009199=_G["c"..m]
function c40009199.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,c40009199.mfilter,4,3)  
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009199,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,40009199)
	e1:SetCondition(c40009199.hdcon)
	e1:SetTarget(c40009199.hdtg)
	e1:SetOperation(c40009199.hdop)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009199,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009200)
	e2:SetCondition(c40009199.thcon)
	e2:SetTarget(c40009199.thtg)
	e2:SetOperation(c40009199.thop)
	c:RegisterEffect(e2)  
	--place
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c40009199.reg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetDescription(aux.Stringid(40009199,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c40009199.pcon)
	e4:SetTarget(c40009199.ptg)
	e4:SetOperation(c40009199.pop)
	c:RegisterEffect(e4)
end
function c40009199.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c40009199.cfilter(c,tp)
	return c:IsFaceup() 
		and c:IsSetCard(0xf1c) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c40009199.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009199.cfilter,1,nil,tp)
end
function c40009199.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c40009199.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c40009199.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009199.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c40009199.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c40009199.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c40009199.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	--local fid=c:GetFieldID()
	local g=Duel.SelectMatchingCard(tp,c40009199.thfilter,tp,LOCATION_EXTRA,0,1,ct,nil)
	--local tc=g:GetFirst()
	local pc=g:GetFirst()
	while pc do
	--if tc and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
		if Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
		--tc:KeepAlive()
			--pc:RegisterFlagEffect(40009199,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			--e1:SetLabel(fid)
			e1:SetLabelObject(pc)
			e1:SetCondition(c40009199.descon)
			e1:SetOperation(c40009199.desop)
			if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END then
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
				e1:SetLabel(Duel.GetTurnCount())
				pc:RegisterFlagEffect(40009199,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e1:SetLabel(0)
				pc:RegisterFlagEffect(40009199,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
			end
		--Duel.RegisterEffect(e1,tp)
			Duel.RegisterEffect(e1,tp)
			pc=g:GetNext()
		end
	end
end
function c40009199.descon(e,tp,eg,ep,ev,re,r,rp)
	local pc=e:GetLabelObject()
	if Duel.GetTurnPlayer()==tp then return false end
	if pc:GetFlagEffectLabel(40009199)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c40009199.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c40009199.pencon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009199.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c40009199.penfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xf1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009199.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40009199.penfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40009199,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c40009199.reg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:IsHasType(EFFECT_TYPE_ACTIONS) then
		c:RegisterFlagEffect(40009199+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c40009199.pcon(e,tp)
	return e:GetHandler():GetFlagEffect(40009199+100)>0
end
function c40009199.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c40009199.spfilter(c,e,tp)
	return c:IsSetCard(0x1f1c) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009199.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then return end
	local sg=Duel.GetMatchingGroup(c40009199.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(40009199,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=sg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	end
end
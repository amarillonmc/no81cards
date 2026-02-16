--被遗忘的研究 收容物仿人之镜
function c43480010.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,43480010)
	e1:SetCondition(c43480010.pspcon)
	e1:SetTarget(c43480010.psptg)
	e1:SetOperation(c43480010.pspop)
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetTarget(c43480010.destg) 
	e1:SetOperation(c43480010.desop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--equip
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(1,43480011) 
	e2:SetCondition(c43480010.eqcon)
	e2:SetTarget(c43480010.eqtg)
	e2:SetOperation(c43480010.eqop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,43480012)
	e3:SetCondition(function(e) 
	return e:GetHandler():GetEquipTarget()~=nil end)
	e3:SetCost(c43480010.cpcost)
	e3:SetTarget(c43480010.cptg)
	e3:SetOperation(c43480010.cpop)
	c:RegisterEffect(e3)
end
function c43480010.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f13)
end
function c43480010.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43480010.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsEnvironment(43480070,tp) 
end
function c43480010.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480010.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetTarget(function(e,c) 
		return not c:IsSetCard(0x3f13) end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true) 
		Duel.SpecialSummonComplete()
	end
end
function c43480010.desfil(c) 
	return not (c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM))  
end 
function c43480010.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local dg=Duel.GetMatchingGroup(c43480010.desfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c43480010.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local p=tp 
	if Duel.IsPlayerAffectedByEffect(tp,43480050) then p=1-tp end 
	local dg=Duel.GetMatchingGroup(c43480010.desfil,p,LOCATION_MZONE,0,nil)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end 
function c43480010.xckfil(c,tp) 
	return c:IsSummonPlayer(tp) and c:IsFaceup() and c:IsSetCard(0x3f13)  
end 
function c43480010.eqcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c43480010.xckfil,1,nil,tp) 
end 
function c43480010.eqfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x3f13) and not c:IsType(TYPE_PENDULUM) 
end 
function c43480010.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c43480010.eqfil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c43480010.eqfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c43480010.eqfil,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c43480010.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e1:SetLabelObject(tc)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)  
	end
end 
function c43480010.cpfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsSetCard(0x3f13) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c43480010.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c43480010.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c43480010.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c43480010.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c43480010.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end 
end



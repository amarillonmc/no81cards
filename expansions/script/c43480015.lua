--被遗忘的研究 收容物吞噬星空之虫
function c43480015.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,43480015)
	e1:SetCondition(c43480015.pspcon)
	e1:SetTarget(c43480015.psptg)
	e1:SetOperation(c43480015.pspop)
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetTarget(c43480015.destg) 
	e1:SetOperation(c43480015.desop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--rel
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,43480016) 
	e2:SetTarget(c43480015.ratg) 
	e2:SetOperation(c43480015.raop)  
	c:RegisterEffect(e2) 
	--equip
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,43480017)
	e3:SetCondition(function(e) 
	return e:GetHandler():GetEquipTarget()~=nil end) 
	e3:SetTarget(c43480015.eqtg)
	e3:SetOperation(c43480015.eqop)
	c:RegisterEffect(e3)
end
function c43480015.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f13)
end
function c43480015.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43480015.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsEnvironment(4348070,tp) 
end
function c43480015.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480015.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end
end
function c43480015.desfil(c) 
	return not (c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM))  
end 
function c43480015.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local dg=Duel.GetMatchingGroup(c43480015.desfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c43480015.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local p=tp 
	if Duel.IsPlayerAffectedByEffect(tp,4348050) then p=1-tp end 
	local dg=Duel.GetMatchingGroup(c43480015.desfil,p,LOCATION_MZONE,0,nil)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end
function c43480015.rlfil1(c) 
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetTextAttack()>0  
end 
function c43480015.rlfil2(c) 
	return c:IsReleasableByEffect()
end 
function c43480015.ratg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return false end 
	if chk==0 then return Duel.IsExistingTarget(c43480015.rlfil1,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingTarget(c43480015.rlfil2,tp,0,LOCATION_MZONE,1,e:GetHandler()) end 
	local g1=Duel.SelectTarget(tp,c43480015.rlfil1,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local g2=Duel.SelectTarget(tp,c43480015.rlfil2,tp,0,LOCATION_MZONE,1,1,nil) 
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g1,g1:GetCount(),0,0)
end
function c43480015.raop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()==2 and Duel.Release(g,REASON_EFFECT)==2 and c:IsRelateToEffect(e) and c:IsFaceup() then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(g:GetSum(Card.GetAttack)/2) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
	end 
end 
function c43480015.eqfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x3f13) and c:GetOriginalType()&TYPE_PENDULUM~=0 
end 
function c43480015.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c43480015.eqfil(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c43480015.eqfil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c43480015.eqfil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end 
function c43480015.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	local ec=c:GetEquipTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and ec then 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Equip(tp,tc,ec)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e1:SetLabelObject(ec)
		e1:SetValue(function(e,c)
		return c==e:GetLabelObject() end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)  
	end
end 






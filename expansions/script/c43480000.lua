--被遗忘的研究 收容物不死身凤凰
function c43480000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,43480000)
	e1:SetCondition(c43480000.pspcon)
	e1:SetTarget(c43480000.psptg)
	e1:SetOperation(c43480000.pspop)
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetTarget(c43480000.destg) 
	e1:SetOperation(c43480000.desop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--equip
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43480001) 
	e2:SetTarget(c43480000.eqtg)
	e2:SetOperation(c43480000.eqop)
	c:RegisterEffect(e2)
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)   
	e3:SetRange(LOCATION_SZONE) 
	e3:SetCountLimit(1,43480002) 
	e3:SetCondition(c43480000.spcon)
	e3:SetTarget(c43480000.sptg)
	e3:SetOperation(c43480000.spop)
	c:RegisterEffect(e3)
end
function c43480000.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f13)
end
function c43480000.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43480000.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsEnvironment(4348070,tp) 
end
function c43480000.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480000.pspop(e,tp,eg,ep,ev,re,r,rp)
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
function c43480000.desfil(c,tp) 
	return not (c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM)) and ((not Duel.IsPlayerAffectedByEffect(tp,43480050) and c:IsControler(tp)) or Duel.IsPlayerAffectedByEffect(tp,43480050) and c:IsControler(1-tp))
end 
function c43480000.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local dg=Duel.GetMatchingGroup(c43480000.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c43480000.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local p=tp 
	if Duel.IsPlayerAffectedByEffect(tp,4348050) then p=1-tp end 
	local dg=Duel.GetMatchingGroup(c43480000.desfil,p,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end 
function c43480000.eqfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_LINK) 
end 
function c43480000.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c43480000.eqfil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c43480000.eqfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c43480000.eqfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c43480000.eeqfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)  
end 
function c43480000.eqop(e,tp,eg,ep,ev,re,r,rp)
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
		if tc:GetEquipCount()==1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c43480000.eeqfil,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43480000,0)) then 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP) 
			local ec=Duel.SelectMatchingCard(tp,c43480000.eeqfil,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst() 
			Duel.Equip(tp,ec,tc) 
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
			e1:SetLabelObject(tc)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1) 
		end 
	end
end 
function c43480000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()~=nil 
end
function c43480000.spfil(c,e,tp) 
	if not (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3f13) and c:IsFaceup()) then return false end 
	if c:IsLocation(LOCATION_EXTRA) then 
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
	else 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end   
end 
function c43480000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480000.spfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c43480000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c43480000.spfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end 
end  





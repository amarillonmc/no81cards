--折纸使 上和泉樱夜
function c9910007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910007)
	e1:SetCondition(c9910007.rpcon)
	e1:SetTarget(c9910007.rptg)
	e1:SetOperation(c9910007.rpop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,9910008)
	e2:SetTarget(c9910007.sptg)
	e2:SetOperation(c9910007.spop)
	c:RegisterEffect(e2)
end
function c9910007.rpcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c9910007.rpfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9910007.rpsfilter(c)
	return c9910007.rpfilter(c) and c:IsSetCard(0x3950) and not c:IsCode(9910007)
end
function c9910007.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910007.rpfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c9910007.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c9910007.rpfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		local sg=Duel.GetMatchingGroup(c9910007.rpsfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910007,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tg=sg:Select(tp,1,1,nil)
			local fc=tg:GetFirst()
			Duel.BreakEffect()
			Duel.MoveToField(fc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c9910007.setfilter(c)
	return c:IsFaceupEx() and c:IsLevelBelow(4) and c:IsSetCard(0x3950) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c9910007.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c9910007.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910007.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
end
function c9910007.spop(e,tp,eg,ep,ev,re,r,rp)
	local chk
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c9910007.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
			chk=true
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910007.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if #g==0 then return end
	if chk then Duel.BreakEffect() end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end

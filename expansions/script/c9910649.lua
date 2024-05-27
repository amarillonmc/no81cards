--引力探测器 天界星琴号
function c9910649.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910649)
	e1:SetCondition(c9910649.spcon)
	e1:SetTarget(c9910649.sptg)
	e1:SetOperation(c9910649.spop)
	c:RegisterEffect(e1)
	--disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCountLimit(1,9910650)
	e2:SetCondition(c9910649.dscon)
	e2:SetCost(c9910649.dscost)
	e2:SetTarget(c9910649.dstg)
	e2:SetOperation(c9910649.dsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c9910649.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
		and (Duel.GetAttacker():IsControler(tp) and Duel.GetAttacker():IsType(TYPE_XYZ)
			or Duel.GetAttackTarget():IsControler(tp) and Duel.GetAttackTarget():IsType(TYPE_XYZ))
end
function c9910649.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910649.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=Duel.GetAttacker()
		if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c9910649.dscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c9910649.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c9910649.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c9910649.xfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function c9910649.ofilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c9910649.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local g=Duel.GetMatchingGroup(c9910649.xfilter,tp,LOCATION_MZONE,0,nil,e)
	local sg=eg:Filter(c9910649.ofilter,nil,e)
	if g:GetCount()==0 or sg:GetCount()==0 or Duel.SelectOption(tp,1191,aux.Stringid(9910649,1))==0 then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local og=Group.CreateGroup()
		for sc in aux.Next(sg) do
			og:Merge(sc:GetOverlayGroup())
		end
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,sg)
	end
end

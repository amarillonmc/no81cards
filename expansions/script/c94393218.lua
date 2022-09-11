--英豪冠军 圣盾王
function c94393218.initial_effect(c)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c94393218.XyzCondition)
	e1:SetTarget(c94393218.XyzTarget)
	e1:SetOperation(c94393218.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94393218,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c94393218.spcost)
	e2:SetTarget(c94393218.sptg)
	e2:SetOperation(c94393218.spop)
	c:RegisterEffect(e2)
	--immune effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0xff,0)
	e4:SetCondition(c94393218.immcon)
	e4:SetTarget(c94393218.immtarget)
	e4:SetValue(c94393218.efilter)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(94393218,ACTIVITY_CHAIN,aux.FALSE)
end
--Xyz Summon(normal)
function c94393218.Xyzfilter2(c,sc)
	return c:IsSetCard(0x6f) and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c94393218.Xyzfilter(c,sc)
	return c:IsSetCard(0x6f) and c:IsFaceup() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c94393218.XyzCondition(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if og then return Duel.CheckXyzMaterial(c,aux.FilterBoolFunction(Card.IsSetCard,0x6f),4,2,2,og)
	else
		local mg=Duel.GetMatchingGroup(c94393218.Xyzfilter,tp,LOCATION_MZONE,0,nil,c)
		if Duel.GetCustomActivityCount(94393218,1-tp,ACTIVITY_CHAIN)~=0 and Duel.GetFlagEffect(tp,94393218)==0 then
			local og=Duel.GetMatchingGroup(c94393218.Xyzfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,c)
			mg:Merge(og)
		end
		return Duel.CheckXyzMaterial(c,aux.FilterBoolFunction(Card.IsSetCard,0x6f),4,2,2,mg)
	end
	
end
function c94393218.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local g=Group.CreateGroup()
	if og then 
		g=Duel.SelectXyzMaterial(tp,c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,2,2,og)
	else
		local mg=Duel.GetMatchingGroup(c94393218.Xyzfilter,tp,LOCATION_MZONE,0,nil,c)
		if Duel.GetCustomActivityCount(94393218,1-tp,ACTIVITY_CHAIN)~=0 and Duel.GetFlagEffect(tp,94393218)==0 then
			local og=Duel.GetMatchingGroup(c94393218.Xyzfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,c)
			mg:Merge(og)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:Select(tp,2,2,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c94393218.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
			Duel.SendtoGrave(sg,REASON_RULE)
			c:SetMaterial(og)
			Duel.Overlay(c,og)
	else
		e:SetLabel(0)
		local mg=e:GetLabelObject()
		if mg:Filter(Card.IsLocation,nil,LOCATION_HAND):GetCount()~=0 then 
			e:SetLabel(1)
		end
		if mg:Filter(Card.IsLocation,nil,LOCATION_HAND|LOCATION_GRAVE):GetCount()~=0 then 
			Duel.RegisterFlagEffect(tp,94393218,RESET_PHASE+PHASE_END,0,1)
		end
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		if e:GetLabel()==1 then Duel.ShuffleHand(tp) end
		mg:DeleteGroup()
	end
end
function c94393218.immcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c94393218.immtarget(e,c)
	return c:IsSetCard(0x6f) and c:IsFaceup()
end
function c94393218.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c94393218.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c94393218.spfilter(c,e,tp)
	return c:IsSetCard(0x6f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c94393218.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c94393218.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c94393218.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c94393218.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c94393218.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local batk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(batk*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end

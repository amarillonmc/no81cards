--月神的眷顾
function c9910085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910085.condition)
	e1:SetCost(c9910085.cost)
	e1:SetTarget(c9910085.target)
	e1:SetOperation(c9910085.activate)
	c:RegisterEffect(e1)
end
function c9910085.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c9910085.cfilter(c)
	return c:IsSetCard(0x9951) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c9910085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,c9910085.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,c9910085.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsType(TYPE_SYNCHRO+TYPE_XYZ) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c9910085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	local cate=CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE 
	if bit.band(re:GetHandler():GetOriginalType(),TYPE_MONSTER)~=0 then
		e:SetCategory(cate+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(cate)
	end
end
function c9910085.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) 
		or not rc:IsRelateToEffect(re) or Duel.Destroy(eg,REASON_EFFECT)==0 then return end
	local b1=not rc:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED) and rc:IsAbleToRemove(tp,POS_FACEDOWN)
	local b2=not (rc:IsLocation(LOCATION_HAND+LOCATION_DECK) or rc:IsLocation(LOCATION_REMOVED) and rc:IsFacedown())
		and aux.NecroValleyFilter()(rc) and e:GetLabel()==1
	local b3=rc:IsType(TYPE_MONSTER) and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or rc:IsLocation(LOCATION_EXTRA) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,rc)>0)
	local b4=(rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and rc:IsSSetable()
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910085,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 and (b3 or b4) then
		ops[off]=aux.Stringid(9910085,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(9910085,2)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		if b3 then
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		else
			Duel.SSet(tp,rc)
		end
	end
end

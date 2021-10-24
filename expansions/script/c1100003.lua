--魔符『拿来吧你』
function c1100003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1100003,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,1100003+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c1100003.con1)
	e1:SetTarget(c1100003.tg1)
	e1:SetOperation(c1100003.op1)
	c:RegisterEffect(e1)
--
end
--
function c1100003.ProtectedRun(f,...)
	if not f then return true end
	local params={...}
	local ret={}
	local res_test=pcall(function()
		ret={f(table.unpack(params))}
	end)
	if not res_test then return false end
	return table.unpack(ret)
end
function c1100003.con1(e,tp,eg,ep,ev,re,r,rp)
	local te=re:GetHandler():GetActivateEffect()
	if not te then return false end
	local con=te:GetCondition()
	local tg=te:GetTarget()
	local res=false
	if not c1100003.ProtectedRun(con,e,tp,eg,ep,ev,re,r,rp) then res=1 end
	if not c1100003.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0) then res=2 end
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev)
		and not res
		and re:GetHandler():CheckActivateEffect(false,true,false)~=nil
end
function c1100003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if bit.band(re:GetHandler():GetOriginalType(),TYPE_MONSTER)~=0 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	else
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	end
end
function c1100003.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if not rc:IsRelateToEffect(re) then return end
	if Duel.Destroy(eg,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK) and aux.NecroValleyFilter()(rc) then
		if rc:IsType(TYPE_MONSTER)
			and (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 or rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,rc)>0)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(1100003,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and rc:IsSSetable()
			and Duel.SelectYesNo(tp,aux.Stringid(1100003,2)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
		end
	end
end
--
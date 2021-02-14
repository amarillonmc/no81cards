--月神的眷顾
function c9910085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
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
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910085.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c9910085.cfilter,1,1,nil)
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
		local cat=e:GetCategory()
		if bit.band(re:GetHandler():GetOriginalType(),TYPE_MONSTER)~=0 then
			e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
		else
			e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_SPECIAL_SUMMON)))
		end
	end
end
function c9910085.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK)
		and not rc:IsHasEffect(EFFECT_NECRO_VALLEY) then
		if e:GetLabel()==1 and rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,nil,rc)>0)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(9910085,0)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif e:GetLabel()==1 and (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(9910085,1)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
		elseif rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(1-tp,tp,nil,rc)>0)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
			and Duel.SelectYesNo(tp,aux.Stringid(9910085,2)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(9910085,3)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc,1-tp)
		end
	end
end

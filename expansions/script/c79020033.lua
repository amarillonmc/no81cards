--危机合约·感染增生
function c79020033.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79020033+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c79020033.target)
	e1:SetOperation(c79020033.activate)
	c:RegisterEffect(e1) 
	--rank up 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(58988903,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(aux.exccon)
	e1:SetTarget(c79020033.target1)
	e1:SetOperation(c79020033.activate1)
	c:RegisterEffect(e1)	
end
function c79020033.fil1(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x3904)
end 
function c79020033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79020033.fil1,tp,0,LOCATION_GRAVE,1,nil)
	if chk==0 then return true end
	local op=0
	if b1 then
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79020034) then
	op=Duel.SelectOption(tp,aux.Stringid(79020033,0),aux.Stringid(79020033,1),aux.Stringid(79020033,2))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79020033,0),aux.Stringid(79020033,1))
	end
	else
	op=Duel.SelectOption(tp,aux.Stringid(79020033,1))+1
	end
	e:SetLabel(op)
	if op~=1 then 
	local g=Duel.SelectMatchingCard(tp,c79020033.fil1,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
end
function c79020033.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79020033,3))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c79020033.rcon)
	e2:SetOperation(c79020033.rop)
	Duel.RegisterEffect(e2,tp)
	if op~=1 then 
	local tc=Duel.GetFirstTarget()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	local at=g:GetFirst()
	while at do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(0x3904)
	at:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79020028)
	at:RegisterFlagEffect(79020033,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(79020033,4))
	at=g:GetNext()
	end
end
end
function c79020033.fil2(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x3904)
end 
function c79020033.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetOverlayCount()>=ev-1 and re:GetHandler():IsSetCard(0x3904) and Duel.IsExistingMatchingCard(c79020033.fil2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function c79020033.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79020033.fil2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	return Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79020033.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsSetCard(0x3904) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c79020033.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c79020033.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0x3904) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c79020033.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79020033.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c79020033.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79020033.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79020033.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79020033.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end







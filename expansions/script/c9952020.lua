--起动战士-零件战士
function c9952020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9952020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9952020)
	e1:SetTarget(c9952020.sptg)
	e1:SetOperation(c9952020.spop)
	c:RegisterEffect(e1)
  --update attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(3000)
	e2:SetCondition(c9952020.atkcon)
	c:RegisterEffect(e2)
 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e1:SetValue(c9952020.atkval)
	c:RegisterEffect(e1)
end
function c9952020.atkval(e,c)
	return e:GetHandler():GetEquipCount()*300
end
function c9952020.eqfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x51) and c:IsLevelBelow(4) and c:IsRace(RACE_MACHINE) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp)
end
function c9952020.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c9952020.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e,tp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),3)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetCount()>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.SetTargetCard(sg)
	local tg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if tg:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tg,tg:GetCount(),0,0)
	end
end
function c9952020.tgfilter(c,e)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRelateToEffect(e)
end
function c9952020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9952020.tgfilter,nil,e)
		if ft<g:GetCount() then return end
		Duel.BreakEffect()
		local tc=g:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,false,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(c9952020.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(9952020,RESET_EVENT+RESETS_STANDARD,0,1)
			tc=g:GetNext()
		end
		Duel.EquipComplete()
	end
end
function c9952020.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9952020.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c9952020.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9952020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,41172955)
		and Duel.IsExistingMatchingCard(c9952020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,86445415)
		and Duel.IsExistingMatchingCard(c9952020.cfilter,tp,LOCATION_ONFIELD,0,1,nil,13839120)
end
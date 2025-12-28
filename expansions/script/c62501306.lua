--镰之御巫 末奈
function c62501306.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(62501306,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,62501306)
	e0:SetCost(c62501306.spcost)
	e0:SetTarget(c62501306.sptg)
	e0:SetOperation(c62501306.spop)
	c:RegisterEffect(e0)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c62501306.ndcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c62501306.indcon)
	c:RegisterEffect(e2)
	--reflect battle damage
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,62501306+1)
	e4:SetCondition(c62501306.eqcon)
	e4:SetTarget(c62501306.eqtg)
	e4:SetOperation(c62501306.eqop)
	c:RegisterEffect(e4)
end
function c62501306.costfilter(c)
	return c:IsSetCard(0x18d) and c:IsType(TYPE_MONSTER) and not c:IsCode(62501306) and c:IsAbleToGraveAsCost()
end
function c62501306.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501306.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c62501306.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c62501306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c62501306.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62501306.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62501306.splimit(e,c)
	return not c:IsSetCard(0x18d) and c:IsLocation(LOCATION_EXTRA)
end
function c62501306.ndcon(e)
	return e:GetHandler():GetEquipCount()==0
end
function c62501306.indcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c62501306.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c62501306.tfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c62501306.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function c62501306.eqfilter(c,tp,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(ec)
end
function c62501306.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c62501306.tfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c62501306.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c62501306.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c62501306.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c62501306.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,tc):GetFirst()
		if ec then
			Duel.Equip(tp,ec,tc)
		end
	end
end

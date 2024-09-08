--Kamipro 幻煌机
function c50214210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50214210)
	e1:SetTarget(c50214210.target)
	e1:SetOperation(c50214210.operation)
	c:RegisterEffect(e1)
	--akt/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e22)
	--Equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,50214210)
	e3:SetCost(c50214210.eqcost)
	e3:SetTarget(c50214210.eqtg)
	e3:SetOperation(c50214210.eqop)
	c:RegisterEffect(e3)
end
function c50214210.spfilter(c,e,tp)
	return c:IsSetCard(0xcbf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50214210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c50214210.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c50214210.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50214210.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c50214210.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c50214210.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c50214210.eqlimit(e,c)
	return e:GetOwner()==c
end

function c50214210.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c50214210.filter(c,tp)
	return c:IsSetCard(0xcbf) and not c:IsCode(50214210) and c:IsType(TYPE_EQUIP)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c50214210.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function c50214210.eqfilter(c,tc)
	return c:IsFaceup() and tc:CheckEquipTarget(c)
end
function c50214210.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c50214210.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c50214210.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectMatchingCard(tp,c50214210.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g1:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectMatchingCard(tp,c50214210.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc)
	Duel.Equip(tp,tc,g2:GetFirst())
end
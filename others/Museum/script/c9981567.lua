--IG-冠军菲奥娜
function c9981567.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c9981567.ovfilter,aux.Stringid(9981567,0))
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981567.condition)
	e1:SetOperation(c9981567.regop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981567,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c9981567.drtg)
	e2:SetOperation(c9981567.drop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981567.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9981567.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9981567.defval)
	c:RegisterEffect(e2)
	--xyz material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981567,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9981567)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9981567.discon1)
	e3:SetCost(c9981567.cost)
	e3:SetTarget(c9981567.target)
	e3:SetOperation(c9981567.operation)
	c:RegisterEffect(e3)
	 local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c9981567.discon2)
	c:RegisterEffect(e4)
end
function c9981567.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981567,1))
end
function c9981567.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9981567.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c9981567.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9981567.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(9981567) and bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c9981567.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bce) and c:IsType(TYPE_XYZ) and not c:IsCode(9981567) and c:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_EQUIP)
end
function c9981567.filter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c9981567.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9981567.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9981567.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9981567.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981567,1))
end
function c9981567.atkfilter(c)
	return c:IsSetCard(0x9bce) and c:GetAttack()>=0
end
function c9981567.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9981567.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9981567.deffilter(c)
	return c:IsSetCard(0x9bce) and c:GetDefense()>=0
end
function c9981567.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9981567.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c9981567.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981567.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x9bce) 
end
function c9981567.filter2(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c9981567.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9981567.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c9981567.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9981567,2))
	Duel.SelectTarget(tp,c9981567.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c9981567.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9981567.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_ONFIELD)
	if tc1 and tc1:IsFaceup() and not tc1:IsImmuneToEffect(e) and g2:GetCount()>0 then
		Duel.Overlay(tc1,g2)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981567,1))
end
function c9981567.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9bce)
end
function c9981567.discon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9bce)
end
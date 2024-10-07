--拉特金的交斗
function c22348437.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCountLimit(1,22349437)
	e1:SetTarget(c22348437.target)
	e1:SetOperation(c22348437.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22348437)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22348437.thtg)
	e2:SetOperation(c22348437.thop)
	c:RegisterEffect(e2)
end
c22348437.has_text_type=TYPE_UNION
function c22348437.filter111(c,tp)
	return Duel.IsExistingMatchingCard(c22348437.cfilter1,tp,LOCATION_DECK,0,1,nil,c,tp) and c:IsFaceup()
end
function c22348437.cfilter1(c,ec,tp)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_UNION) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function c22348437.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c22348437.filter111(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22348437.filter111,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22348437.filter111,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetChainLimit(c22348437.limit(g:GetFirst()))
end
function c22348437.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c22348437.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(c22348437.spop)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
	Duel.RegisterEffect(e1,tp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,c22348437.cfilter1,tp,LOCATION_DECK,0,1,1,nil,tc,tp):GetFirst()
	if ec and Duel.Equip(tp,ec,tc) then
		aux.SetUnionState(ec)
	end
end
function c22348437.spfilter(c,e,tp)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:GetType()&TYPE_SPELL==TYPE_SPELL
		and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348437.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c22348437.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(22348437,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22348437.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348437.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c22348437.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348437.thfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c22348437.thfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22348437.eqfilter(c,tp)
	return Duel.IsExistingMatchingCard(c22348437.cfilter2,tp,LOCATION_HAND,0,1,nil,c,tp) and c:IsFaceup()
end
function c22348437.cfilter2(c,ec,tp)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_UNION) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function c22348437.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348437.thfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if #g==0 then return end
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348437.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(22348437,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=Duel.SelectMatchingCard(tp,c22348437.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c22348437.cfilter2,tp,LOCATION_HAND,0,1,1,nil,tc,tp):GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
		end
	end
end



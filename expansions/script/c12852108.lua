--不要离开我，请让我与你同行
function c12852108.initial_effect(c)
	aux.AddCodeList(c,12852102)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12852109+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c12852108.target)
	e1:SetOperation(c12852108.activate)
	c:RegisterEffect(e1)	
	--to hand
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetRange(LOCATION_GRAVE)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetCost(aux.bfgcost)
	e21:SetCondition(c12852108.condition)
	e21:SetTarget(c12852108.atttg)
	e21:SetOperation(c12852108.attop)
	c:RegisterEffect(e21)
end
function c12852108.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12852108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsCode(12852102) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12852108.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,12852102)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,12852102)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c12852108.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xa77) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c12852108.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12852108.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c12852108.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tc,tp) and Duel.SelectYesNo(tp,aux.Stringid(12852108,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g1=Duel.SelectMatchingCard(tp,c12852108.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tc,tp)
			if g1:GetCount()>0 then
				Duel.Equip(tp,g1:GetFirst(),tc)
			end
		end
	end
end
function c12852108.filter1(c)
	return c:GetEquipGroup():IsExists(c12852108.cfilter2,1,nil)
end
function c12852108.cfilter2(c)
	return c:IsFaceup() and c:IsCode(12852103)
end
function c12852108.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12852108.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c12852108.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c12852108.filter1,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-tc:GetAttribute())
	Duel.SetTargetCard(tc)
	e:SetLabel(att)
end
function c12852108.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
--Antonymph's Master Puppet
function c31021005.initial_effect(c)
	--Special
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,31021005)
	e1:SetTarget(c31021005.target)
	e1:SetOperation(c31021005.operation)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c31021005.addcon)
	e2:SetTarget(c31021005.addtg)
	e2:SetOperation(c31021005.addop)
	e2:SetCountLimit(1,31021006)
	c:RegisterEffect(e2)
end
function c31021005.filter(c)
	return c:IsSetCard(0x893) and c:IsFaceup() and c:IsCanAddCounter(0x1894,1)
end
function c31021005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c31021005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31021005.filter,tp,LOCATION_MZONE,0,1,nil) and
			Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c31021005.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c31021005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		local c=e:GetHandler()
		if Duel.SpecialSummon(c,nil,tp,tp,false,false,POS_FACEUP) and c:IsCanAddCounter(0x1894,1) then
			tc:AddCounter(0x1894,1)
		end
	end
end

function c31021005.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1894) < 1
end
function c31021005.addfilter(c)
	return c:IsSetCard(0x1893) and c:IsType(TYPE_MONSTER) and (not c:IsCode(31021005)) and c:IsAbleToHand()
end
function c31021005.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31021005.addfilter,tp,LOCATION_DECK,nil,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,nil,0,0)
end
function c31021005.addop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31021005.addfilter,tp,LOCATION_DECK,nil,nil)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end
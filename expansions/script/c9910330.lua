--神树勇者的战意
function c9910330.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(c9910330.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c9910330.value1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c9910330.value2)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c9910330.rmcost)
	e4:SetTarget(c9910330.rmtg)
	e4:SetOperation(c9910330.rmop)
	c:RegisterEffect(e4)
end
function c9910330.opfilter(c,tp)
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c9910330.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	return c:IsSetCard(0x5956) and c:IsType(TYPE_MONSTER) and (b1 or b2)
end
function c9910330.cfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9910330.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910330.opfilter,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910330,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			local b1=tc:IsAbleToHand()
			local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:CheckUniqueOnField(tp) and not tc:IsForbidden()
				and Duel.IsExistingMatchingCard(c9910330.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			if b1 and (not b2 or Duel.SelectOption(tp,1190,aux.Stringid(9910330,1))==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local sg=Duel.SelectMatchingCard(tp,c9910330.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
				local sc=sg:GetFirst()
				if sc then
					if Duel.Equip(tp,tc,sc) then
						--equip limit
						local e0=Effect.CreateEffect(e:GetHandler())
						e0:SetType(EFFECT_TYPE_SINGLE)
						e0:SetCode(EFFECT_EQUIP_LIMIT)
						e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e0:SetLabelObject(sc)
						e0:SetValue(c9910330.eqlimit)
						e0:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e0)
					end
				end
			end
		end
	end
end
function c9910330.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9910330.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c9910330.value1(e,c)
	return Duel.GetMatchingGroupCount(c9910330.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end
function c9910330.value2(e,c)
	return Duel.GetMatchingGroupCount(c9910330.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*(-100)
end
function c9910330.rfilter(c)
	return c:GetEquipGroup():GetCount()>0 and c:IsReleasable()
end
function c9910330.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910330.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c9910330.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910330.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),PLAYER_ALL,LOCATION_GRAVE)
end
function c9910330.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

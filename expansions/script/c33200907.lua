--寒霜灵兽 玛狃拉
function c33200907.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200907)
	e1:SetCost(c33200907.spcost)
	e1:SetTarget(c33200907.sptg)
	e1:SetOperation(c33200907.spop)
	c:RegisterEffect(e1)
	--active
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,33210907)
	e2:SetCondition(c33200907.condition)
	e2:SetTarget(c33200907.target)
	e2:SetOperation(c33200907.activate)
	c:RegisterEffect(e2)
end

--e1
function c33200907.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200907.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200907.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200907.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c33200907.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(c33200907.cfilter,nil,1-tp):GetCount()==1 
end
function c33200907.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c33200907.cfilter,nil,1-tp)
	Duel.SetTargetCard(g)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x132a)
	end
end
function c33200907.setfilter(c)
	return (c:IsSetCard(0x332a) or c:IsCode(33200052)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c33200907.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:GetFirst()
	Duel.ConfirmCards(tp,tc1)
	Duel.ShuffleHand(1-tp)
	if tc1:IsType(TYPE_MONSTER) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x132a,1) then
			local c=e:GetHandler()
			local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(Card.IsCanAddCounter,nil,0x132a,1)
			for tc in aux.Next(g) do
				if tc:IsCanAddCounter(0x132a,1) then
				tc:AddCounter(0x132a,1)
				end
			end
		end
	end
	if tc1:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c33200907.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c33200907.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc2=g:GetFirst()
		if tc2 and Duel.SSet(tp,tc2)~=0 then
			if tc2:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc2:RegisterEffect(e1)
			end
			Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
		end
	end
end

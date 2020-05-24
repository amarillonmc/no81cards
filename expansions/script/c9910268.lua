--幽鬼怀思
function c9910268.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910268+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910268.cost)
	e1:SetTarget(c9910268.target)
	e1:SetOperation(c9910268.activate)
	c:RegisterEffect(e1)
end
function c9910268.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c9910268.tgfilter(c)
	return (c:IsSetCard(0x953) or c:IsRace(RACE_ZOMBIE)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c9910268.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910268.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910268.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910268.tgfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	if sg:GetCount()>0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		local tg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local ct=tg:GetCount()
		if ct==0 then return end
		local tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c9910268.sumlimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END,ct)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetValue(c9910268.aclimit)
			Duel.RegisterEffect(e2,tp)
			tc=tg:GetNext()
		end
	end
end
function c9910268.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c9910268.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end

--Antonymph Split Flock
function c31021015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,31021015+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c31021015.cost)
	e1:SetTarget(c31021015.target)
	e1:SetOperation(c31021015.activate)
	c:RegisterEffect(e1)
end
function c31021015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c31021015.thfilter(c)
	return c:IsSetCard(0x1893) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c31021015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31021015.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c31021015.fselect(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount()
end
function c31021015.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31021015.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:SelectSubGroup(tp,c31021015.fselect,false,1,2)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		if sg:GetCount() > 1 then
			local tc1=sg:GetFirst()
			local tc2=sg:GetNext()
			if tc1:GetAttack() == tc2:GetAttack() or tc1:GetDefense() == tc2:GetDefense()
					or tc1:GetAttribute() == tc2:GetAttribute() then
				c31021015.setlimit(tc1,tc1:GetCode())
				c31021015.setlimit(tc2,tc2:GetCode())
			end
		end
	end
end

function c31021015.setlimit(c,code)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetTargetRange(1,0)
	e0:SetValue(c31021015.aclimit)
	e0:SetLabel(code)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c31021015.splimit)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end

function c31021015.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function c31021015.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsCode(e:GetLabel())
end
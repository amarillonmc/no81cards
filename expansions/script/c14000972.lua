--灵狐 安綱
local m=14000972
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff-LOCATION_HAND)
	e1:SetCost(cm.thcost)
	e1:SetOperation(cm.thcop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e2)
	--cannot tigger
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.stg)
	e3:SetOperation(cm.sop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cm.thcost(e,c,tp)
	return c:IsAbleToHand() and not c:IsLocation(LOCATION_HAND)
end
function cm.thcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function cm.cfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_MZONE) and(not e or c:IsRelateToEffect(e)) and c:IsPreviousLocation(LOCATION_HAND)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,sg=e:GetHandler(),eg:Filter(cm.cfilter,nil)
	if chk==0 then return #sg>0 end
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c,sg=e:GetHandler(),eg:Filter(cm.rmfilter,nil,e)
	if #sg>0 then
		local tc=sg:GetFirst()
		while tc do
			if tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
	end
end
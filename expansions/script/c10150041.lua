--摩天楼3-暮光之城
function c10150041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--se
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10150041)
	e2:SetCondition(c10150041.thcon)
	e2:SetTarget(c10150041.thtg)
	e2:SetOperation(c10150041.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c10150041.etg)
	e4:SetValue(c10150041.efilter)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c10150041.etg)
	e5:SetValue(1000)
	c:RegisterEffect(e5)
end
function c10150041.etg(e,c)
	return c:IsSetCard(0x3008) and c:GetSummonType()==SUMMON_TYPE_FUSION 
end
function c10150041.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c10150041.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10150041.cfilter,1,nil,tp)
end
function c10150041.cfilter(c,tp)
	return c:IsSetCard(0x3008) and c:IsFaceup() and c:IsControler(tp)
end
function c10150041.filter1(c)
	return c:IsCode(24094653) and c:IsAbleToHand()
end
function c10150041.filter2(c)
	return c:IsSetCard(0x3008) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c10150041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10150041.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10150041.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c10150041.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10150041.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg1,nil,REASON_EFFECT)~=0 then
		   Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,sg1)
		   if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10150041,1)) then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			  local sg2=g2:Select(tp,1,1,nil)
			  Duel.SendtoHand(sgs,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,sgs)
		   end
		end
	end
end

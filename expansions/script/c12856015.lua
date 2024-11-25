--塔尔塔罗斯 无上之波塞冬
function c12856015.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0xa7d)
	c:SetCounterLimit(0xa7d,12)
	aux.AddCodeList(c,12856000)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c12856015.cost)
	e1:SetTarget(c12856015.thtg)
	e1:SetOperation(c12856015.thop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c12856015.acop)
	c:RegisterEffect(e3)
	--Tartarus!
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c12856015.regcon)
	e4:SetOperation(c12856015.regop)
	c:RegisterEffect(e4)
c12856015.SetRarity_UTR=true
end
function c12856015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xa7d,4,REASON_COST) and not c:IsPublic() end
	Duel.RemoveCounter(tp,1,0,0xa7d,4,REASON_COST)
	--public
	Duel.ConfirmCards(1-tp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12856015,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c12856015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12856015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c12856015.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0xa7d,1)
	end
end
function c12856015.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(12856000) and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c12856015.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c12856015.target)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(12856015,0))
end
function c12856015.target(e,c)
	return c:GetControler()==e:GetHandler():GetControler() and bit.band(c:GetType(),0x81)==0x81
end
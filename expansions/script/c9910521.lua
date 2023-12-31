--桃绯斥候 伊那子柚
function c9910521.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910521.spcon)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910521,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9910521.thcost)
	e2:SetTarget(c9910521.thtg)
	e2:SetOperation(c9910521.thop)
	c:RegisterEffect(e2)
	--gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c9910521.mtcon)
	e3:SetOperation(c9910521.mtop)
	c:RegisterEffect(e3)
end
function c9910521.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c9910521.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910521.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910521.thfilter(c,cardtype)
	return c:IsSetCard(0xa950) and c:IsType(cardtype) and c:IsAbleToHand()
end
function c9910521.gcheck(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c9910521.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910521,0))
		ac=Duel.AnnounceNumber(tp,1,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ac)
	Duel.ConfirmCards(tp,g)
	local cardtype=0
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then cardtype=cardtype+TYPE_MONSTER end
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then cardtype=cardtype+TYPE_SPELL end
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then cardtype=cardtype+TYPE_TRAP end
	local tg=Duel.GetMatchingGroup(c9910521.thfilter,tp,LOCATION_DECK,0,nil,cardtype)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910521,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=tg:SelectSubGroup(tp,c9910521.gcheck,false,1,3)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleHand(1-tp)
end
function c9910521.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and eg:IsExists(Card.IsSetCard,1,nil,0xa950)
		and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c9910521.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsSetCard,nil,0xa950)
	local rc=g:GetFirst()
	while rc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(700)
		rc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(9910521,2))
		e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCost(c9910521.thcost)
		e2:SetTarget(c9910521.thtg)
		e2:SetOperation(c9910521.thop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
		if not rc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e3,true)
		end
		rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910521,3))
		rc=g:GetNext()
	end
end

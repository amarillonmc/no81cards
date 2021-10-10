--怪物·幻翼
function c188831.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188831,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c188831.target)
	e1:SetOperation(c188831.operation)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c188831.flipop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c188831.chaincon)
	e3:SetOperation(c188831.chainop)
	c:RegisterEffect(e3)
end
function c188831.filter(c,lv)
	return c:IsLevelBelow(lv) and c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c188831.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local lv=cg:GetSum(Card.GetOriginalLevel)
	if chk==0 then return Duel.IsExistingMatchingCard(c188831.filter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c188831.operation(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local lv=cg:GetSum(Card.GetOriginalLevel)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c188831.filter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c188831.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(188831,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c188831.chaincon(e)
	return e:GetHandler():GetFlagEffect(188831)~=0
end
function c188831.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetCode()==EVENT_FLIP or re:GetCode()==EVENT_FLIP_SUMMON_SUCCESS then
		Duel.SetChainLimit(c188831.chainlm)
	end
end
function c188831.chainlm(e,rp,tp)
	return tp==rp
end

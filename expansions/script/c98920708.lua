--荷鲁斯的化身-法老
function c98920708.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,98920708+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98920708.sprcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920708,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98960708)
	e2:SetCost(c98920708.tgcost)
	e2:SetTarget(c98920708.target)
	e2:SetOperation(c98920708.operation)
	c:RegisterEffect(e2)
		--Leave Field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920708,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98960709)
	e3:SetCondition(c98920708.descon)
	e3:SetTarget(c98920708.destg)
	e3:SetOperation(c98920708.desop)
	c:RegisterEffect(e3)
end
function c98920708.sprfilter(c)
	return c:IsFaceup() and c:IsCode(16528181)
end
function c98920708.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920708.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98920708.costfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsLevel(8)
end
function c98920708.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98920708.costfilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920708.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920708.filter(c)
	return c:IsCode(26984177) and c:IsAbleToHand()
end
function c98920708.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920708.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920708.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c98920708.filter,tp,LOCATION_DECK,0,nil)
	if tg and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,tg)~=0
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(98920708,2)) then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c98920708.cfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
end
function c98920708.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920708.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c98920708.damfilter(c)
	return c:IsFaceup() and c:GetSequence()<5 
end
function c98920708.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920708.damfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local ct=Duel.GetMatchingGroupCount(c98920708.damfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c98920708.desop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c98920708.damfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*600,REASON_EFFECT)
end

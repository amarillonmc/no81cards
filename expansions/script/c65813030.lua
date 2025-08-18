--防御阵线 要塞
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,2,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.tscon)
	e3:SetTarget(s.tstg)
	e3:SetOperation(s.tsop)
	c:RegisterEffect(e3)
end

function s.matfilter(c)
	return c:GetOriginalType()&TYPE_TRAP>0
end

function s.cfilter(c)
	return c:IsSetCard(0x5a31) and c:IsSSetable()
end
function s.filter1(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function s.filter2(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function s.filter3(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function s.filter4(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b4=Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)},
		{b4,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,c)
		Duel.SendtoHand(g,nil,REASON_COST)
	elseif op==2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,c)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_MZONE,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_MZONE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	elseif sel==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	else end
end

function s.tscon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp and r&REASON_COST>0
		and (rc:IsSetCard(0x5a31) and rc:IsType(TYPE_TRAP))
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.desop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5a31) and c:IsAbleToHand()
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
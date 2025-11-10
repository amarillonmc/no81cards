--CAN:D 新圣域
function c88888217.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(88888217)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,88888217)
	e1:SetCost(c88888217.cost)
	e1:SetTarget(c88888217.tg)
	c:RegisterEffect(e1)
end
function c88888217.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888217.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88888217.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalAttribute())
end
function c88888217.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c88888217.spfilter(c,e,tp,attr)
	return c:IsSetCard(0x8908) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsAttribute(attr)
end
function c88888217.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c88888217.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c88888217.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetLabel())
	local b2=Duel.IsExistingTarget(c88888217.filter,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(88888217,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(88888217,3)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(0)
		e:SetOperation(c88888217.spop)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c88888217.desop)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c88888217.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c88888217.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88888217.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c88888217.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--地缚神归来
local s,id,o=GetID()
function c98921075.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
		--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921075,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c98921075.handcon)
	c:RegisterEffect(e2)
end
function c98921075.tgfilter(c)
	return c:IsSetCard(0x21) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98921075.thfilter(c)
	return c:IsSetCard(0x1021) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.bfilter(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921075.tgfilter,tp,LOCATION_DECK,0,1,nil)
		or Duel.IsExistingMatchingCard(c98921075.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c98921075.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c98921075.thfilter,tp,LOCATION_DECK,0,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	if b1 and b2 and Duel.IsExistingMatchingCard(s.bfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98921075.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c98921075.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	elseif opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98921075.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			  local g1=Duel.SelectMatchingCard(tp,c98921075.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			  if g1:GetCount()>0 then
				 Duel.SendtoHand(g1,nil,REASON_EFFECT)
				 Duel.ConfirmCards(1-tp,g1)
			  end
		   end
		end
	end
end
function c98921075.filter(c)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA)
end
function c98921075.handcon(e)
	return Duel.IsExistingMatchingCard(c98921075.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
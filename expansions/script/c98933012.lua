--通往毁灭之路
function c98933012.initial_effect(c)
	c:SetUniqueOnField(1,0,98933012)
   	c:EnableCounterPermit(0xa9)
   	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(c98933012.cost)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCost(c98933012.cost)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c98933012.recon)
	e4:SetOperation(c98933012.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c98933012.recon)
	e5:SetOperation(c98933012.reop)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
		--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADD_COUNTER+0xa9)
	e7:SetCondition(c98933012.atkcon)
	e7:SetOperation(c98933012.atkop)
	c:RegisterEffect(e7)
	if not c98933012.global_check then
		c98933012.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c98933012.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98933012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetOwner()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>1 and Duel.GetFlagEffect(tp,98933012)>=1 end
	if e:GetHandler():IsLocation(LOCATION_DECK) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c98933012.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	if re:GetCode()==EVENT_SPSUMMON and re:GetHandler():IsType(TYPE_MONSTER) then Duel.RegisterFlagEffect(tp,98933012,RESET_CHAIN,0,1) end	
end
function c98933012.ecfilter(c,tp)
	return c:IsSummonPlayer(tp) and not c:IsSummonableCard() and c:IsSummonLocation(LOCATION_HAND)
end
function c98933012.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(98933012)>0 or (e:GetCode()~=EVENT_CHAIN_NEGATED)) and Duel.GetFlagEffect(tp,98933012)==0
end
function c98933012.tg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x11b)
	if chk==0 then return Duel.IsExistingMatchingCard(c98933012.filter,tp,0xff-LOCATION_HAND,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98933012.reop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c98933012.SSfilter,tp,0xff-LOCATION_HAND,0,1,nil) and e:GetHandler():IsCanAddCounter(0xa9,1) and Duel.SelectYesNo(tp,aux.Stringid(98933012,0)) then
	   Duel.RegisterFlagEffect(tp,98933012,RESET_CHAIN,0,1)
	   local c=e:GetHandler()
	   c:AddCounter(0xa9,1)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c98933012.SSfilter,tp,0xff-LOCATION_HAND,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		  local tc=g:GetFirst()
		  Duel.SpecialSummonRule(tp,tc)
	   end
	end   
end
function c98933012.SSfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsSummonableCard() and c:IsSpecialSummonable()
end
function c98933012.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xa9)==10
end
function c98933012.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end
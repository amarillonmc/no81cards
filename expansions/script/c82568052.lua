--方舟骑士-烟火家W
function c82568052.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x825),4,2)
	c:EnableReviveLimit()
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568052,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,82568052)
	e3:SetCost(c82568052.adcost)
	e3:SetTarget(c82568052.adtg)
	e3:SetOperation(c82568052.adop)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82568052.tgcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	--D12
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(82568031,1))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,82568152)
	e8:SetCondition(c82568052.descon)
	e8:SetTarget(c82568052.destg)
	e8:SetOperation(c82568052.desop)
	c:RegisterEffect(e8)
end
function c82568052.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end
function c82568052.tgcon(e)
	return Duel.IsExistingMatchingCard(c82568052.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c82568052.adfilter(c)
	return c:IsFaceup() 
end
function c82568052.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)  end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82568052.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup()  end
	if chk==0 then return Duel.IsExistingTarget(c82568052.adfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568052.adfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5822,1)
end
function c82568052.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
  then  tc:AddCounter(0x5822,1)
	end
end
function c82568052.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c82568052.desfilter(c)
	return c:IsFaceup() and c:GetCounter(0x5822)>0 
end
function c82568052.desfilter2(c,s)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 
end
function c82568052.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568052.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c82568052.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82568052.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(c82568052.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if c:IsRelateToEffect(e)  then
		local g=Duel.GetMatchingGroup(c82568052.desfilter,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		while tc do
		local seq=tc:GetSequence()
		local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(c82568052.desfilter2,tp,0,LOCATION_ONFIELD,nil,seq) end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		tc=g:GetNext()
		end
		end
	end
end
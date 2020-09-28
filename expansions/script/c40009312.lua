--时隙淑女 伊什比埃
function c40009312.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4f1d),nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x4f1d),2,2)
	c:EnableReviveLimit() 
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1) 
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_REMOVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_GRAVE)
	e2:SetTarget(c40009312.rmtg)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009312,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,40009312)
	e3:SetCost(c40009312.spcost)
	e3:SetTarget(c40009312.sptg)
	e3:SetOperation(c40009312.spop)
	c:RegisterEffect(e3)
end
function c40009312.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c40009312.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c40009312.spfilter(c,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsAbleToHand()
end
function c40009312.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	if chk==0 then return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
		and ct>0
		and mg:FilterCount(c40009312.spfilter,nil,c)==ct end
	Duel.SetTargetCard(mg)

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,mg,ct,tp,LOCATION_GRAVE)
end
function c40009312.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=mg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<mg:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		tc=g:GetNext()
	end
		Duel.ConfirmCards(1-tp,g)
end

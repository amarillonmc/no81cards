--魔法纪录·和美
function c9980248.initial_effect(c)
	c:EnableCounterPermit(0x1,LOCATION_MZONE+LOCATION_PZONE)
	c:SetCounterLimit(0x1,2)
   --pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980248,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,9980248)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c9980248.thtg)
	e3:SetOperation(c9980248.thop)
	c:RegisterEffect(e3)
	 --add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c9980248.acop)
	c:RegisterEffect(e3)
	 --add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c9980248.ctop)
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980248,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,99802480)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9980248.negcon)
	e2:SetTarget(c9980248.negtg)
	e2:SetOperation(c9980248.negop)
	c:RegisterEffect(e2)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9980248.sumtg)
	e2:SetOperation(c9980248.sumop)
	c:RegisterEffect(e2)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980248.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9980248.counter_add_list={0x1}
function c9980248.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980248,4))
end
function c9980248.thfilter1(c,tp)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and lv>0 and c:IsSetCard(0xbc4)
		and Duel.IsCanRemoveCounter(tp,1,0,0x1,lv,REASON_COST) and c:IsAbleToHand()
end
function c9980248.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980248.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c9980248.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9980248,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c9980248.thfilter2(c,lv)
	return (c:IsLocation(LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsCanAddCounter(0x1,1,false,LOCATION_MZONE)
		and c:IsLevel(lv) and c:IsAbleToHand()
end
function c9980248.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980248.thfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980248,4))
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980248.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c9980248.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
function c9980248.filter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsFaceup()
end
function c9980248.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c9980248.thfilter(c)
	return c:GetCounter(0x1)>0 and c:IsAbleToHand()
end
function c9980248.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980248.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function c9980248.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980248.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local count=tc:GetCounter(0x1)
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) and Duel.NegateActivation(ev)~=0
		and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(9980248,3)) then
			Duel.BreakEffect()
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980248,4))
			c:AddCounter(0x1,count)
		end
	end
end
function c9980248.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,9980248)==0 end
end
function c9980248.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9980248)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(9980248,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xbc4))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,9980248,RESET_PHASE+PHASE_END,0,1)
end

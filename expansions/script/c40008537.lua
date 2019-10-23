--卡通帝 厄瑞玻斯
function c40008537.initial_effect(c)
	c:EnableReviveLimit()
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c40008537.atklimit)
	c:RegisterEffect(e1)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c40008537.dircon)
	c:RegisterEffect(e5)
	--cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.FALSE)
	c:RegisterEffect(e6)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c40008537.spcon)
	e2:SetOperation(c40008537.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008537,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c40008537.tdcon)
	e3:SetTarget(c40008537.tdtg)
	e3:SetOperation(c40008537.tdop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008537,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCondition(c40008537.thcon)
	e4:SetCost(c40008537.thcost)
	e4:SetTarget(c40008537.thtg)
	e4:SetOperation(c40008537.thop)
	c:RegisterEffect(e4)	
end
function c40008537.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008537.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008537.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008537.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008537.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008537.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008537.rfilter(c,tp)
	return c:IsSetCard(0x62) and (c:IsControler(tp) or c:IsFaceup())
end
function c40008537.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c40008537.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c40008537.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c40008537.mzfilter,ct,nil,tp))
end
function c40008537.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c40008537.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c40008537.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c40008537.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end
function c40008537.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c40008537.tgfilter(c)
	return c:IsSetCard(0x62) and c:IsAbleToGrave()
end
function c40008537.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c40008537.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>1
			and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c40008537.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40008537.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if Duel.SendtoGrave(tg1,REASON_EFFECT)~=0 and tg1:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) then
		local sg=nil
		local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil)
		local op=0
		if not b1 and not b2 and not b3 then return end
		if b1 then
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(40008537,3),aux.Stringid(40008537,4),aux.Stringid(40008537,5))
			elseif b2 and not b3 then
				op=Duel.SelectOption(tp,aux.Stringid(40008537,3),aux.Stringid(40008537,4))
			elseif not b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(40008537,3),aux.Stringid(40008537,5))
				if op==1 then op=2 end
			else
				op=0
			end
		else
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(40008537,4),aux.Stringid(40008537,5))+1
			elseif b2 and not b3 then
				op=1
			else
				op=2
			end
		end
		if op==0 then
			sg=hg:RandomSelect(tp,1)
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(sg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
			Duel.HintSelection(sg)
		end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c40008537.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c40008537.cfilter(c)
	return c:IsSetCard(0x62) and c:IsDiscardable()
end
function c40008537.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008537.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c40008537.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c40008537.thfilter(c)
	return c:IsSetCard(0x62) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c40008537.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40008537.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008537.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40008537.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40008537.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

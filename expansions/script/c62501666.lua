--什弥尼斯的图腾
function c62501666.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	c:RegisterEffect(e1)
	--activate:select effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,62501666+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c62501666.cost)
	--e2:SetTarget(c62501666.target)
	e2:SetOperation(c62501666.activate)
	c:RegisterEffect(e2)
	c62501666.second_effect=e2
	--spirit may not return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xea2))
	e3:SetRange(LOCATION_HAND)
	e3:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e3)
	--return hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(62501666,4))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,62501666+1)
	e4:SetCondition(c62501666.rtcon)
	e4:SetTarget(c62501666.rttg)
	e4:SetOperation(c62501666.rtop)
	c:RegisterEffect(e4)
end
function c62501666.exfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c62501666.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c62501666.exfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501666,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c62501666.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_COST)
		e:SetLabel(1) else e:SetLabel(0)
	end
end
function c62501666.thfilter(c,typ)
	return c:IsSetCard(0xea2) and c:IsType(typ) and c:IsAbleToHand()
end
function c62501666.activate(e,tp,eg,ep,ev,re,r,rp)
	local op,sel=e:GetLabel()
	local b0=true
	local b1=Duel.IsExistingMatchingCard(c62501666.thfilter,tp,LOCATION_DECK,0,1,nil,0x1)
	local b2=Duel.IsExistingMatchingCard(c62501666.thfilter,tp,LOCATION_DECK,0,1,nil,0x6)
	local b3=b1 and b2 and op==1
	if not sel then
		sel=aux.SelectFromOptions(tp,
			{b0,aux.Stringid(62501666,4),0},
			{b1,aux.Stringid(62501666,1),1},
			{b2,aux.Stringid(62501666,2),2},
			{b3,aux.Stringid(62501666,2),3})
	end
	if sel==0 then return end
	if sel~=2 then c62501666.thop(e,tp,eg,ep,ev,re,r,rp,0x1) end
	if sel==3 then Duel.BreakEffect() end
	if sel~=1 then c62501666.thop(e,tp,eg,ep,ev,re,r,rp,0x6) end
end
function c62501666.thop(e,tp,eg,ep,ev,re,r,rp,typ)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c62501666.thfilter,tp,LOCATION_DECK,0,1,1,nil,typ)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c62501666.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xea2)
end
function c62501666.tfilter(c,p)
	return (c:IsControler(p) and c:IsSetCard(0xea2) and c:IsFaceup() or c:IsControler(1-p)) and c:IsAbleToHand()
end
function c62501666.gcheck(sg)
	return sg:FilterCount(Card.IsControler,nil,0)==1
end
function c62501666.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c62501666.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return g:CheckSubGroup(c62501666.gcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,c62501666.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c62501666.rtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end

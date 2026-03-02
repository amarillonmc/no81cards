--什弥尼斯之神迹
function c62501676.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c62501676.excondition)
	e0:SetCost(c62501676.excost)
	e0:SetDescription(aux.Stringid(62501676,4))
	c:RegisterEffect(e0)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	c:RegisterEffect(e1)
	--activate:select effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,62501676)
	e2:SetCondition(c62501676.condition)
	e2:SetCost(c62501676.cost)
	e2:SetTarget(c62501676.target)
	e2:SetOperation(c62501676.activate)
	c:RegisterEffect(e2)
	c62501676.second_effect=e2
end
c62501676.has_text_type=TYPE_SPIRIT
function c62501676.cfilter(c)
	return c:IsSetCard(0xea2) and c:IsFaceup()
end
function c62501676.excondition(e)
	return Duel.IsExistingMatchingCard(c62501676.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c62501676.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c62501676.exfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c62501676.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c62501676.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c62501676.exfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501676,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c62501676.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_COST)
		e:SetLabel(1) else e:SetLabel(0)
	end
end
function c62501676.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local exg=e:IsHasType(EFFECT_TYPE_ACTIVATE) and Group.FromCards(e:GetHandler()) or Group.CreateGroup()
	if not re then
		local i=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
		if i then re,rp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) end
	end
	if re then
		local rc=re:GetHandler()
		if rc:IsDestructable() and rc:IsRelateToEffect(re) then exg:AddCard(rc) end
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,exg)
	if chk==2 then return re and rp~=tp and #g>0 end
	if chk==0 then return true end
end
function c62501676.activate(e,tp,eg,ep,ev,re,r,rp)
	local i=ev and ev or Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	local op,sel=e:GetLabel()
	local b1=true
	local exg=aux.ExceptThisCard(e) and Group.FromCards(e:GetHandler()) or Group.CreateGroup()
	local b2=Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,exg)>0
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then exg:AddCard(rc) end
	local b3=b1 and Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,exg)>0 and op==1
	if not sel then
		sel=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(62501676,1),1},
			{b2,aux.Stringid(62501676,2),2},
			{b3,aux.Stringid(62501676,2),3})
	end
	if sel~=2 then c62501676.disop(e,tp,eg,ep,i,re,r,rp) end
	if sel==3 then Duel.BreakEffect() end
	if sel~=1 then c62501676.thop(e,tp,eg,ep,ev,re,r,rp) end
end
function c62501676.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c62501676.sumfilter(c)
	return c:IsSetCard(0xea2) and c:IsSummonable(true,nil)
end
function c62501676.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(c62501676.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501676,5)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=Duel.SelectMatchingCard(tp,c62501676.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	end
end

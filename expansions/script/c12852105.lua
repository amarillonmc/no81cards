--转天魔具-飞行扫帚
function c12852105.initial_effect(c)
	aux.AddCodeList(c,12852102)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c12852105.target)
	e1:SetOperation(c12852105.operation)
	c:RegisterEffect(e1)	
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852105.eqlimit)
	c:RegisterEffect(e3)  
	--move
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(12852105,0))
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetCountLimit(1)
	e12:SetTarget(c12852105.seqtg)
	e12:SetOperation(c12852105.seqop)
	c:RegisterEffect(e12)  
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12852105,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_MOVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,12852107)
	e4:SetCondition(c12852105.descon)
	e4:SetTarget(c12852105.destg)
	e4:SetOperation(c12852105.desop)
	c:RegisterEffect(e4)
end
function c12852105.eqlimit(e,c)
	return c:IsRace(RACE_SPELLCASTER) or c:IsCode(12852102)
end
function c12852105.eqfilter1(c)
	return c:IsFaceup() and (c:IsRace(RACE_SPELLCASTER) or c:IsCode(12852102))
end
function c12852105.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12852105.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852105.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12852105.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852105.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
function c12852105.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c12852105.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	if c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	local ch=Duel.GetCurrentChain()
	if ch>1 then
		local p,tg=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TARGET_CARDS)
		if p==1-tp and tg and tg:IsContains(e:GetHandler():GetEquipTarget()) then
			Duel.NegateEffect(ch-1)
		end
	end
end
function c12852105.cfilter(c,tp,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=tp) and c==e:GetHandler():GetEquipTarget()
end
function c12852105.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12852105.cfilter,1,nil,tp,e)
end
function c12852105.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 and #g1>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12852105.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	g:Merge(g1)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end








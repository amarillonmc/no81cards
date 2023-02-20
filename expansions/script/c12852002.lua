--lycoris-锦木千束
function c12852002.initial_effect(c)
	c:SetUniqueOnField(1,0,12852002)
	--to hand
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(12852002,1))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,12852003)
	e12:SetTarget(c12852002.thtg)
	e12:SetOperation(c12852002.thop)
	c:RegisterEffect(e12)
	--move
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(12852002,2))
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetCountLimit(1,12852004)
	e14:SetTarget(c12852002.seqtg)
	e14:SetOperation(c12852002.seqop)
	c:RegisterEffect(e14)
end
function c12852002.filter(c)
	return c:IsSetCard(0xa75) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c12852002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12852002.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12852002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12852002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12852002.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c12852002.fselect(g,c)
	return g:IsContains(c)
end
function c12852002.chfilter(c)
	return c:IsFaceup() and c:IsCode(12852001) and c:GetSequence()<5
end
function c12852002.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp)or (Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 and not Duel.IsExistingMatchingCard(c12852002.chfilter,tp,LOCATION_MZONE,0,1,nil)) then return end
	if not Duel.IsExistingMatchingCard(c12852002.chfilter,tp,LOCATION_MZONE,0,1,nil) or not Duel.SelectYesNo(tp,aux.Stringid(12852002,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		local pseq=c:GetSequence()
		Duel.MoveSequence(c,seq)
	else
		local g=Duel.GetMatchingGroup(c12852002.chfilter,tp,LOCATION_MZONE,0,nil)
		g:AddCard(c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:SelectSubGroup(tp,c12852002.fselect,false,2,2,c)
		if sg and sg:GetCount()==2 then
			Duel.HintSelection(sg)
			local tc1=sg:GetFirst()
			local tc2=sg:GetNext()
			Duel.SwapSequence(tc1,tc2)
		end  
	end
end
al tc2=sg:GetNext()
			Duel.SwapSequence(tc1,tc2)
		end  
	end
end

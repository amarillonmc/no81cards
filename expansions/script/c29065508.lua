--方舟骑士-陈
function c29065508.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065508,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,29065509)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCost(c29065508.btcost)
	e2:SetTarget(c29065508.bttg)
	e2:SetOperation(c29065508.btop)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29065508,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,29065508)
	e6:SetCost(c29065508.btcost)
	e6:SetTarget(c29065508.thtg)
	e6:SetOperation(c29065508.thop)
	c:RegisterEffect(e6)
end
function c29065508.amyfilter(c)
	return c:IsCode(29065500) and c:IsFaceup()
end
function c29065508.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c29065508.thfilter2(c)
	return ((c:IsSetCard(0x87af) and c:IsType(TYPE_TRAP)) or aux.IsCodeListed(c,29065500)) and c:IsAbleToHand()
end
function c29065508.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065508.thfilter,tp,LOCATION_DECK,0,1,nil) or (Duel.IsExistingMatchingCard(c29065508.amyfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c29065508.thfilter2,tp,LOCATION_DECK,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065508.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if not Duel.IsExistingMatchingCard(c29065508.amyfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		g=Duel.SelectMatchingCard(tp,c29065508.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	else g=Duel.SelectMatchingCard(tp,c29065508.thfilter2,tp,LOCATION_DECK,0,1,1,nil) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29065508.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x87af)
end
function c29065508.btcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065508.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and c:IsAttackable() and Duel.GetTurnCount()~=1 end
	--c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function c29065508.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	   -- local tc=nil
	   -- local tg=g:GetMinGroup(Card.GetAttack)
	   -- if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		--else
		--  tc=tg:GetFirst()
		--end
		if tc:IsType(TYPE_MONSTER) and tc:IsCanBeBattleTarget(c) and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c29065508.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end











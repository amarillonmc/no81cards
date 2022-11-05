local m=15004316
local cm=_G["c"..m]
cm.name="零场实体-A01"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,15004316)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--Return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,15004316)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,15004317)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,15004318)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.ztg)
	e4:SetOperation(cm.zop)
	c:RegisterEffect(e4)
end
function cm.thfilter(c)
	return c:IsCode(15000382,15000384) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,2,nil)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetLeftScale()==0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsPlayerAffectedByEffect(tp,15000385) then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	else
		e:SetCategory(CATEGORY_DAMAGE)
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function cm.th2filter(c)
	return c:IsSetCard(0xaf30) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(15004316)
end
function cm.zop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local b1=(Duel.IsExistingMatchingCard(cm.th2filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,15000385))
	local b2=(Duel.IsPlayerAffectedByEffect(tp,15000383))
	local op=0
	local op2=7
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,7))
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,9))
		if op==0 then
			op2=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
		end
		if op==1 then
			op2=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,2))
			if op2==1 then op2=2 end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,8))
	if b1 and not b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,2))
		if op==1 then op=2 end
	end
	if b2 and not b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	end
	if not b1 and not b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+2
	end
	if op~=2 then
		Duel.BreakEffect()
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.th2filter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		if op==1 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetTarget(cm.c2filter)
			e2:SetValue(1)
			Duel.RegisterEffect(e2,tp)
		end
		if op2==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,cm.th2filter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		if op2==1 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetTarget(cm.c2filter)
			e2:SetValue(1)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.c2filter(e,c)
	return c:IsFaceup() and c:GetLeftScale()==0
end
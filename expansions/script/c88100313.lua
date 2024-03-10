--迷影使徒 彩花
function c88100313.initial_effect(c)
	aux.AddXyzProcedure(c,c88100313.mfilter,5,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88100313,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c88100313.thcon)
	e1:SetTarget(c88100313.thtg)
	e1:SetOperation(c88100313.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c88100313.recon)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5590))
	e3:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88100313,1))
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,88100313)
	e5:SetCondition(c88100313.drcon)
	e5:SetTarget(c88100313.drtg)
	e5:SetOperation(c88100313.drop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c88100313.zcop)
	c:RegisterEffect(e6)
end
function c88100313.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c88100313.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100313.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x5590) and c:IsAbleToHand()
end
function c88100313.gcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)==1
end
function c88100313.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c88100313.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c88100313.gcheck,3,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c88100313.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88100313.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local sg=g:SelectSubGroup(tp,c88100313.gcheck,false,3,3)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,2,nil)
		if dg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(dg,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
function c88100313.recon(e)
	return e:GetHandler():IsFaceup()
end
function c88100313.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100313.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=6-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct1>0 and Duel.IsPlayerCanDraw(tp,ct1) and ct2>0 and Duel.IsPlayerCanDraw(1-tp,ct2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,ct1+ct2)
end
function c88100313.drop(e,tp,eg,ep,ev,re,r,rp)
	local bk=true
	local st=0
	for p in aux.TurnPlayers() do
		local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
		if 6-ct>0 then
			if bk then
				bk=false
				Duel.BreakEffect()
			end
			Duel.Draw(p,6-ct,REASON_EFFECT)
			st=st+p+1
		end
	end
	if st~=0 then
		local bk=true
		for p in aux.TurnPlayers() do
			local ct=Duel.GetFieldGroupCount(p,LOCATION_MZONE,0)
			if ct>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.GetFieldGroup(p,LOCATION_HAND,0):Select(tp,ct,ct,nil)
				if g:GetCount()>0 then
					if bk then
						bk=false
						Duel.BreakEffect()
					end
					Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				end
			end
		end
	end
end
function c88100313.zcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(88100313,8))
	Duel.Hint(24,0,aux.Stringid(88100313,3))
	Duel.Hint(24,0,aux.Stringid(88100313,4))
	Duel.Hint(24,0,aux.Stringid(88100313,5))
	Duel.Hint(24,0,aux.Stringid(88100313,6))
	Duel.Hint(24,0,aux.Stringid(88100313,7))
end
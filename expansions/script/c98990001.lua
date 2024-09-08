--释武怀儒 陆逊
function c98990001.initial_effect(c)
	c:EnableCounterPermit(0xada)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98990001,2))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c98990001.ttcon)
	e1:SetOperation(c98990001.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c98990001.setcon)
	c:RegisterEffect(e2)	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98990001,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c98990001.thtg)
	e3:SetOperation(c98990001.thop)
	c:RegisterEffect(e3)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c98990001.acop)
	c:RegisterEffect(e1)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98990001,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c98990001.datop)
	c:RegisterEffect(e3)
	--win
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetOperation(c98990001.winop)
	c:RegisterEffect(e2)
end
function c98990001.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c98990001.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c98990001.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c98990001.thfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c98990001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98990001.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98990001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g2:GetCount()==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g2:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c98990001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98990001.acop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and (Duel.GetFlagEffect(re:GetHandlerPlayer(),98990001)~=0 or re:GetHandler():IsType(TYPE_QUICKPLAY)) and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		e:GetHandler():AddCounter(0xada,1)
		if e:GetHandler():GetCounter(0xada)%3==0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
function c98990001.datop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),98990001,EVENT_PHASE+PHASE_END,0,1,0)
	c:RegisterFlagEffect(98990001,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98990001,0))
end
function c98990001.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_DESTINY_LEO=0xad
	local c=e:GetHandler()
	if c:GetCounter(0xada)==24 then
		Duel.Win(tp,WIN_REASON_DESTINY_LEO)
	end
end
--三和弦歌手 加莲
function c9910054.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9910054.splimit)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910054)
	e2:SetCondition(c9910054.thcon)
	e2:SetTarget(c9910054.thtg)
	e2:SetOperation(c9910054.thop)
	c:RegisterEffect(e2)
	c9910054.triad_onfield_effect=e2
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9910094)
	e3:SetCost(c9910054.imcost)
	e3:SetOperation(c9910054.imop)
	c:RegisterEffect(e3)
end
function c9910054.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(9910626)
end
function c9910054.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9910054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=9 end
end
function c9910054.thfilter(c)
	return c:IsSetCard(0x6957) and c:IsAbleToHand()
end
function c9910054.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return false end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.ConfirmDecktop(tp,9)
	local g=Duel.GetDecktopGroup(tp,9)
	if #g~=9 then return end
	local ct=g:FilterCount(Card.IsCode,nil,9910051)
	if ct>0 and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910054,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:FilterSelect(tp,Card.IsAbleToHand,1,ct,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleHand(tp)
	end
	if ct==0 and Duel.IsExistingMatchingCard(c9910054.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910054,1)) then
		Duel.BreakEffect()
		local sg2=Duel.SelectMatchingCard(tp,c9910054.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
	Duel.ShuffleDeck(tp)
end
function c9910054.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST)
end
function c9910054.imop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910054.imcon2)
	e1:SetOperation(c9910054.imop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910054.imcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActivated() and Duel.GetFlagEffect(tp,9910054)==0 and Duel.GetFlagEffect(tp,9910094)==0
end
function c9910054.imop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,9910054,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(c9910054.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(re)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c9910054.spcon)
	e2:SetOperation(c9910054.spop)
	e2:SetLabelObject(re)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetCondition(c9910054.spcon)
	e3:SetOperation(c9910054.resetop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c9910054.efilter(e,te)
	return te==e:GetLabelObject()
end
function c9910054.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910054.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9910094)==0 then Duel.RegisterFlagEffect(tp,9910094,RESET_PHASE+PHASE_END,0,1) end
	if not (re and e:GetLabelObject() and re==e:GetLabelObject()) then return end
	Duel.Hint(HINT_CARD,0,9910054)
end
function c9910054.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,9910054)
end

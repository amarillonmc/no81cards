--人理之星 德雷克
function c22021400.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c22021400.lcheck)
	c:EnableReviveLimit()
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22021400,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c22021400.dtcon)
	e1:SetTarget(c22021400.dttg)
	e1:SetOperation(c22021400.dtop)
	c:RegisterEffect(e1)
	--to deck top ere
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021400,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c22021400.dtcon1)
	e2:SetCost(c22021400.erecost)
	e2:SetTarget(c22021400.dttg)
	e2:SetOperation(c22021400.dtop)
	c:RegisterEffect(e2)
	--conter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021400,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22021400)
	e3:SetCondition(c22021400.hdcon)
	e3:SetOperation(c22021400.xyzop)
	c:RegisterEffect(e3)
	--conter ere
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22021400,4))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,22021400)
	e4:SetCost(c22021400.erecost)
	e4:SetCondition(c22021400.hdcon1)
	e4:SetOperation(c22021400.xyzop)
	c:RegisterEffect(e4)
end
function c22021400.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c22021400.dtcon(e,tp,eg,ep,ev,re,r,rp)
	local ex=re:IsHasCategory(CATEGORY_DRAW)
	return ex and Duel.IsChainDisablable(ev)
end
function c22021400.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xff1) end
end
function c22021400.dtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22021400,1))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0xff1)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c22021400.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22021400.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and (eg:IsExists(c22021400.cfilter,1,nil,1-tp) or eg:IsExists(c22021400.cfilter,1,nil,tp))
end
function c22021400.xyzop(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22021400.discon)
		e1:SetOperation(c22021400.disop)
		Duel.RegisterEffect(e1,tp)
end
function c22021400.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffect(22021400)==0 and ep~=tp
end
function c22021400.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:GetHandler():RegisterFlagEffect(22021400,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_CARD,0,22021400)
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end
function c22021400.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22021400.dtcon1(e,tp,eg,ep,ev,re,r,rp)
	local ex=re:IsHasCategory(CATEGORY_DRAW)
	return ex and Duel.IsChainDisablable(ev) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22021400.hdcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and (eg:IsExists(c22021400.cfilter,1,nil,1-tp) or eg:IsExists(c22021400.cfilter,1,nil,tp)) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
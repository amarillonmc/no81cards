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
	e1:SetCost(c22021400.disrmcost)
	e1:SetCondition(c22021400.dtcon)
	e1:SetTarget(c22021400.dttg)
	e1:SetOperation(c22021400.dtop)
	c:RegisterEffect(e1)
	--xyz
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
end
function c22021400.disrmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22021400)==0 end
	c:RegisterFlagEffect(22021400,RESET_CHAIN,0,1)
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
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end
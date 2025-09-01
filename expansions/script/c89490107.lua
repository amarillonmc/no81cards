--慈在天·兽水军
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tecon)
	e1:SetCost(s.tecost)
	e1:SetTarget(s.tetg)
	e1:SetOperation(s.teop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(s.rscon)
	e2:SetTarget(s.rstg)
	e2:SetOperation(s.rsop)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function s.tecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.tecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,89490087)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return fe or b2 end
	local op=aux.SelectFromOptions(tp,{fe,fe and fe:GetDescription() or nil},{b2,1150})
	if op==1 then
		Duel.Hint(HINT_CARD,0,89490087)
		fe:UseCountLimit(tp)
		Duel.Remove(fe:GetHandler(),POS_FACEUP,REASON_COST)
	else
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
	end
end
function s.tefilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xc37) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetCode()) and c:IsCanBeEffectTarget(e)
end
function s.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and s.tefilter(chkc,e,tp) end
	local g=Duel.GetMatchingGroup(s.tefilter,tp,LOCATION_PZONE,0,nil,e,tp)
	if chk==0 then return g:GetClassCount(Card.GetCode)==2 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,2,0,0)
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		local sg1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tc1:GetCode())
		local sg2=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tc2:GetCode())
		Duel.SendtoExtraP(sg1+sg2,nil,REASON_EFFECT)
	end
end
function s.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
end
function s.rstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsSetCard(0xc37) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0xc37) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_PZONE,0,1,1,nil,0xc37)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=0
	local sel=0
	if tc:GetLeftScale()<=1 then
		sel=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	end
	if sel==0 then ct=1 end
	if sel==1 then ct=-1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	tc:RegisterEffect(e2)
end

--恶魔蔷薇龙
function c98920407.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	 --immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920407,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98920407.immcon)
	e2:SetTarget(c98920407.destg)
	e2:SetOperation(c98920407.immop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920407,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c98920407.negcon)
	e3:SetTarget(c98920407.negtg)
	e3:SetOperation(c98920407.negop)
	c:RegisterEffect(e3)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920407,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c98920407.ctcon)
	e4:SetTarget(c98920407.cttg)
	e4:SetOperation(c98920407.ctop)
	c:RegisterEffect(e4) 
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c98920407.negcon1)
	e5:SetOperation(c98920407.negop1)
	c:RegisterEffect(e5)
end
function c98920407.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
		and e:GetHandler():GetFlagEffect(98920407)<=0
end
function c98920407.negop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,98920407)
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c98920407.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)  
		end
		c:RegisterFlagEffect(98920407,RESET_EVENT+RESETS_STANDARD,0,1) 
	end
end
function c98920407.immcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
		and g:IsExists(Card.IsSetCard,1,nil,0x1123)
end
function c98920407.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920407.immop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c98920407.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98920407.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and g:IsExists(Card.IsRace,1,nil,RACE_PLANT)
end
function c98920407.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920407.negop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c98920407.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function c98920407.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c98920407.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(Duel.GetFieldGroup(tp,0,LOCATION_GRAVE),POS_FACEUP,REASON_EFFECT)
end
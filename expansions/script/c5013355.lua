--蓝染惣右介
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),7,7)
	c:EnableReviveLimit()
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMaterialCount()==7 then
		--sp summon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(s.con)
		e1:SetOperation(s.op)
		c:RegisterEffect(e1)
		--quick
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_BE_BATTLE_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCondition(s.qcon)
		e2:SetOperation(s.qop)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,5))
	end
end 


function s.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD)~=0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and (Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,nil))
end
function s.cfilter(c)
	return c:IsOnField() or c:IsAbleToDeck()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectEffectYesNo(tp,e:GetHandler()) then return end
	Duel.Hint(HINT_CARD,0,5013355)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(1-tp,s.cfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,1,nil):GetFirst()
	if not tc then return end
	if not tc:IsOnField() or not Duel.SelectYesNo(1-tp,aux.Stringid(5013355,0)) then
	   Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	else
	   Duel.Destroy(tc,REASON_EFFECT)
	end
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and ((re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE) or re:IsActiveType(EFFECT_TYPE_ACTIVATE))
end
function s.defilter(c)
	return c:IsAbleToDeck() or c:IsLocation(LOCATION_ONFIELD)  
end
function s.frepop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.defilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsAbleToDeck() and (not tc:IsLocation(LOCATION_ONFIELD) or Duel.SelectOption(tp,aux.Stringid(id,4),1105)==1) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.defilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) 
		and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,s.frepop)
	end
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and d:IsControler(tp)
end
function s.aefilter(c)
	return (c:IsFaceup() and c:GetAttack()~=0) or (not c:IsLocation(LOCATION_MZONE))
end
function s.qop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.aefilter,tp,0,LOCATION_ONFIELD,1,nil) 
		and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.NegateAttack()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,s.aefilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_MZONE) and (not tc:IsFaceup() or tc:GetAttack()==0 or Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==1) then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-tc:GetAttack())
		end
	end
end

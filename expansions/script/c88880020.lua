--界徐盛
function c88880020.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCountLimit(1,88880020)
	e1:SetCondition(c88880020.condition)
	e1:SetOperation(c88880020.sop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88880020.con)
	e2:SetOperation(c88880020.op)
	c:RegisterEffect(e2)
end
function c88880020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c88880020.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)>0
end
function c88880020.filter(c)
	return c:IsAbleToRemove()
end
function c88880020.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetMatchingGroupCount(c88880020.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if num>=4 then
		local g=Duel.SelectMatchingCard(tp,c88880020.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,4,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetOperation(c88880020.rmop)
		Duel.RegisterEffect(e1,tp)
	else
		local g=Duel.SelectMatchingCard(tp,c88880020.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,num,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetOperation(c88880020.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c88880020.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	g:DeleteGroup()
	e:Reset()
end
function c88880020.con(e,tp,eg,ep,ev,re,r,rp)
	local num1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)
	local num2=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND,nil)
	local num3=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	local num4=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	return num1>num2 and num3>num4
end
function c88880020.op(e,tp,eg,ep,ev,re,r,rp) 
	Duel.ChangeBattleDamage(ep,ev*2)
end

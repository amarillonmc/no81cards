-- 恋爱头脑战-小野寺丽
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12819165)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--e1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.pdtg)
	e1:SetOperation(s.pdop)
	c:RegisterEffect(e1)
	--e2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.mtg)
	e2:SetOperation(s.mop)
	c:RegisterEffect(e2)
	s.self_summon_effect=e2
end
function s.pfilter(c)
	return c:IsSetCard(0x3a73)
end
function s.dcheck(g,tp)
	return g:IsExists(Card.IsControler,1,nil,tp) and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.pdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.pfilter,tp,LOCATION_PZONE,0,1,nil) 
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.pfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,0)
end
function s.pdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(function(e,te,tp)
			return te:GetHandler():IsCode(id) and te:IsActiveType(TYPE_MONSTER)
		end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.mfilter(c)
	return c:IsSetCard(0x3a73) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.mfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,s.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:Merge(g2)
end
function s.filter(c)
	return c:IsCode(12819165) and c:IsFaceup()
end
function s.mop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local b=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil) and g:IsExists(Card.IsAbleToRemove,2,nil)
	if b and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e,te,tp)
		return te:GetHandler():IsCode(id) and te:IsActiveType(TYPE_SPELL) and te:GetHandler():GetLocation(LOCATION_PZONE)
	end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
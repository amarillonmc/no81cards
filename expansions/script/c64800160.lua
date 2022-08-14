--燃煤大巡洋舰 八云
local s,id,o=GetID()
Duel.LoadScript("c64800150.lua")
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	RMJ_02.word(c)
	RMJ_02.pen(c,id)
	--des
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--neg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+10000)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)	
end

--e1
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end

--e2
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(RMJ_02.rmf,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,RMJ_02.rmf,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,e:GetLabel()))
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(RMJ_02.pf,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,RMJ_02.pf,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local atk=0
		if tc:IsLocation(LOCATION_MZONE) then
			atk=tc:GetAttack()
		else
			atk=tc:GetBaseAttack()
		end
		--disable
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVING)
		e4:SetLabel(atk)
		e4:SetCondition(s.discon)
		e4:SetOperation(s.disop)
		e4:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e4,tp)
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()<=e:GetLabel()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
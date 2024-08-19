--动物朋友的决意
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.tgfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
		and not c:IsPublic()
end
function s.tgfilter(c)
	return c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.cfilter(c)
	return c:IsSetCard(0x442)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		local atk=tc:GetAttack()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
		local tg=nil
		if sg:GetClassCount(Card.GetCode)>=10 then
			tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
		else
			tg=Duel.SelectMatchingCard(1-tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
		end
		if tg:GetCount()>0 then
			local atk2=tg:GetFirst():GetAttack()
			Duel.BreakEffect()
			Duel.SendtoGrave(tg,REASON_EFFECT)
			if atk2>atk then
				Duel.Damage(tp,(atk2-atk)*2,REASON_EFFECT)
			end
		end
	end
end
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
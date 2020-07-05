--喀兰贸易·辅助干员-初雪
function c79029070.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c79029070.matfilter,2,3)
	c:EnableReviveLimit()   
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c79029070.atktg)
	e1:SetValue(-700)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)	
	--atk/def 2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetOperation(c79029070.dsop)
	e3:SetCountLimit(1,79029070)
	c:RegisterEffect(e3)
	--destory
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,7902907099999999999)
	e4:SetCondition(c79029070.thcon2)
	e4:SetTarget(c79029070.thtg2)
	e4:SetOperation(c79029070.thop2)
	c:RegisterEffect(e4) 
end
function c79029070.matfilter(c)
	return c:IsLinkSetCard(0xa900)
end
function c79029070.atktg(e,c)
	return c:GetMutualLinkedGroupCount()==0
end
function c79029070.dsop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then	
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(c79029070.atkval)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
end
end
function c79029070.atkval(e,c)
	 return c:GetAttack()/-2
end
function c79029070.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029070.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c79029070.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029070.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c79029070.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c79029070.thop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c79029070.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
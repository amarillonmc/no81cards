--凶堕魔凰
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.fuf,2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
--fu
function cm.fuf(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and (not sg or sg:FilterCount(aux.TRUE,c)==0
		or sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local dg=Group.CreateGroup()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-2000)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsRace,1,nil,RACE_FIEND)
end
function cm.opf3(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x3fd5,0xfd6)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.opf3,tp,LOCATION_GRAVE,0,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and #g>3 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		g = g:Select(tp,4,4,e:GetHandler())
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

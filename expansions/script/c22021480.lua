--人理之基 高文
function c22021480.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	e1:SetCondition(c22021480.attcon)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22021480.atkcon)
	e2:SetValue(7200)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c22021480.atkcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c22021480.attcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==3 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==4 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==5 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==0 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==9 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==10 or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,LOCATION_HAND)==11
end
function c22021480.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
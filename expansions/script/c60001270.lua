--淘气仙星·夜华莉莉丝
local cm,m,o=GetID()
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfb),2,2)
	c:SetUniqueOnField(1,0,m)
	c:EnableReviveLimit()
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandlerPlayer()==1-tp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_BATTLE)==0 and re
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xfb)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local r=0
	if e:GetLabel() then r=e:GetLabel() end
	r=r+ev
	for r>=600 do
		r=r-600
		Duel.Draw(tp,1,REASON_EFFECT)
		local rvc=Duel.GetDecktopGroup(1-tp,1)
		Duel.Remove(rvc,POS_FACEDOWN,REASON_EFFECT)
	end
end












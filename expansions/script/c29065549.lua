--方舟骑士-风笛
c29065549.named_with_Arknight=1
function c29065549.initial_effect(c)
	c:EnableCounterPermit(0x10ae)
	c:SetSPSummonOnce(29065549)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c29065549.matfilter,1,1)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065549,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c29065549.cocon)
	e1:SetOperation(c29065549.coop)
	c:RegisterEffect(e1)
end
function c29065549.matfilter(c)
	return c:IsLinkSetCard(0x87af) or (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065549.cocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanAddCounter(0x10ae,1) and e:GetHandler():IsRelateToBattle()
end
function c29065549.coop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local n=1 
	c:AddCounter(0x10ae,n)
end
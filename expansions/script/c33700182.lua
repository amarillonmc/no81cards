--动物朋友 刑部狸
local m=33700182
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(m,0))
	Senya.AddAttackSE(c,aux.Stringid(m,1))
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function cm.con(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),0,LOCATION_GRAVE)
	return g:GetClassCount(Card.GetCode)<g:GetCount() and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(33700182) and c:IsFaceup() end,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
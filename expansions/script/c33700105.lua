--动物朋友 稻荷神
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700105.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(33700105,0))
	Senya.AddAttackSE(c,aux.Stringid(33700105,1))
	   --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33700105.imtg)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(c33700105.con)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c33700105.imtg)
	e2:SetValue(c33700105.indct)
	c:RegisterEffect(e2)
end
function c33700105.imtg(e,c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700105.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),0,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700105.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
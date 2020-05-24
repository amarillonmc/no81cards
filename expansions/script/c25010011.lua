--海洋之光 阿古茹V2
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010011)
function cm.initial_effect(c)
	rsgol.GaiaSummonFun(c,m,9,nil,25010008,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),true)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.sprcon,cm.sprop,{25010001,0})
	e1:SetValue(SUMMON_TYPE_XYZ)
	local e2,e3=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	--local e4=rsef.SV_IMMUNE_EFFECT(c,cm.imval)
	local e5=rsef.SV_CANNOT_BE_TARGET(c,"effect",aux.tgoval)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=rsef.QO_NEGATE(c,"neg",{1,m},nil,LOCATION_MZONE,rscon.negcon(4,true),rscost.rmxyz(1))
end
function cm.cfilter(c)
	return c:IsAbleToExtraAsCost() and c:IsCode(m-1)
end
function cm.sprcon(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.sprop(e,tp)
	rsop.SelectToDeck(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,{})
end
function cm.imval(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
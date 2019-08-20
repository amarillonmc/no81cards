--幻层驱动 联动骨架
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130008
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.FV_CANNOT_BE_TARGET(c,"effect",aux.tgoval,aux.TargetBoolFunction(Card.IsSetCard,0xa336),{LOCATION_MZONE,0},cm.con)
	local e3=rsef.FV_INDESTRUCTABLE(c,"effect",aux.indoval,cm.tg,{LOCATION_ONFIELD,0},cm.con)
	local e4=rsef.FV_IMMUNE_EFFECT(c,rsval.imoe,cm.imtg,{LOCATION_ONFIELD,0},cm.con2)
	local e5=rsqd.ContinuousFun(c)
end
function cm.cfilter(c)
	return c:IsSetCard(0xa336) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,2,nil)
end
function cm.cfilter2(c)
	return c:IsSetCard(0xa336) or c:IsFacedown()
end
function cm.con2(e,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,2,nil)
end
function cm.tg(e,c)
	return c:IsSetCard(0xa336) or c:IsFacedown()
end
function cm.imtg(e,c)
	return c:IsSetCard(0xa336) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
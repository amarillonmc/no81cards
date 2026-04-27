--Cappuccino Flavor
if not pcall(function() require("expansions/script/c700021") end) then require("script/c700021") end
local m,cm = rscf.DefineCard(700025,"Breath")
function cm.initial_effect(c)
	local e1,e2,e3,e4 = rsbh.ExMonFun(c,m,LOCATION_SZONE,1)
	e4:SetCountLimit(999)
	e3 = rsef.FC(c,EVENT_CHAINING,nil,nil,nil,LOCATION_MZONE,cm.exmvcon2,cm.exmvop2)
	rsbh.ContinuousLimit(e3,m,m)
	local e6 = rsef.I(c,"dr",1,"dr",nil,LOCATION_SZONE,nil,rscost.cost(cm.cfilter,"dish",LOCATION_HAND),rsop.target(2,"dr"),cm.drop)
	--Trap activate in set turn
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetCountLimit(1,m+200)
	c:RegisterEffect(e5)
end
function cm.exmvcon2(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():CheckUniqueOnField(tp,LOCATION_SZONE)
end
function cm.exmvop2(e,tp)
	rsbh.MoveSZone(e:GetHandler(),e:GetHandler(),tp)
end
function cm.cfilter(c)
	return c:IsDiscardable() and (c:IsComplexType(TYPE_CONTINUOUS+TYPE_TRAP) or rsbh.IsSet(c))
end
function cm.drop(e,tp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
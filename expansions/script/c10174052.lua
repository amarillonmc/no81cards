--神龙 末日预言龙
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174052)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rsef.SV_IMMUNE_EFFECT(c,cm.imval)
	local e2=rsef.QO(c,nil,{m,0},1,"eq",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.eqfilter,"eq",LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c),cm.eqop)
	local e3=rsef.SV_UPDATE(c,"atk",cm.adval(Card.GetAttack))
	local e4=rsef.SV_UPDATE(c,"def",cm.adval(Card.GetDefense))
	local e5=rsef.I(c,{m,1},nil,nil,nil,LOCATION_MZONE,nil,rscost.cost(cm.rmfilter,"rm",LOCATION_SZONE,LOCATION_SZONE,2),nil,cm.lpop)
end
function cm.imval(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function cm.eqfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function cm.eqop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	rshint.Select(tp,"eq")
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c,e,tp)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	if not tc or not rsop.eqop(e,tc,c,false) then return end
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m)>0
end
function cm.adval(valfun)
	return function(e,c)
		local val=0
		local g=c:GetEquipGroup():Filter(cm.cfilter,nil)
		return g:GetSum(valfun)
	end
end
function cm.rmfilter(c,e)
	return c:GetEquipTarget() and c:GetEquipTarget()==e:GetHandler() and c:GetFlagEffect(m)>0 and c:IsAbleToRemoveAsCost()
end
function cm.lpop(e,tp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end

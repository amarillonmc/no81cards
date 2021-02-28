--古代龙的勇武
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009462)
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e3=rsef.FV_INDESTRUCTABLE(c,"battle",1,cm.indtg,{ LOCATION_MZONE,LOCATION_MZONE })
	local e4=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,"th",{1,m},"th","de,tg",LOCATION_SZONE,nil,nil,rstg.target({cm.thfilter1,"th",LOCATION_GRAVE },{cm.thfilter2,"th",LOCATION_GRAVE }),cm.thop)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function cm.indtg(e,c)
	return c:GetFlagEffect(40009452)>0 and c:IsType(TYPE_RITUAL)
end
function cm.cfilter(c,rc)
	if not c:IsSummonType(SUMMON_TYPE_RITUAL) then return false end
	local mat=c:GetMaterial()
	return mat:IsContains(rc)
end
function cm.thfilter1(c,e,tp,eg)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and eg:IsExists(cm.cfilter,1,nil,c) and c:IsReason(REASON_RELEASE)
end
function cm.cfilter2(c,rc)
	if not c:IsSummonType(SUMMON_TYPE_RITUAL) then return false end
	return c:GetReasonEffect():GetHandler() == rc 
end
function cm.thfilter2(c,e,tp,eg)
	return c:IsAbleToHand() and c:IsComplexType(TYPE_RITUAL+TYPE_SPELL) and eg:IsExists(cm.cfilter2,1,nil,c)
end
function cm.thop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--虚拟水神天使
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020208,"VrAqua")
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_HAND,cm.spcon,nil,rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"sum",nil,LOCATION_MZONE,rscon.phmp,rscost.cost(Card.IsAbleToHandAsCost,"th"),rsop.target(rsva.mesumfilter,"sum",LOCATION_HAND),cm.sumop)
end
function cm.cfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function cm.spcon(e,tp)
	local b1=Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(cm.cfilter1,tp,0,LOCATION_MZONE,1,nil)
	local b2=not Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_SPECIAL) and Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL)
	return b1 or b2
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.sumop(e,tp)
	local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"act",cm.val,nil,{0,1},nil,rsreset.pend)
	rsva.Summon(tp,false,false,rsva.mesumfilter)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsLevel(10)
end
function cm.val(e,re)
	local rc=re:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	local ag,atk=g:GetMaxGroup(Card.GetAttack)
	return rc:IsType(TYPE_MONSTER) and #g>0 and rc:IsAttackBelow(atk)
end
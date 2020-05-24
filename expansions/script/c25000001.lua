--破灭的危机
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000001)
function cm.initial_effect(c)
	local e1=rszg.XyzFun(c,m,4) 
	local e2=rszg.ToGraveFun(c) 
	local e3=rsef.FC(c,EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.hgcon)
	e3:SetOperation(cm.hgop)
	--local e3=rsef.QO(c,nil,{m,0},1,nil,"tg",LOCATION_SZONE,cm.matcon,nil,rstg.target({cm.tgfilter,nil,LOCATION_MZONE},rsop.list(rszg.matfilter,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)),cm.matop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(cm.handcon)
	c:RegisterEffect(e4)
end
function cm.hfilter(c)
	return c:GetSummonLocation()&LOCATION_EXTRA ~=0
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function cm.matcon(e,tp)
	return rscon.phmp(e,tp) and e:GetHandler():GetFlagEffect(m)==0
end
function cm.tgfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xaf1)
end
function cm.matop(e,tp)
	if not aux.ExceptThisCard(e) then return end
	local tc=rscf.GetTargetCard(Card.IsCanOverlay)
	if not tc then return end
	rszg.OverlayFun(tc)
end
function cm.hfilter(c,tp)
	return c:GetSummonPlayer()~=tp and c:GetSummonLocation()&LOCATION_EXTRA ~=0
end
function cm.hgcon(e,tp,eg)
	return eg:IsExists(cm.hfilter,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
end
function cm.hgop(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local tc=g:RandomSelect(tp,1)
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
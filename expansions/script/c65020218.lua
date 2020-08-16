--星光歌剧 雪代晶Revue
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65020218)
function cm.initial_effect(c)
	local e1=rsef.FTO(c,EVENT_RELEASE,{m,0},{1,m},"sp","de",LOCATION_HAND,cm.spcon,nil,rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_TO_GRAVE,"con",cm.spcon2)
	local e3=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,nil,cm.imcon,cm.imop)
	local e4=rsef.QO(c,nil,{m,1},{1,m+100},"dis,atk","tg",LOCATION_MZONE,nil,nil,rstg.target(cm.disfilter,"dis",LOCATION_MZONE,LOCATION_MZONE,1,1,c),cm.disop)
end
function cm.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and rp~=tp
end
function cm.imcon(e,tp,eg,ep,ev,re)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and re:GetHandler():IsSetCard(0x9da0)
end
function cm.imop(e,tp)
	local c=e:GetHandler()
	rshint.Card(m)
	local e1=rsef.FV_IMMUNE_EFFECT({c,tp},rsval.imng2,aux.TargetBoolFunction(Card.IsSetCard,0x9da0),{LOCATION_MZONE,0},nil,rsreset.pend)
end
function cm.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local e1=rscf.QuickBuff({c,tc},"atkf",tc:GetAttack()/2,"reset",rsreset.est_pend)
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e2,e3=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est_pend)
end
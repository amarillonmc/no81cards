--液态型异生兽 佩德隆
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(25000033)
if rssb then return end
rssb=cm
rscf.DefineSet(rssb,0xaf4)
function rssb.SummonCondition(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)	
	return e1
end
function cm.splimit(e,se,sp,st)
	return se:IsActiveType(TYPE_MONSTER) and rssb.IsSet(se:GetHandler())
end
function rssb.rmdcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetDecktopGroup(tp,ct)
		if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==ct end
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
rssb.sstg=rsop.target(rscf.spfilter2(),"sp")
function rssb.ssop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then return rssf.SpecialSummon(c) 
	else return 0
	end
end
function rssb.rmcfilter(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function rssb.rmfilter(c)
	return c:IsAbleToRemove(POS_FACEDOWN)
end
function rssb.rmtdcost(ct)
	return function(...)
		return rscost.cost(cm.rmtdcfilter,"td",LOCATION_REMOVED,0,ct)(...)
	end
end
function cm.rmtdcfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsFacedown()
end
function rssb.cfcon(e,tp)
	return not e:GetHandler():IsPublic()
end
function rssb.lfucon(e)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function rssb.LinkSummonFun(c,maxlink,minlink) 
	c:EnableReviveLimit()
	if maxlink==1 then
		aux.AddLinkProcedure(c,rssb.IsSet,1)
	else
		aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),minlink or 2,maxlink,cm.gf)
	end
end
function cm.gf(g)
	return g:IsExists(rssb.IsSet,1,nil)
end
function rssb.ssfilter(checkzone)
	return function(c,e,tp)
		return Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,c) and c:IsFacedown() and rssb.IsSetM(c) and (not checkzone or Duel.GetLocationCount(tp,LOCATION_MZONE)>0) 
	end
end
-----------------------------------
function cm.initial_effect(c)
	rssb.SummonCondition(c)  
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,rssb.rmdcost(3),rssb.sstg,rssb.ssop)
	local e2=rsef.QO(c,nil,{m,1},1,"sp",nil,LOCATION_MZONE,rscon.phase("mp_o,bp_o"),rscost.regflag(),rsop.target(cm.lfilter,"sp",LOCATION_EXTRA),cm.lkop)
end
function cm.lfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR+RACE_FIEND) and c:IsLinkSummonable(nil,e:GetHandler())
end
function cm.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.lfilter,tp,LOCATION_EXTRA,0,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end

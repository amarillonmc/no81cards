--以斯拉的暗幕 黑帘计划
if not pcall(function() require("expansions/script/c65010000") end) then require("script/c65010000") end
local m,cm=rscf.DefineCard(65011001,"Israel")
if rsisr then return end
rsisr = cm
rscf.DefineSet(rsisr,"Israel")

function rsisr.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function rsisr.spop(g,tp,pos)
	pos = pos or POS_FACEUP 
	return rssf.SpecialSummon(g,0,1-tp,1-tp,false,false,pos,nil,{"leave",LOCATION_REMOVED })
end
function rsisr.spops(e,tp)
	rsisr.drawlimit(e,tp)
	local c=rscf.GetSelf(e)
	return not c and 0 or rsisr.spop(c,tp)
end
function rsisr.drawlimit(e,tp,reset)
	reset = reset or rsreset.pend
	local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"dr",nil,nil,{1,0},nil,reset)
	return e1
end
function rsisr.exlcon(e)
	return Duel.IsExistingMatchingCard(cm.exlfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.exlfilter(c)
	return c:IsFaceup() and rsisr.IsSet(c) and c:IsType(TYPE_LINK)
end
-----------------------------------
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"sp",nil,nil,nil,rsop.target(cm.aspfilter,"sp",LOCATION_DECK),cm.act)
	local e2=rsef.I(c,{m,0},{1,m+100},nil,nil,LOCATION_SZONE,rscon.excard2(rsisr.IsSet,LOCATION_MZONE,LOCATION_MZONE),rscost.cost(cm.rmcfilter,"rm",LOCATION_GRAVE),nil,cm.rmop)
	local e3=rsef.RegisterOPTurn(c,e2,cm.quickcon)
end
function cm.aspfilter(c,e,tp)
	return rsisr.spfilter(c,e,tp) and rsisr.IsSet(c)
end
function cm.quickcon(e,tp)
	return Duel.IsExistingMatchingCard(cm.qfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.qfilter(c)
	local mat=c:GetMaterial()
	return c:IsFaceup() and rsisr.IsSet(c) and c:IsType(TYPE_LINK) and #mat>=3
end 
function cm.rmcfilter(c)
	return rsisr.IsSetM(c) and c:IsAbleToRemoveAsCost()
end
function cm.rmop(e,tp)
	local e1=rsef.FV_REDIRECT({e:GetHandler(),tp},"tg",LOCATION_REMOVED,cm.rmtg,{0xff,0xff},nil,rsreset.pend)
end
function cm.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function cm.act(e,tp)
	if not rscf.GetSelf(e) then return end
	rsop.SelectSolve(HINTMSG_SPSUMMON,tp,rsisr.spfilter,tp,LOCATION_DECK,0,1,1,nil,cm.spfun,e,tp)
	rsisr.drawlimit(e,tp)
end
function cm.spfun(g,e,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
	return true
end

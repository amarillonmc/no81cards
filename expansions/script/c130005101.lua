--唤士的幼龙-嘉儿
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130005101,"DragonCaller")
if rsdc then return end
rsdc = cm 
rscf.DefineSet(rsdc,"DragonCaller")

function rsdc.SynchroFun(c,code,att,cate,cost,tg,op,limit)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,rsdc.IsSet,aux.FilterBoolFunction(Card.IsAttribute,att),1)
	local e1=rsef.QO(c,nil,{m,2},nil,"sp",nil,LOCATION_EXTRA,nil,rscost.cost({cm.resfilter,cm.resgcheck},"res",LOCATION_HAND+LOCATION_MZONE,0,2,2),rsop.target3(cm.checkfun,rscf.spfilter(),"sp"),cm.synop)
	e1:SetLabel(att)
	local e2=rsef.QO(c,nil,{m,2},{1,code},"sp",nil,LOCATION_GRAVE,nil,rscost.cost(cm.resfilter2,"res",LOCATION_HAND+LOCATION_MZONE),rsop.target(rscf.spfilter2(),"sp"),cm.synop)
	e2:SetLabel(att)
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{code,0},{1,code+100},cate,"de",nil,cost,cm.synsptg(tg,limit),op)
	return e1,e2,e3
end
function cm.checkfun(e,tp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
end 
function cm.resfilter(c,e,tp)
	return (rsdc.IsSetM(c) or c:IsAttribute(e:GetLabel())) and c:IsReleasable()
end
function cm.resgcheck(g,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0
end
function cm.synop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.resfilter2(c,e,tp)
	return (rsdc.IsSetM(c) or c:IsAttribute(e:GetLabel())) and c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.synsptg(tg,limit)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) end
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if limit then
			Duel.SetChainLimit(cm.chainlimit(e:GetHandler(),limit))
		end
	end
end
function cm.chainlimit(c,limit)
	return function(e,rp,tp)
		return tp==rp or not limit(c,e:GetHandler(),e)
	end
end
function rsdc.HandActFun(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.handcon)
	c:RegisterEffect(e1)
	return e1
end
function cm.handcon(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
end
------------------------------------

function cm.initial_effect(c)
	local e1=rsef.SV_ADD(c,"att",ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"lv","de,tg",nil,nil,rstg.target2(cm.fun,cm.lvfilter,nil,LOCATION_MZONE),cm.lvop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS)
	local e4=rsef.STO(c,EVENT_RELEASE,{m,1},{1,m+100},"se,th","de",nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
end
function cm.thfilter(c)
	return rsdc.IsSetM(c) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.lvfilter(c)
	return not c:IsCode(m) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND) and c:IsLevelAbove(1)
end
function cm.fun(g,e,tp)
	local lv=g:GetFirst():GetLevel()
	e:SetLabel(Duel.AnnounceLevel(tp,1,7,lv))
end
function cm.lvop(e,tp)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	local lv=e:GetLabel()
	if not tc then return end
	rsef.SV_CHANGE({e:GetHandler(),tc},"lv",lv,nil,rsreset.est_pend)
end
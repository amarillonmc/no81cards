--唤士的幼龙-嘉儿
Duel.LoadScript("c91301000.lua")
rsdc = rsdc or {}
rscf.DefineSet(rsdc,"DragonCaller")
function rsdc.SynchroFun(c,code,att,cate,cost,tg,op,limit)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,rsdc.IsSet,aux.FilterBoolFunction(Card.IsAttribute,att),1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCost(rsdc.spcost)
	e1:SetTarget(rsdc.sptg)
	e1:SetOperation(rsdc.spop)
	c:RegisterEffect(e1)
	e1:SetLabel(att)
	local e2=rsef.QO(c,nil,{code,2},{1,code},"sp",nil,LOCATION_GRAVE,nil,rscost.cost(rsdc.resfilter2,"res",LOCATION_HAND+LOCATION_MZONE),rsop.target(rsdc.spfilter2,"sp"),rsdc.synop2)
	e2:SetLabel(att)
	local e3=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{code,0},{1,code+100},cate,"de",nil,cost,rsdc.synsptg(tg,limit),op)
	return e1,e2,e3
end
function rsdc.costfilter(c,att)
	-- 注意：这里的 0x913 是我假设的「唤士」字段代号（SetCode）。
	-- 请将 0x913 替换为你实际注册的「唤士」字段代码。
	return (c:IsSetCard(0x913) or c:IsAttribute(att)) and c:IsReleasable()
end

-- 组队检查条件：确保选出来的2张卡解放后，额外怪兽区/主要怪兽区有空位
function rsdc.gcheck(sg,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0
end

-- 支付 Cost 的具体执行逻辑
function rsdc.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local att=c:GetAttribute()
	-- 获取手卡和场上所有满足单卡过滤条件的怪兽
	local mg=Duel.GetMatchingGroup(rsdc.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,att)
	
	if chk==0 then 
		-- 使用官方标准的 SelectUnselectGroup 来处理“同时满足数量与组队检查”的情况
		return Group.CheckSubGroup(mg,rsdc.gcheck,2,2,e,tp) 
	end
	
	-- 玩家正式进行选择
	local sg=Group.SelectSubGroup(mg,tp,rsdc.gcheck,false,2,2,e,tp)
	-- 执行解放操作
	Duel.Release(sg,REASON_COST)
end

-- 效果 Target（目标确认）
function rsdc.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- 效果 Operation（具体处理）
function rsdc.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		-- 当作同调召唤进行特殊召唤
		Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end



function rsdc.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function rsdc.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function rsdc.checkfun(e,tp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
end 
function rsdc.resfilter(c,e,tp)
	return (rsdc.IsSetM(c) or c:IsAttribute(e:GetLabel())) and c:IsReleasable()
end
function rsdc.resgcheck(g,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0
end
function rsdc.synop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c,SUMMON_TYPE_SYNCHRO) c:CompleteProcedure() end
end
function rsdc.synop2(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c) end
end
function rsdc.resfilter2(c,e,tp)
	return (rsdc.IsSetM(c) or c:IsAttribute(e:GetLabel())) and c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function rsdc.synsptg(tg,limit)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) end
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if limit then
			Duel.SetChainLimit(rsdc.chainlimit(e:GetHandler(),limit))
		end
	end
end
function rsdc.chainlimit(c,limit)
	return function(e,rp,tp)
		return tp==rp or not limit(c,e:GetHandler(),e)
	end
end
function rsdc.HandActFun(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(rsdc.handcon)
	c:RegisterEffect(e1)
	return e1
end
function rsdc.handcon(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)==0
end
------------------------------------

if c91305101 then return end
local m,cm=rscf.DefineCard(91305101,"DragonCaller")
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
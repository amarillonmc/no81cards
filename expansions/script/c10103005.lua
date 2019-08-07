--界限龙 蒂雅玛特
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103005
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND+LOCATION_MZONE,nil,nil,cm.syntg,cm.synop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"sp","de",nil,rscost.reglabel(100),cm.sptg,cm.spop)
	cm.rs_ghostdom_dragon_effect={e1,e2}
end
function cm.rmfilter(c)
	return c:IsSetCard(0x337) and c:IsAbleToRemoveAsCost()
end 
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x1337) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rmfilter2(g,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and g:IsExists(Card.IsOnField,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=g:CheckSubGroup(cm.rmfilter2,2,2,tp)
	if chk==0 then
		if e:GetLabel()==100 then return b1 and b2
		else return b1 and Duel.GetLocationCountFromEx(tp)>0
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		rsof.SelectHint(tp,"rm")
		local rg=g:SelectSubGroup(tp,cm.rmfilter2,false,2,2,tp)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,nil,rssf.SummonBuff({0,0}))
	end
end
function cm.matfilter(c)
	return c:IsRace(RACE_DRAGON) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.synfilter(sync,e,tp)
	local matc=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	return mg:IsContains(matc) and sync:IsSynchroSummonable(matc,mg)
end
function cm.reg(sg,e,tp)
	local c=e:GetHandler()
	local list={}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_HAND_SYNCHRO)
	e1:SetTargetRange(0,99)
	c:RegisterEffect(e1)
	table.insert(list,e1)
	for sync in aux.Next(sg) do
		local bool,f1,f2,f3,f4,minct,maxct,gc=rscf.GetSynchroProduce(sync)
		if bool then
			local e2=rscf.AddSynchroMixProcedure(sync,f1,f2,f3,f4,minct,maxct)
			table.insert(list,e2)
		end
	end
	return list
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
		local list=cm.reg(sg,e,tp)
		local res=sg:IsExists(cm.synfilter,1,nil,e,tp)
		for _,es in pairs(list) do
			es:Reset()
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.synop(e,tp) 
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
	local list={}
	if c:IsLocation(LOCATION_HAND) then
		list=cm.reg(sg,e,tp)
	end
	rsof.SelectHint(tp,"sp")
	local sync=sg:Select(tp,1,1,nil):GetFirst()
	if sync then 
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		Duel.SynchroSummon(tp,sync,c,mg)
		if sync:GetMaterial():IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
			Duel.ShuffleHand(tp)
		end
		for _,es in pairs(list) do
			es:Reset()
		end
	end
end
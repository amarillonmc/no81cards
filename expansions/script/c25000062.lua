--一位青年艺术家的画像
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000062)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"des,sp",nil,nil,nil,cm.tg,cm.act)
	local e2=rsef.I(c,{m,0},nil,"des",nil,LOCATION_GRAVE,nil,aux.bfgcost,rsop.target(cm.desfilter,"des",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.desop)
end 
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end 
function cm.cfilter(c,p)
	return c:GetPreviousControler()==p
end
function cm.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function cm.desop(e,tp)
	local ct,og=rsop.SelectDestroy(tp,cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,99,nil,{})
	if ct<=0 then return end
	for p=0,1 do
		local dg=og:Filter(cm.cfilter,nil,p)
		local ft=Duel.GetLocationCount(p,LOCATION_SZONE)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.setfilter),p,LOCATION_GRAVE,0,nil)
		if #dg>0 and ft>0 and #sg>0 and rsop.SelectOC({m,1},true) then
			rsgf.SelectSSet(sg,p,aux.TRUE,1,math.min(ft,#dg),nil,{})
		end
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local dg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local sg1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	local sg2=Duel.GetMatchingGroup(cm.spfilter,tp,0,LOCATION_SZONE,nil,e,tp)
	local dct=#dg1+#dg2
	local sct=#sg1+#sg2
	if chk==0 then return dct>0 and sct>0 and (sct<2 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) and (#sg1==0 or Duel.GetMZoneCount(tp,dg1,tp)>0) and (#sg2==0 or Duel.GetMZoneCount(tp,dg2,1-tp)>0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,(dg1+dg2),dct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,(sg1+sg2),sct,0,0)
end
function cm.spfilter(c,e,tp)
	local code=c:GetOriginalCode()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,code,nil,0x11,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) 
end 
function cm.act(e,tp)
	local dg1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	local dg2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local sg1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	local sg2=Duel.GetMatchingGroup(cm.spfilter,tp,0,LOCATION_SZONE,nil,e,tp)
	local ct=Duel.Destroy(dg1+dg2,REASON_EFFECT)
	if ct<=0 then return end
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=#sg1 then
		sg:Merge(sg1)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=#sg1 then
		sg:Merge(sg2)
	end
	if #sg<=0 or (#sg>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	for tc in aux.Next(sg) do
		tc:AddMonsterAttribute(0x11,ATTRIBUTE_DARK,RACE_SPELLCASTER,1,0,0)
		Duel.HintSelection(Group.FromCards(tc))
		rssf.SpecialSummonStep(tc,0,tp,tc:GetControler(),true,true,POS_FACEUP,nil,{"ress,ressns","syn,xyz,link","fus",cm.fusval})
	end
	Duel.SpecialSummonComplete()
end
function cm.fuslimit(e,c,sumtype)
	return sumtype & SUMMON_TYPE_FUSION ~=0
end
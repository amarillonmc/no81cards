--混沌炼金术：二重蒸馏
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10115001
local cm=_G["c"..m]
if not rsv.AlchementBio then
	rsv.AlchementBio={}
	rsab=rsv.AlchementBio
function rsab.typecheck1(c)
	return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function rsab.typecheck2(c)
	return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function rsab.descon(e,tp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function rsab.MaterialGainEffectFun(c,code,cate,tg,op)
	local e1=rsef.SC(c,EVENT_BE_MATERIAL,nil,nil,"cd",rsab.matcon,rsab.matop(code,cate,tg,op))
	return e1
end
function rsab.matcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_RITUAL+REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK ~=0
end
function rsab.matop(code,cate,tg,op)
	return function(e,tp,eg)
		local c=e:GetHandler()
		local rc=c:GetReasonCard()
		local og=rsgf.Mix2(rc,eg)
		for tc in aux.Next(og) do
			local e1=rsef.QO({tc,true},nil,{code,1},1,cate,nil,LOCATION_MZONE,nil,nil,tg,op)
			e1:SetReset(rsreset.est)
			if not tc:IsType(TYPE_EFFECT) then
				local e2=rsef.SV_ADD({c,tc,true},"type",TYPE_EFFECT,nil,rsreset.est)
			end
			tc:RegisterFlagEffect(m,rsreset.est,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
		end
	end
end
function rsab.ComplexSummonFun(c,code,summon1,summon2)
	local isfus=summon1=="fus" or summon2=="fus"
	local flag=not isfus and "sp" or "sp,fus"
	local e1=rsef.ACT(c,nil,nil,{1,code},flag,nil,nil,nil,rsab.sptg(summon1,summon2),rsab.spop(summon1,summon2))
	return e1
end
function rsab.synfilter(c)
	return c:IsCanBeSynchroMaterial()
end
function rsab.xyzfilter(c)
	return c:IsCanBeXyzMaterial(nil)
end
function rsab.linkfilter(c)
	return c:IsCanBeLinkMaterial(nil)
end
function rsab.getmaterial(tp,mix1,mix2)
	local ritg=Duel.GetRitualMaterial(tp):Filter(Card.IsOnField,nil)
	local fusg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	local syng=Duel.GetMatchingGroup(rsab.synfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(rsab.xyzfilter,tp,LOCATION_MZONE,0,nil)
	local linkg=Duel.GetMatchingGroup(rsab.linkfilter,tp,LOCATION_MZONE,0,nil)
	local list={ritg,fusg,syng,xyzg,linkg}
	local list2={"rit","fus","syn","xyz","link"}
	if not mix1 then
		return ritg,fusg,syng,xyzg,linkg
	else
		local _,index=rsof.Table_List(list2,mix1)
		local g1=list[index]
		local _,index2=rsof.Table_List(list2,mix2)
		local g2=list[index2]   
		local f=function(c,g)
			return g:IsContains(c)
		end
		local mixg=g1:Filter(f,nil,g2)
		return mixg
	end
end
function rsab.sptg(summon1,summon2)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mixg=rsab.getmaterial(tp,summon1,summon2)
		if chk==0 then return Duel.IsExistingMatchingCard(rsab.spfilter0,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,mixg,summon1,summon2) and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA+LOCATION_HAND)
	end
end
function rsab.spfilter0(c,e,tp,mixg,summon1,summon2)
	return rsab.checktype(c,e,tp,summon1) and Duel.IsExistingMatchingCard(rsab.spfilter2,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,c,e,tp,c,mixg,summon1,summon2)
end
function rsab.spfilter1(c,e,tp,mixg,summon1,summon2)
	return rsab.checktype(c,e,tp,summon1) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(rsab.spfilter2),tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,c,e,tp,c,mixg,summon1,summon2)
end
function rsab.spfilter2(c,e,tp,c1,mixg,summon1,summon2)
	return rsab.checktype(c,e,tp,summon2) and mixg:CheckSubGroup(rsab.spcheck,1,#mixg,e,tp,c1,c,summon1,summon2)
end
function rsab.spcheck(g,e,tp,c1,c2,summon1,summon2)
	local sumzone1=rsab.zonecheckfun(tp,g,c1,c2,summon1,summon2)
	if sumzone1==0 then return false end
	local list={rsab.ritcheck,rsab.fuscheck,rsab.syncheck,rsab.xyzcheck,rsab.linkcheck}
	local list2={"rit","fus","syn","xyz","link"}  
	local _,index=rsof.Table_List(list2,summon1)
	local fun=list[index]
	local bool1=fun(g,e,tp,c1)
	local _,index2=rsof.Table_List(list2,summon2)
	local fun2=list[index2]
	local bool2=fun2(g,e,tp,c2)
	return bool1 and bool2
end
function rsab.checktype(c,e,tp,summon)
	if summon=="rit" then return c:GetType()&0x81==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) 
	elseif summon=="fus" then return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and not c:IsLocation(LOCATION_GRAVE)
	elseif summon=="syn" then return c:IsType(TYPE_SYNCHRO) and not c:IsLocation(LOCATION_GRAVE)
	elseif summon=="xyz" then return c:IsType(TYPE_XYZ) and not c:IsLocation(LOCATION_GRAVE)
	elseif summon=="link" then return c:IsType(TYPE_LINK) and not c:IsLocation(LOCATION_GRAVE)
	end
end
function rsab.ritcheck(g,e,tp,ritc)
	aux.GCheckAdditional=aux.RitualCheckAdditional(ritc,ritc:GetLevel(),"Equal")
	local bool=aux.RitualCheckEqual(g,ritc,ritc:GetLevel())
	aux.GCheckAdditional=nil
	return bool
end
function rsab.checkfilter(g)
	return function(tp,sg,fc)
		return #sg==#g
	end
end
function rsab.fuscheck(g,e,tp,fusc)
	aux.FCheckAdditional=rsab.checkfilter(g)
	local bool=fusc:CheckFusionMaterial(g,nil,tp)
	aux.FCheckAdditional=nil
	return bool
end
function rsab.syncheck(g,e,tp,sync)
	local bool,f1,f2,f3,f4,minct,maxct,gc=rscf.GetSynchroProduce(sync)
	if not f2 and not f3 then
		return Duel.CheckSynchroMaterial(sync,f1,f4,#g-1,#g-1,nil,g)
	else
		--problem
		return sync:IsSynchroSummonable(nil,g)
	end
end
function rsab.xyzcheck(g,e,tp,xyzc)
	return xyzc:IsXyzSummonable(g,#g,#g) 
end
function rsab.spop(summon1,summon2)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
		local mixg=rsab.getmaterial(tp,summon1,summon2)
		local list={rsab.ritcheck,rsab.fuscheck,rsab.syncheck,rsab.xyzcheck,rsab.linkcheck}  
		local list2={"rit","fus","syn","xyz","link"}
		local _,index=rsof.Table_List(list2,summon1)
		local fun1=list[index]
		local _,index2=rsof.Table_List(list2,summon2)
		local fun2=list[index2]
		rsof.SelectHint(tp,{m,index-1})
		local sc1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(rsab.spfilter1),tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,mixg,summon1,summon2):GetFirst()
		if not sc1 then return end
		local _,index2=rsof.Table_List(list2,summon2)
		rsof.SelectHint(tp,{m,index2-1})
		local sc2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(rsab.spfilter2),tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,sc1,e,tp,sc1,mixg,summon1,summon2):GetFirst()
		rsof.SelectHint(tp,{m,5})
		local mat=mixg:SelectSubGroup(tp,rsab.spcheck,false,1,#mixg,e,tp,sc1,sc2,summon1,summon2)
		local reason=REASON_MATERIAL 
		sc1:SetMaterial(mat)
		local sumzone1=rsab.zonecheckfun(tp,mat,sc1,sc2,summon1,summon2)
		if summon1~="xyz" and summon2~="xyz" then
			rsab.materialsendfun(mat,summon1,summon2)
		end
		rsab.summonfun(sc1,mat,e,tp,summon1,sumzone1)
		if summon2=="xyz" then
			rsab.materialregfun(mat,e,tp,summon1)
		end
		Duel.BreakEffect()
		sc2:SetMaterial(mat)
		rsab.summonfun(sc2,mat,e,tp,summon2)
		if summon2~="xyz" and not (summon1=="rit" and summon2=="fus") and not (summon1=="xyz" and (summon2=="rit" or summon2=="syn")) then
			rsab.materialregfun(mat,e,tp,summon2)
		end
	end
end
function rsab.zonecheckfun(tp,mat,sc1,sc2,summon1,summon2)
	local checkg=summon2=="xyz" and Group.CreateGroup() or mat
	local list={0x1,0x2,0x4,0x8,0x10}
	local sumzone1=0
	if summon1=="rit" then
		local mzct=Duel.GetMZoneCount(tp,checkg,tp)
		local exmzct=Duel.GetLocationCountFromEx(tp,tp,checkg,sc2)
		local exmzct1=Duel.GetLocationCountFromEx(tp,tp,checkg,sc2,0x1f)
		local exmzct2=Duel.GetLocationCountFromEx(tp,tp,checkg,sc2,0x60)
		if exmzct2>0 and exmzct1==0 and mzct>0 then
			sumzone1=0x1f 
		end
		if exmzct>0 and mzct>0 then
			for _,zone in pairs(list) do 
				if Duel.GetMZoneCount(tp,checkg,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.GetLocationCountFromEx(tp,tp,mat,sc2,0x7f-zone)>0 then
					sumzone1=sumzone1|zone
				end
			end
		end
	elseif summon2=="rit" then 
		local mzct=Duel.GetMZoneCount(tp,mat,tp)
		local exmzct=Duel.GetLocationCountFromEx(tp,tp,mat,sc1)
		local exmzct1=Duel.GetLocationCountFromEx(tp,tp,mat,sc1,0x1f)
		local exmzct2=Duel.GetLocationCountFromEx(tp,tp,mat,sc1,0x60)
		if exmzct2>0 and exmzct1==0 and mzct>0 then
			sumzone1=0x60 
		end
		if exmzct1>0 and mzct>0 then
			for _,zone in pairs(list) do
				if Duel.GetMZoneCount(tp,mat,tp,LOCATION_REASON_TOFIELD,0x1f-zone)>0 and Duel.GetLocationCountFromEx(tp,tp,mat,sc2,zone)>0 then
					sumzone1=sumzone1|zone
				end
			end
		end  
	else
		local list2={0x20,0x40,0x1,0x2,0x4,0x8,0x10}
		for _,zone in pairs(list2) do
			if Duel.GetLocationCountFromEx(tp,tp,checkg,sc1,zone)>0 and Duel.GetLocationCountFromEx(tp,tp,mat,sc2,rsab.zonesub(zone))>0 then
				sumzone1=sumzone1|zone
			end
		end
	end
	return sumzone1
end
function rsab.zonesub(zone1)
	if zone1==0x20 then return 0x7f-zone1-0x40 
	elseif zone1==0x40 then return 0x7f-zone1-0x20
	else return 0x7f-zone1
	end
end
function rsab.materialreasonfun(summon1)
	local list={ REASON_RITUAL,REASON_FUSION,REASON_SYNCHRO,REASON_XYZ,REASON_LINK }
	local list2={"rit","fus","syn","xyz","link"}
	local _,index=rsof.Table_List(list2,summon1)
	local reason1=list[index]
	return reason1
end
function rsab.materialsendfun(mat,summon1,summon2)
	local reason1=rsab.materialreasonfun(summon1)
	local reason2=rsab.materialreasonfun(summon2)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+reason1+reason2)
end
function rsab.materialregfun(mat,e,tp,summon1)
	local reason1=rsab.materialreasonfun(summon1)  
	Duel.RaiseEvent(mat,EVENT_BE_MATERIAL,e,reason,tp,tp,0) 
	for mc in aux.Next(mat) do
		Duel.RaiseSingleEvent(mc,EVENT_BE_MATERIAL,e,reason1,tp,tp,0)
	end
end
function rsab.summonfun(sc,mat,e,tp,summon1,sumzone1)
	if not sumzone1 then sumzone1=0x7f end
	if summon1=="rit" then
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP,sumzone1)
	elseif summon1=="fus" then
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP,sumzone1)
	elseif summon1=="syn" then
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP,sumzone1)
	elseif summon1=="xyz" then
		Duel.Overlay(sc,mat)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP,sumzone1)
	end
	sc:CompleteProcedure()
end

-------------------
end
-------------------
if cm then
function cm.initial_effect(c)
   local e1=rsab.ComplexSummonFun(c,m,"syn","xyz") 
end
-------------------
end

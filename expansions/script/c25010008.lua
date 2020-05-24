--大地之光 盖亚V2
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010008)
function cm.initial_effect(c)
	rsgol.GaiaSummonFun(c,m,7)
	local e1=rsef.FV_LIMIT_PLAYER(c,"rm",nil,cm.rmtg,{0,1})
	local e2=rsef.FV_LIMIT_PLAYER(c,"act",cm.disval,nil,{0,1})
	local e3=rsef.QO_NEGATE(c,"neg",{1,m},nil,LOCATION_MZONE,rscon.negcon(2,true),rscost.rmxyz(1))  
	local e4=rsef.QO(c,nil,{25010001,0},{1,m+200},"sp",nil,LOCATION_MZONE,cm.spcon,rscost.lpcost(true),rsop.target2(cm.fun,cm.spfilter,"sp",LOCATION_EXTRA),cm.spop)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(m-1) and c:GetOverlayCount()<=0
end
function cm.rmtg(e,c)
	return c:GetControler()==e:GetHandlerPlayer()
end
function cm.disval(e,re)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsLocation(LOCATION_REMOVED)
end
function cm.spcon(e,tp)
	local c=e:GetHandler()
	return c:GetOverlayCount()<=0 and rscon.phmp(e,tp) 
end
function cm.spfilter(c,e,tp)  
	local oc=e:GetHandler()
	return c:IsCode(m+1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,oc,c)>0 and aux.MustMaterialCheck(oc,tp,EFFECT_MUST_BE_XMATERIAL) and oc:IsCanBeXyzMaterial(c)
end
function cm.fun(g,e,tp)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	rshint.Select(tp,"sp")
	local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if #mg~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
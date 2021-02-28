--邪暗之源的幻影
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000420)
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),11,3,nil,nil,99)
	local e1=rscf.SetSummonCondition(c,false,aux.xyzlimit)
	local e2=rscf.AddSpecialSummonProcdure(c,LOCATION_EXTRA,cm.sprcon,nil,cm.sprop,{m,0},nil,SUMMON_TYPE_XYZ)
	local e3=rsef.SV_CANNOT_DISABLE_S(c)
	local e4=rsef.SV_INDESTRUCTABLE(c,"effect")
	local e6=rsef.QO(c,nil,{m,1},1,nil,nil,LOCATION_MZONE,nil,rscost.rmxyz(3),nil,cm.efop)
	local e7=rsef.QF(c,EVENT_SUMMON,{m,2},nil,"diss,rm",nil,LOCATION_MZONE,cm.disscon,nil,cm.disstg,cm.dissop)
	local e8=rsef.RegisterClone(c,e7,"code",EVENT_SPSUMMON)
	local e9=rsef.QF(c,EVENT_CHAINING,{m,3},nil,"neg,rm","dsp,dcal",LOCATION_MZONE,cm.negcon,nil,rstg.negtg("rm"),cm.negop)
	local e10=rsef.I(c,"rm",nil,"rm,dam",nil,LOCATION_MZONE,cm.rmcon,rscost.rmxyz(1),rsop.target2(cm.fun,{Card.IsAbleToRemove,"rm"},{Card.IsAbleToRemove,"rm",rsloc.hg,rsloc.hg,true}),cm.rmop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetTarget(cm.rmlimit)
	c:RegisterEffect(e5)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_INACTIVATE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(cm.efilter)
	c:RegisterEffect(e11)
end
function cm.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function cm.rmcon(e)
	return e:GetHandler():GetOverlayCount()==1
end
function cm.fun(g,e,tp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,rsloc.hg,rsloc.hg,nil)
	rg:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#rg*300)
end
function cm.rmop(e,tp)
	local c=rscf.GetSelf(e)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,rsloc.hg,rsloc.hg,nil)
	if c and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsLocation(LOCATION_REMOVED) and #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED) + 1
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end
end
function cm.disscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():GetFlagEffect(m)>0
end
function cm.disstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function cm.dissop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,rsloc.hog,nil)
	if #rg>0 and rsop.SelectYesNo(1-tp,"rm") then
		rsgf.SelectRemove(rg,1-tp,aux.TRUE,1,1,nil,{})
		Duel.NegateEffect(0)
		return
	end
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function cm.negcon(e,...)
	return rscon.negcon(0,true)(e,...) and e:GetHandler():GetFlagEffect(m)>0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,rsloc.hog,nil)
	if #rg>0 and rsop.SelectYesNo(1-tp,"rm") then
		rsgf.SelectRemove(rg,1-tp,aux.TRUE,1,1,nil,{})
		Duel.NegateEffect(0)
		return
	end
	if Duel.NegateActivation(ev) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.efop(e,tp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
end
function cm.rmlimit(e,c,tp,r)
	return c==e:GetHandler()
end
function cm.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsCanOverlay() and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.seqfilter(c)
	return c:GetSequence()>=5
end
function cm.mfilter(c,lv,race)
	return c:IsLevel(lv) and c:IsRace(race)
end 
function cm.gcheck(g)
	if #g==1 then return g:IsExists(cm.mfilter,1,nil,12,RACE_FIEND) or g:IsExists(cm.mfilter,1,nil,10,RACE_DRAGON) end
	if #g>=2 then return g:IsExists(cm.mfilter,1,nil,12,RACE_FIEND) and g:IsExists(cm.mfilter,1,nil,10,RACE_DRAGON) and aux.dncheck(g) end
end
function cm.sprcon(e,c,tp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetReleaseGroup(tp):Filter(cm.seqfilter,nil)
	g:Sub((g2))
	return #g2>0 and Duel.GetLocationCountFromEx(tp,tp,g2,c)>0 
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) and g:CheckSubGroup(cm.gcheck,7,7)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local g2=Duel.GetReleaseGroup(tp):Filter(cm.seqfilter,nil)
	g:Sub((g2))
	Duel.Release(g2,REASON_COST)
	rshint.Select(tp,HINTMSG_XMATERIAL)
	local matg = g:SelectSubGroup(tp,cm.gcheck,false,7,7)
	local og=Group.CreateGroup()
	for tc in aux.Next(matg) do
		og:Merge(tc:GetOverlayGroup())
	end
	og:Merge(matg)
	Duel.Overlay(c,og)
end
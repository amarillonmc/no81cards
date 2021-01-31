--复合怪兽 立加德隆
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001013)
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSummonType,SUMMON_TYPE_SPECIAL),3,true) 
	local e1=rscf.SetSummonCondition(c,false)
	local e2=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m,2},"sp",nil,LOCATION_EXTRA,cm.spcon,rscost.cost2(cm.cfun,{cm.cfilter,cm.gcheck},"rm",LOCATION_MZONE,LOCATION_MZONE,3),rsop.target(cm.spfilter,"sp"),cm.spop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS,"con",cm.spcon2)
	local e4,e5=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e6=rsef.QO_NEGATE(c,"neg",1,"des",LOCATION_MZONE,cm.negcon)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local att,race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE,CHAININFO_TRIGGERING_RACE)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and (att & e:GetLabelObject():GetLabel() ~=0 or race & e:GetLabelObject():GetValue() ~=0)
end
function cm.cfun(g,e,tp)
	local att,race=0
	for tc in aux.Next(g) do
		att = att|tc:GetAttribute()
		race =   race|tc:GetRace()
	end
	e:SetLabel(att)
	e:SetValue(race)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function cm.spcfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spcfilter,1,nil,tp)
end
function cm.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemoveAsCost()
end
function cm.gcheck(g,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0 then
		c:CompleteProcedure()
	end
end

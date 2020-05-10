--根源破灭尖兵 ∑茨奇古尔
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000006)
function cm.initial_effect(c)
	local e1=rszg.XyzSumFun(c,m,4,cm.spfilter)
	--local e2=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m+600},"eq","tg",LOCATION_MZONE,cm.eqcon,rscost.rmxyz(1),rstg.target(cm.eqfilter,"des",0,LOCATION_MZONE),cm.eqop)
	local e2=rsef.QO_NEGATE(c,"neg",{1,m+600},nil,LOCATION_MZONE,cm.negcon,rscost.rmxyz(1))
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49275969,0))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+600)
	e3:SetCondition(cm.discon)
	e3:SetCost(rscost.rmxyz(1))
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return c:IsRank(8) and c:IsSetCard(0xaf1) 
end
function cm.eqcon(e,tp)
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(m)==0
end
function cm.eqfilter(c,e,tp,eg)
	return eg:IsContains(c) and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetSummonPlayer()~=tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsAbleToChangeControler()
end
function cm.eqop(e,tp)
	local c,tc=rscf.GetRelationThisCard(e),rscf.GetTargetCard()
	if not c or not tc or not rsop.eqop(e,tc,c) then return end
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	e:SetLabelObject(tc)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function cm.discfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:IsExists(cm.discfilter,1,nil,1-tp) and Duel.GetCurrentChain()==0
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=#eg end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,#eg,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	local c=rscf.GetRelationThisCard(e)
	if #eg<=Duel.GetLocationCount(tp,LOCATION_SZONE) and c then
		for tc in aux.Next(eg) do
			rsop.eqop(e,tc,c)
		end
	end
end
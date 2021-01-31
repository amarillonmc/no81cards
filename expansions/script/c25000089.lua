--文明裁决者 加拉特隆
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000089)
function cm.initial_effect(c)   
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.linkcon,cm.linkop,{m,0})
	e1:SetValue(SUMMON_TYPE_LINK)
	local e2=rsef.QO(c,nil,{m,1},{1,m},"des,dam",nil,LOCATION_MZONE,nil,rscost.cost(cm.rmfilter,"rm",LOCATION_GRAVE),rsop.target2(cm.fun,aux.TRUE,"des",0,LOCATION_MZONE),cm.desop)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+100)
	e4:SetCondition(rscon.negcon(4,true))
	e4:SetCost(rscost.cost(cm.rmfilter2,"rm",LOCATION_GRAVE))
	e4:SetTarget(cm.negtg)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.rmfilter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.desop(e,tp)
	local ct,og,tc=rsop.SelectDestroy(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil,{})
	if tc then
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function cm.rmfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_MACHINE)
end
function cm.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLinkRace(RACE_MACHINE) and c:IsLinkType(TYPE_LINK) and c:IsLevelAbove(lc:GetLink())
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function cm.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,cm.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
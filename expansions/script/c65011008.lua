--以斯拉的尖兵 梅尔卡巴
if not pcall(function() require("expansions/script/c65011001") end) then require("script/c65011001") end
local m,cm=rscf.DefineCard(65011008,"Israel")
function cm.initial_effect(c)
	local e1=rsef.I(c,"tg",{1,m},"tg,des",nil,LOCATION_HAND,nil,rscost.cost(0,"dish"),rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(rshint.neg)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsisr.IsSet(c)
end 
function cm.tgop(e,tp)
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		rsop.SelectOC("des",true)
		rsop.SelectDestroy(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,{})
	end
end
function cm.desfilter(c)
	return c:IsFaceup() and rsisr.IsSet(c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LEVEL)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and loc & LOCATION_ONFIELD ~=0 and Duel.IsChainNegatable(ev) and rsisr.exlcon(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return rsisr.spfilter(c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if rsisr.spops(e,tp)>0 and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


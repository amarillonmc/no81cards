--人理之诗 绚烂魔界日轮城
function c22023700.initial_effect(c)
	aux.AddCodeList(c,22020631,22023680)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,22023700+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22023700.cost)
	e1:SetTarget(c22023700.target)
	e1:SetOperation(c22023700.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023700,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,22023701)
	e2:SetCondition(c22023700.condition)
	e2:SetTarget(c22023700.tktg)
	e2:SetOperation(c22023700.tkop)
	c:RegisterEffect(e2)
end
function c22023700.costfilter(c,tp)
	return c:IsCode(22020631) and (c:IsControler(tp) or c:IsFaceup())
end
function c22023700.fselect(g,tp,exc)
	local dg=g:Clone()
	if exc then dg:AddCard(exc) end
	if Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g:GetCount(),dg) then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c22023700.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	local g=Duel.GetReleaseGroup(tp):Filter(c22023700.costfilter,nil,tp)
	if chk==0 then return g:CheckSubGroup(c22023700.fselect,1,g:GetCount(),tp,exc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,c22023700.fselect,false,1,g:GetCount(),tp,exc)
	aux.UseExtraReleaseCount(rg,tp)
	e:SetLabel(100,Duel.Release(rg,REASON_COST))
end
function c22023700.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	local check,ct=e:GetLabel()
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc) end
	if check~=100 then ct=0 end
	e:SetLabel(0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,exc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SelectOption(tp,aux.Stringid(22023700,1))
end
function c22023700.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22023700,2))
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c22023700.spfilter(c)
	return c:IsCode(22020631) and (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c22023700.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023700.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c22023700.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c22023700.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,22020631)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

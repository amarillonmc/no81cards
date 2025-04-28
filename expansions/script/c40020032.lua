-- 超星使徒 斯皮策龙
local m=40020032
local cm=_G["c"..m]
function cm.initial_effect(c)


	--①：对方卡片效果发动时无效并破坏，然后特召自己
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.effect1_condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.effect1_target)
	e1:SetOperation(cm.effect1_operation)
	c:RegisterEffect(e1)

	--②：自己用效果特召后，破坏对方1只怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.effect2_condition)
	e2:SetTarget(cm.effect2_target)
	e2:SetOperation(cm.effect2_operation)
	c:RegisterEffect(e2)
end

-- ①：判断是否对方卡片效果发动且可以无效
function cm.effect1_condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) or rp~=1-tp then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if not te or p~=tp then return false end
	local tc=te:GetHandler()
	return  te:IsActiveType(TYPE_MONSTER) or  te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.filter(c,tpe)
	return c:IsType(tpe) and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,c,rtype) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	--local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,c,rtype)
	--g:AddCard(c)
	--Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
	Duel.DiscardHand(tp,cm.filter,1,1,REASON_COST+REASON_DISCARD,c,rtype)
end
-- ①：无效并破坏
function cm.effect1_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end

end

function cm.effect1_operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT) and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)

		end
	end
end

-- ②：特召后破坏对方怪兽
function cm.effect2_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF 
end

function cm.effect2_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.effect2_operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

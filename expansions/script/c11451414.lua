--aoguang,king of dragon palace
local m=11451414
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,m-10)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.condition2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.condition4)
	e3:SetOperation(cm.operation4)
	c:RegisterEffect(e3)
	--check release count
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.filter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x6978)
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local g2=g:Filter(Card.IsSetCard,nil,0x6978)
	local count0=g2:FilterCount(Card.GetPreviousControler,nil,0)
	local count1=g2:FilterCount(Card.GetPreviousControler,nil,1)
	cm[0]=cm[0]+count0
	cm[1]=cm[1]+count1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cm.filter,1,nil,tp) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsPublic() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and e:GetHandler():IsRelateToEffect(e) then
		if Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP) then
			e:GetHandler():CompleteProcedure()
		end
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and Duel.GetCurrentChain()~=0
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.condition4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.operation4(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	--effect phase end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.condition3)
	e3:SetOperation(cm.operation3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	g=g:Filter(Card.IsReleasable,nil)
	return g:GetCount()>0 and cm[tp]>0
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	g=g:Filter(Card.IsReleasable,nil)
	local count=math.min(g:GetCount(),cm[tp])
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
	local g2=g:Select(1-tp,count,count,nil)
	Duel.HintSelection(g2)
	Duel.Release(g2,REASON_RULE)
end
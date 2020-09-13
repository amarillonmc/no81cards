--姬绊连结 藤堂秋乃
function c10700240.initial_effect(c)
	aux.EnableDualAttribute(c)
	--link
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)   
	e1:SetCountLimit(1,10700240)
	e1:SetCost(c10700240.cost)
	e1:SetTarget(c10700240.lktg)
	e1:SetOperation(c10700240.lkop)
	c:RegisterEffect(e1)
	c10700240.discard_effect=e1 
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(65305468,0))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetCondition(aux.IsDualState)
	e6:SetOperation(c10700240.atkop)
	c:RegisterEffect(e6)  
end
function c10700240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10700240.matfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3a01) or c:IsType(TYPE_DUAL))
end
function c10700240.lkfilter(c,mg)
	return c:IsLinkSummonable(mg)
end
function c10700240.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c10700240.matfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c10700240.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10700240.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c10700240.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c10700240.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,mg)
	end
end
function c10700240.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=c:GetBattleTarget()
	if at then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	at:RegisterEffect(e1)
	end
	Duel.Recover(tp,at:GetBaseAttack(),REASON_EFFECT)
end
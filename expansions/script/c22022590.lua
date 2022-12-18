--人理之基 壱与
function c22022590.initial_effect(c)
	c:EnableReviveLimit()
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022590,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,22022590)
	e1:SetCondition(c22022590.condition)
	e1:SetCost(c22022590.cost)
	e1:SetTarget(c22022590.target)
	e1:SetOperation(c22022590.operation)
	c:RegisterEffect(e1)
	--change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022590,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22022591)
	e2:SetCondition(c22022590.chcon)
	e2:SetOperation(c22022590.chop)
	c:RegisterEffect(e2)
end
function c22022590.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c22022590.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.CheckLPCost(tp,2500) end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.PayLPCost(tp,2500)
end
function c22022590.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c22022590.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetValue(2)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22022590.chcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp
end
function c22022590.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22022590.repop)
end
function c22022590.filter(c,e,sp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c22022590.repop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(c22022590.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(22022590,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
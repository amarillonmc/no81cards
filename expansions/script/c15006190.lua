local m=15006190
local cm=_G["c"..m]
cm.name="巡星兽 荆"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006200)
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetCountLimit(1,m)
	e0:SetTarget(cm.thtg)
	e0:SetOperation(cm.thop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.sp2con)
	e2:SetCost(cm.sp2cost)
	e2:SetTarget(cm.sp2tg)
	e2:SetOperation(cm.sp2op)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9f44) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.sp2filter(c,e,tp)
	return c:IsCode(15006200) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.sp2filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--negate
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCondition(cm.discon)
		e2:SetCost(cm.discost)
		e2:SetTarget(cm.distg)
		e2:SetOperation(cm.disop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		--change type
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetCode(EFFECT_ADD_TYPE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetValue(TYPE_EFFECT)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		--
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function cm.excostfilter(c,tp)
	return c:IsReleasable() and (c:IsControler(tp) or c:IsFaceup())
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local locs=0
	local loco=0
	if Duel.IsPlayerAffectedByEffect(tp,15006207) then locs=LOCATION_HAND+LOCATION_MZONE end
	if Duel.IsPlayerAffectedByEffect(tp,15006206) then loco=LOCATION_MZONE end
	local ag=Group.CreateGroup()
	if c:IsReleasable() then ag:AddCard(c) end
	local arg=Duel.GetMatchingGroup(cm.excostfilter,tp,locs,loco,nil,tp)
	if #arg>0 then ag:Merge(arg) end
	if chk==0 then return #ag>0 end
	local rc=c
	if #ag>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		rc=ag:Select(tp,1,1,nil):GetFirst()
	end
	if rc:IsControler(1-tp) then
		Duel.HintSelection(Group.FromCards(rc))
		local te=Duel.IsPlayerAffectedByEffect(tp,15006206)
		te:UseCountLimit(tp)
	end
	if rc~=c then Duel.Hint(HINT_CARD,1-tp,15006206) end
	Duel.Release(rc,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--鸿园之主 红露
local m=43990120
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990120,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43990120)
	e1:SetCondition(c43990120.spcon)
	e1:SetTarget(c43990120.sptg)
	e1:SetOperation(c43990120.spop)
	c:RegisterEffect(e1)
	--neg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990120,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,43991120)
	e2:SetCondition(c43990120.discon)
	e2:SetCost(c43990120.discost)
	e2:SetTarget(c43990120.distg)
	e2:SetOperation(c43990120.disop)
	c:RegisterEffect(e2)
	--rem
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990120,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,43992120)
	e3:SetCondition(c43990120.recon)
	e3:SetTarget(c43990120.retg)
	e3:SetOperation(c43990120.reop)
	c:RegisterEffect(e3)
	if not c43990120.global_check then
		c43990120.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(c43990120.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	
end
function c43990120.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) and tc:IsPreviousLocation(LOCATION_REMOVED) and not tc:IsReason(REASON_SPSUMMON) and not tc:IsReason(REASON_SUMMON) then
			tc:RegisterFlagEffect(43990120,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		tc=eg:GetNext()
	end
end
function c43990120.spfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(43990120)~=0 and c:IsSetCard(0x6510)
end
function c43990120.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990120.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c43990120.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990120.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990120,3)) then
			Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,2,nil)
		if #tg==0 then return end
		if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(43990120,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(c43990120.retop)
		Duel.RegisterEffect(e1,tp)
		end
	end
end
function c43990120.retfilter(c)
	return c:GetFlagEffect(43990120)~=0
end
function c43990120.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c43990120.retfilter,nil)
	if sg:GetCount()>1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(tc)
	else
		local tc=sg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc=sg:GetNext()
		end
	end
end
function c43990120.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and ep==1-tp
end
function c43990120.discostfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x6510) and c:IsAbleToHandAsCost()
end
function c43990120.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990120.discostfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c43990120.discostfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:CancelableSelect(tp,1,2,nil)
	Duel.SendtoHand(sg,nil,REASON_COST)
end
function c43990120.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c43990120.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c43990120.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDefensePos()
end
function c43990120.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
end
function c43990120.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(43990120,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(g)
		e1:SetCountLimit(1)
		e1:SetOperation(c43990120.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
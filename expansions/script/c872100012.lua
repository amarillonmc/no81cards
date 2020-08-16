--永夜抄·「火鸟 -不死传说-」
function c872100012.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
---
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(872100012,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c872100012.destg)
	e1:SetOperation(c872100012.desop)
	c:RegisterEffect(e1)
----
   local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c872100012.disopp)
	c:RegisterEffect(e2)
----
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(872100012,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,872100013)
	e3:SetCondition(c872100012.spcon)
	e3:SetCost(c872100012.spcost)
	e3:SetTarget(c872100012.sptg)
	e3:SetOperation(c872100012.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c872100012.spcon2)
	c:RegisterEffect(e4)
end
function c872100012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function c872100012.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=g:RandomSelect(tp,1)
	Duel.Destroy(sg,REASON_EFFECT)
end
----
function c872100012.disopp(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_REMOVED and re:IsActiveType(TYPE_MONSTER) then
		Duel.NegateEffect(ev)
	end
end
-----
function c872100012.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c872100012.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c872100012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c872100012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c872100012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(800)
		c:RegisterEffect(e1)
	end
end
--「」中哥
function c44401007.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,c44401007.mfilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL):SetValue(SUMMON_TYPE_FUSION)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c44401007.atkop)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c44401007.target)
	e2:SetOperation(c44401007.operation)
	c:RegisterEffect(e2)
end
function c44401007.mfilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_PSYCHO) and (not sg or sg:FilterCount(aux.TRUE,c)==0
		or sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c44401007.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(100)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c44401007.cfilter(c,e)
	return c:IsSetCard(0xa4a) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c44401007.gcheck(sg)
	return Duel.IsExistingTarget(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,#sg,sg)
end
function c44401007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c44401007.cfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c44401007.gcheck) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c44401007.gcheck,false,1,#g)
	Duel.SetTargetCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,#sg,#sg,sg)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401007,0))
end
function c44401007.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(44401007,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSummonType(SUMMON_TYPE_FUSION) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(44401007,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:FilterSelect(tp,Card.IsFaceup,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

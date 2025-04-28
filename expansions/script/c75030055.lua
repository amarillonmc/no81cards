--黎明的咒歌
function c75030055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,75030055)
	e1:SetTarget(c75030055.target)
	e1:SetOperation(c75030055.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,85030055)
	e2:SetTarget(c75030055.reptg)
	e2:SetValue(c75030055.repval)
	e2:SetOperation(c75030055.repop)
	c:RegisterEffect(e2)
end
function c75030055.filter(c,e)
	return c:IsSetCard(0x6751) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c75030055.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(c75030055.filter,tp,LOCATION_MZONE,0,1,nil,e) end
	local ct1=Duel.GetMatchingGroupCount(c75030055.filter,tp,LOCATION_MZONE,0,nil,e)
	local ct2=Duel.GetMatchingGroupCount(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	local mc=math.min(ct1,ct2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c75030055.filter,tp,LOCATION_MZONE,0,1,mc,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,#g1,#g1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
end
function c75030055.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c75030055.repfilter(c,tp)
	return not c:IsReason(REASON_REPLACE) and c:IsFaceup() and c:IsSetCard(0x6751) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c75030055.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c75030055.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c75030055.repval(e,c)
	return c75030055.repfilter(c,e:GetHandlerPlayer())
end
function c75030055.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

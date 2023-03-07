--亡国的姬骑士 妮可莉娜
function c64800129.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--rm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800129,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,64800129)
	e1:SetTarget(c64800129.rmtg)
	e1:SetOperation(c64800129.rmop)
	c:RegisterEffect(e1)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,64810129)
	e4:SetTarget(c64800129.desreptg)
	e4:SetValue(c64800129.desrepval)
	e4:SetOperation(c64800129.desrepop)
	c:RegisterEffect(e4)
end

--e1
function c64800129.gtfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemove()
end
function c64800129.rmtfilter1(c,tp)
	return  c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c64800129.gtfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetAttribute()) and c:IsAbleToRemove()
end
function c64800129.rmfilter2(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end

function c64800129.gfilter(c)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c64800129.gtfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,c:GetAttribute()) and c:IsAbleToRemove()
end
function c64800129.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c64800129.rmtfilter1,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp)
		and Duel.IsExistingTarget(c64800129.rmfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rmg=Duel.SelectMatchingCard(tp,c64800129.gfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=rmg:GetFirst()
	local att=tc:GetAttribute()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c64800129.gtfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,att)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c64800129.rmfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc1)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,g1:GetCount(),0,0)
end
function c64800129.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end

--e4
function c64800129.repfilter(c,tp)
	return  c:IsLocation(LOCATION_MZONE) and c:IsCanChangePosition() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c64800129.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c64800129.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(64800129,1)) then
		local g=eg:Filter(c64800129.repfilter,nil,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c64800129.desrepval(e,c)
	return c64800129.repfilter(c,e:GetHandlerPlayer())
end
function c64800129.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject() 
	Duel.ChangePosition(tg,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end
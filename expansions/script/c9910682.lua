--神械仆从 清道者
function c9910682.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910682)
	e1:SetOperation(c9910682.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910682,2))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910683)
	e2:SetCondition(c9910682.spcon)
	e2:SetCost(c9910682.spcost)
	e2:SetTarget(c9910682.sptg)
	e2:SetOperation(c9910682.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910682.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(9822220,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1,fid)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910682,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(9910682)
	e2:SetTargetRange(1,0)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetCondition(c9910682.condition)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
end
function c9910682.condition(e)
	local tc=e:GetLabelObject()
	return tc and tc:IsPublic() and tc:GetFlagEffect(9822220)>0 and tc:GetFlagEffectLabel(9822220)==e:GetLabel()
end
function c9910682.rmfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsAttackAbove(1000) and c:IsDefenseAbove(1000) and c:IsFaceup() and c:IsAbleToRemove()
end
function c9910682.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910682.rmfilter,1,nil,tp)
end
function c9910682.cfilter(c)
	return c:IsSetCard(0xc954) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9910682.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c9910682.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
	local b2=Duel.IsPlayerAffectedByEffect(tp,9910682) and Duel.CheckLPCost(tp,2000)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9910682,0))) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c9910682.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c9910682.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c9910682.rmfilter,nil,tp)
	if chk==0 then return Duel.GetMZoneCount(tp,g)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910682.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

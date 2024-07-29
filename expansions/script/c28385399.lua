--闪耀的紫焰光 革命之刻
function c28385399.initial_effect(c)
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x283),2,99,true)
	c:EnableReviveLimit()
   --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCountLimit(1,28385399+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c28385399.hspcon)
	e0:SetOperation(c28385399.hspop)
	c:RegisterEffect(e0)
	--to grave and remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c28385399.tgcon)
	e1:SetTarget(c28385399.tgtg)
	e1:SetOperation(c28385399.tgop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c28385399.op)
	c:RegisterEffect(e2)
end
function c28385399.matfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsFusionSetCard(0x283) and c:IsCanBeFusionMaterial()
end
function c28385399.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c28385399.matfilter,c:GetOwner(),LOCATION_MZONE,0,nil)
	return mg:GetCount()>=2 and Duel.GetLP(c:GetOwner())<=3000
end
function c28385399.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectMatchingCard(tp,c28385399.matfilter,tp,LOCATION_MZONE,0,2,99,nil)
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c28385399.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c28385399.cfilter(c)
	return c:IsSetCard(0x283) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c28385399.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c28385399.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	if Duel.GetLP(tp)<=3000 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
end
function c28385399.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToGrave()
end
function c28385399.refilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToRemove()
end
function c28385399.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(300*ct)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local tct=Duel.GetMatchingGroupCount(c28385399.tgfilter,tp,LOCATION_DECK,0,nil)
	local rct=Duel.GetMatchingGroupCount(c28385399.refilter,tp,LOCATION_DECK,0,nil)
	if tct==0 and rct==0 then return end
	if tct>0 and (rct==0 or Duel.SelectOption(tp,1191,1192)==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c28385399.tgfilter,tp,LOCATION_DECK,0,1,math.min(tct,ct),nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c28385399.refilter,tp,LOCATION_DECK,0,1,math.min(tct,ct),nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c28385399.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c28385399.damcon)
	e1:SetValue(c28385399.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	local c=e:GetHandler()
	if Duel.GetLP(tp)<=3000 and c:IsCanAddCounter(0x1283,1) and Duel.SelectYesNo(tp,aux.Stringid(28385399,1)) then
		c:AddCounter(0x1283,1)
	end
end
function c28385399.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,28385399)==0
end
function c28385399.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and Duel.GetTurnPlayer()==tp then
		Duel.RegisterFlagEffect(tp,28385399,RESET_PHASE+PHASE_END,0,2)
		return 0
	elseif bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(tp,28385399,RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end

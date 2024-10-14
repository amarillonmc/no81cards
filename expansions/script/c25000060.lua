--金魁龙 黄金龙兽
function c25000060.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_FLIP),1)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,25000060)
	e1:SetTarget(c25000060.tgtg)
	e1:SetOperation(c25000060.tgop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,35000060)
	e2:SetCost(c25000060.discon)
	e2:SetCost(c25000060.cost)
	e2:SetTarget(c25000060.distg)
	e2:SetOperation(c25000060.disop)
	c:RegisterEffect(e2)
	if not c25000060.global_check then
		c25000060.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FLIP)
		ge1:SetOperation(c25000060.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c25000060.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(25000060,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c25000060.tgfilter(c)
	return c:IsPosition(POS_DEFENSE) and (c:IsAbleToGrave() or (c:IsFaceup() and c:IsCanTurnSet()))
end
function c25000060.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c25000060.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25000060.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c25000060.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c25000060.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsFacedown() or Duel.SelectOption(tp,1191,aux.Stringid(25000060,0))==0 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c25000060.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOnField() and rc:IsType(TYPE_MONSTER) and rc:GetFlagEffect(25000060)==0 and Duel.IsChainDisablable(ev)
end
function c25000060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFacedown() end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c25000060.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c25000060.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() then
		Duel.ChangePosition(rc,POS_FACEDOWN_DEFENSE)
	end
end

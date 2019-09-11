--幽灵骑士Ghost·卑弥呼魂
function c9980942.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),aux.NonTuner(Card.IsSetCard,0xcbc2),1)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9980942.rmcon)
	e1:SetCountLimit(1,9980942)
	e1:SetTarget(c9980942.rmtg)
	e1:SetOperation(c9980942.rmop)
	c:RegisterEffect(e1)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(9980942,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c9980942.target)
	e1:SetOperation(c9980942.operation)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c9980942.retreg)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980942.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980942.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980942,2))
end
function c9980942.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9980942.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil)==2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function c9980942.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>2 then ct=2 end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	if g:IsExists(aux.NOT(aux.FilterBoolFunction(Card.IsLocation,LOCATION_REMOVED)),1,nil) then return end
	g:KeepAlive()
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local fid=c:GetFieldID()
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(9980942,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc=g:GetNext()
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c9980942.thcon)
	e1:SetOperation(c9980942.thop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
	 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980942,3))
end
function c9980942.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9980942.thfilter(c,fid)
	return c:GetFlagEffectLabel(9980942)==fid
end
function c9980942.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		local g=e:GetLabelObject()
		if g:FilterCount(c9980942.thfilter,nil,e:GetLabel())==2 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980942,3))
end
function c9980942.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbc2) and c:IsAttackBelow(3000)
end
function c9980942.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980942.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980942.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9980942.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980942.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c9980942.atkfilter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980942,3))
end
function c9980942.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnCondition)
	e1:SetTarget(c9980942.rettg)
	e1:SetOperation(c9980942.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c9980942.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcbc2) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function c9980942.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c9980942.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
end
function c9980942.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980942.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoExtraP(c,nil,REASON_EFFECT)~=0
		and g:GetCount()>0 then
		  Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
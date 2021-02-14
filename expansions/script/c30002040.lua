--PSY骨架连接回路
function c30002040.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c30002040.handcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c30002040.spcon)
	e2:SetCost(c30002040.spcost)
	e2:SetTarget(c30002040.sptg)
	e2:SetOperation(c30002040.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c30002040.thtg)
	e3:SetOperation(c30002040.thop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(30002040,ACTIVITY_SPSUMMON,c30002040.counterfilter)
end
function c30002040.counterfilter(c)
	return c:IsSetCard(0xc1)
end
function c30002040.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c30002040.cfilter(c)
	return c:IsFaceup() and c:IsCode(8802510)
end
function c30002040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(c30002040.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c30002040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(30002040,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c30002040.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c30002040.splimit(e,c)
	return not c:IsSetCard(0xc1)
end
function c30002040.spfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xc1) and not c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30002040.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c30002040.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c30002040.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c30002040.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c30002040.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c30002040.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc1) and c:IsAbleToHand() and not c:IsCode(30002040)
end
function c30002040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30002040.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c30002040.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c30002040.thfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:Select(tp,1,g:GetCount(),nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
	if tg:GetCount()==0 then return end
	local fid=c:GetFieldID()
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_MSET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_SSET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		tc:RegisterFlagEffect(30002040,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	tg:KeepAlive()
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCountLimit(1)
	e5:SetLabel(fid)
	e5:SetLabelObject(tg)
	e5:SetCondition(c30002040.rmcon)
	e5:SetOperation(c30002040.rmop)
	Duel.RegisterEffect(e5,tp)
end
function c30002040.rmfilter(c,fid)
	return c:GetFlagEffectLabel(30002040)==fid
end
function c30002040.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c30002040.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c30002040.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c30002040.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end

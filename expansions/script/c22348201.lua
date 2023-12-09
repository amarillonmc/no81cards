--植 实 兽 斯 塔 贝 拉
local m=22348201
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348201,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348201)
	e1:SetTarget(c22348201.sptg)
	e1:SetOperation(c22348201.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348201,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,22348201)
	e2:SetCondition(c22348201.spcon)
	e2:SetTarget(c22348201.sptg)
	e2:SetOperation(c22348201.spop2)
	c:RegisterEffect(e2)
	--sucai
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348201,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348201.xyzcon)
	e3:SetCost(c22348201.xyzcost)
	e3:SetTarget(c22348201.xyztg)
	e3:SetOperation(c22348201.xyzop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCountLimit(1,22350205)
	e4:SetDescription(aux.Stringid(22348205,2))
	e4:SetCondition(c22348201.xyzcon2)
	c:RegisterEffect(e4)
	c22348201.discard_effect=e3
	--count
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_TO_HAND)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCondition(c22348201.checkcon)
		e4:SetOperation(c22348201.checkop)
		c:RegisterEffect(e4)
end
function c22348201.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c22348201.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(22348201,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348201,5))
end
function c22348201.tgfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:Is(LOCATION_ONFIELD))
end
function c22348201.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348201.tgfilter,1,nil)
end
function c22348201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348201.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(22348201,2)) then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function c22348201.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=ag:Filter(Card.IsRelateToEffect,nil,re)
	local g=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local gg=g:Filter(Card.IsAbleToHand,nil)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(22348201,3)) then
		Duel.BreakEffect()
		Duel.SendtoHand(gg,tp,REASON_EFFECT)
	end
end
function c22348201.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local ttp=e:GetHandler():GetControler()
	return e:GetHandler():GetFlagEffect(22348201)>0 and Duel.GetFlagEffect(ttp,22349201)==0
end
function c22348201.xyzcon2(e,tp,eg,ep,ev,re,r,rp)
	local ttp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tp,22348205) and Duel.GetFlagEffect(ttp,22349201)==0
end
function c22348201.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ttp=e:GetHandler():GetControler()
	if chk==0 then return true end
	Duel.RegisterFlagEffect(ttp,22349201,RESET_PHASE+PHASE_END,0,1)
end
function c22348201.xyz1filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_PLANT)
end
function c22348201.xyz2filter(c,e)
	return c:IsSetCard(0x707) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c22348201.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22348201.xyz2filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(c22348201.xyz2filter,tp,LOCATION_GRAVE,0,1,nil,e) and Duel.IsExistingMatchingCard(c22348201.xyz1filter,tp,LOCATION_MZONE,0,1,nil)
		and c:IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22348201.xyz2filter,tp,LOCATION_GRAVE,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c22348201.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c22348201.xyz1filter,tp,LOCATION_MZONE,0,1,nil) then
		local g=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,c22348201.xyz1filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Overlay(sg:GetFirst(),g)
	end
end





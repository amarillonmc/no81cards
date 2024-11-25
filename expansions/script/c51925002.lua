--眠人偶之洛希卡
function c51925002.initial_effect(c)
	aux.AddCodeList(c,51925001)
	--fusion material
	aux.AddFusionProcCode2(c,51925001,1482001,true,true)
	c:EnableReviveLimit()
	--be material
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,51925002)
	e1:SetCondition(c51925002.condition)
	e1:SetTarget(c51925002.target)
	e1:SetOperation(c51925002.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,51925003)
	e2:SetCondition(c51925002.drcon)
	e2:SetTarget(c51925002.drtg)
	e2:SetOperation(c51925002.drop)
	c:RegisterEffect(e2)
end
function c51925002.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c51925002.cfilter(c,check)
	return (check or c:IsType(TYPE_XYZ)) and c:IsCode(51925001) and c:IsFaceup()
end
function c51925002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c51925002.cfilter(chkc,false) end
	if chk==0 then return Duel.IsExistingTarget(c51925002.cfilter,tp,LOCATION_MZONE,0,1,nil,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c51925002.cfilter,tp,LOCATION_MZONE,0,1,1,nil,false)
end
function c51925002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c51925002.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51925002.cfilter,tp,LOCATION_ONFIELD,0,1,nil,true)
end
function c51925002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c51925002.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

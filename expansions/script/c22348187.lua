--跨 向 遥 远 的 旅 途
local m=22348187
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destory and search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348187,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22348187.thtg)
	e1:SetOperation(c22348187.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348187,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c22348187.drcon)
	e2:SetTarget(c22348187.drtg)
	e2:SetOperation(c22348187.drop)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348187,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c22348187.actcost)
	e3:SetTarget(c22348187.acttg)
	e3:SetOperation(c22348187.actop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	c:RegisterEffect(e4)
	if not c22348187.global_check then
		c22348187.global_check=true
		c22348187[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c22348187.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c22348187.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	
end
function c22348187.mvfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x706) and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(c22348187.mvfilter1,tp,LOCATION_MZONE,0,1,c)
end
function c22348187.mvfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x706) and c:GetSequence()<5
end
function c22348187.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c22348187.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22348187.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectMatchingCard(tp,c22348187.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectMatchingCard(tp,c22348187.mvfilter1,tp,LOCATION_MZONE,0,1,1,tc1)
	Duel.HintSelection(g2)
	local tc2=g2:GetFirst()
	Duel.SwapSequence(tc1,tc2)
		if tc:IsRelateToEffect(e) then
		   Duel.BreakEffect()
		   Duel.Destroy(tc,REASON_EFFECT)
		end
end
function c22348187.ckfilter(c)
	return c:IsSetCard(0x706) and c:IsType(TYPE_MONSTER)
end
function c22348187.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c22348187.ckfilter,1,nil) then
	c22348187[0]=1
	end
end
function c22348187.clearop(e,tp,eg,ep,ev,re,r,rp)
	c22348187[0]=0
end
function c22348187.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c22348187[0]>0
end
function c22348187.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348187.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c22348187.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22348187.actfilter(c,tp)
	return c:IsSetCard(0x706) and c:CheckActivateEffect(false,true,false)~=nil and c:GetType()==0x20004
end
function c22348187.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22348187.actfilter,tp,LOCATION_HAND,0,1,c,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22348187.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c22348187.actfilter,tp,LOCATION_HAND,0,1,1,c,tp)
	local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
end

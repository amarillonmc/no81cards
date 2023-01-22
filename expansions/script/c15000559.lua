local m=15000559
local cm=_G["c"..m]
cm.name="蚀烧地狱·砂蜃"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.sfcon)
	e2:SetOperation(cm.sfop)
	c:RegisterEffect(e2)
	--Target
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function cm.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.filter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function cm.sfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>1 then
		Duel.ShuffleSetCard(g)
	end
end
function cm.wfilter(c,e)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanBeEffectTarget(e)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.wfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cm.wfilter,tp,LOCATION_MZONE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TARGET)
	local ag=Duel.SelectMatchingCard(1-tp,cm.wfilter,tp,LOCATION_MZONE,0,1,1,nil,e)
	Duel.ConfirmCards(1-tp,ag)
	Duel.SetTargetCard(ag)
	if ag:GetFirst():IsSetCard(0xf3b) then
		ag:KeepAlive()
		local id=ag:GetFirst():GetRealFieldID()
		--local tc=ag:GetFirst()
		--act limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_FZONE)
		e1:SetLabelObject(ag)
		e1:SetLabel(id)
		e1:SetOperation(cm.chainop)
		e1:SetReset(RESET_CHAIN)
		e:GetHandler():RegisterEffect(e1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tc=e:GetLabelObject():GetFirst()
	local id=e:GetLabel()
	if not tc or not id then return end
	if rc==tc and tc:GetRealFieldID()==id then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
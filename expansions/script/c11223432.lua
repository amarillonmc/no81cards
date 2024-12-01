local m=11223432
local cm=_G["c"..m]
cm.name="源斗神 - 圣环"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Extra Effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--Material Check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(cm.valcheck)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
--Material Check
function cm.cfilter(c)
	return c:GetBaseAttack()==500 and c:GetBaseDefense()==500
end
function cm.valcheck(e,c)
	if c:GetMaterial():IsExists(cm.cfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	end
end
--Copy
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	local c=e:GetHandler()
	if c:IsFaceup() then
		--Attack
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCost(cm.movecost)
		e1:SetCondition(cm.movecon1)
		e1:SetTarget(cm.movetg1)
		e1:SetOperation(cm.moveop1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Effect
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(27978707,1))
		e2:SetCategory(CATEGORY_NEGATE)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_CHAINING)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCost(cm.movecost)
		e2:SetCondition(cm.movecon2)
		e2:SetTarget(cm.movetg2)
		e2:SetOperation(cm.moveop2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
function cm.movecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.movecon1(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE
end
function cm.movetg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local bt=eg:GetFirst()
	if chk==0 then return bt:IsFaceup() and bt:GetBaseAttack()==500 and bt:GetControler()==tp end
	Duel.SetTargetCard(bt)
end
function cm.moveop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() and tc and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end
function cm.movecon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	return g and g:GetCount()==1 and tc:IsFaceup() and tc:GetBaseAttack()==500 and tc:GetControler()==tp 
		and tc:IsLocation(LOCATION_MZONE) and Duel.IsChainNegatable(ev)
end
function cm.movetg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.moveop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateActivation(ev) and tc
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end
--Activate
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
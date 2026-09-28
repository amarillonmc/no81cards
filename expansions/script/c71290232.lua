--血火啊，燃烧前路
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①支付基本分到变成1：这个回合自己场上的记述怪兽攻升支付数值且不受对方发动的效果影响
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--自己场上有「迈德谟斯-亡国的王储-」存在的场合，从手卡也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--②手卡：把这张卡送去墓地才能发动（二速）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost2h)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--②墓地：让这张卡回到卡组才能发动
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(cm.cost2g)
	c:RegisterEffect(e3)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.myrimnosfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.myrimnosfilter(c)
	return c:IsFaceup() and c:IsCode(71290231)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1 end
	local lp=Duel.GetLP(tp)
	Duel.PayLPCost(tp,lp-1)
	e:SetLabel(lp-1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.recmfilter(c,tp)
	return aux.IsCodeListed(c,71290201) and c:IsControler(tp)
end
function cm.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local lp=e:GetLabel()
	--这个回合，自己场上的记述怪兽攻击力上升支付的基本分的数值
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.recmfilter)
	e1:SetValue(lp)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--不受对方发动的效果影响
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.recmfilter)
	e2:SetValue(cm.immval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.cost2h(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.cost2g(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.schfilter(c)
	return c:IsCode(71290201) and c:IsAbleToHand()
end
function cm.grantfilter(c)
	return aux.IsCodeListed(c,71290201) and c:IsFaceup()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.schfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.grantfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local labels={}
	if b1 then
		ops[off]=aux.Stringid(m,2)
		labels[off]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,3)
		labels[off]=2
		off=off+1
	end
	local s=Duel.SelectOption(tp,table.unpack(ops))
	local opt=labels[s+1]
	e:SetLabel(opt)
	if opt==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,cm.grantfilter,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.schfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			--泰坦之铭：以怪兽自身code为id放置flag并显示提示
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(tc:GetOriginalCode(),1))
		end
	end
end

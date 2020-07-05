--黑钢国际·行动-头号特训
function c79029048.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(9212051,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e0)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11234702,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c79029048.lvcost)
	e1:SetTarget(c79029048.lvtg)
	e1:SetOperation(c79029048.lvop)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26082117,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,79029048)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c79029048.cost)
	e2:SetTarget(c79029048.tg)
	e2:SetOperation(c79029048.op)
	c:RegisterEffect(e2)
	--atk def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c79029048.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c79029048.val(e,c,Counter)  
	if c:IsType(TYPE_XYZ) then return c:GetRank()*100
	else return c:GetLevel()*100 end
end
function c79029048.filter(c)
	return c:IsSetCard(0xa900) and c:IsFaceup() and c:GetLevel()>0
end
function c79029048.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,1,REASON_COST)
end
function c79029048.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029048.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029048.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79029048.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c79029048.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lvl=1
		local sel=Duel.SelectOption(tp,aux.Stringid(11234702,1),aux.Stringid(11234702,2))
		if sel==1 then
			lvl=-1
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c79029048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029048.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26082117,1))
	e:SetLabel(Duel.AnnounceLevel(tp,1,8))
end
function c79029048.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

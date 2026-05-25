-- 冬雪的冰痕 霜星
function c29055523.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	-- 二速无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29055523,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29055523)
	e1:SetTarget(c29055523.distg)
	e1:SetOperation(c29055523.disop)
	c:RegisterEffect(e1)
	-- 区域封锁
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29055523,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29055524)
	e2:SetTarget(c29055523.sztg)
	e2:SetOperation(c29055523.szop)
	c:RegisterEffect(e2)
end
-- 1
function c29055523.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c29055523.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e3)
end
-- 2
function c29055523.sztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c29055523.szop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local opp=1-tp
	local exc=(1<<21)|(1<<22)|(1<<29)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLEZONE)
	local dis=Duel.SelectField(tp,1,0,LOCATION_MZONE+LOCATION_SZONE,exc)
	if dis==0 then return end
	local sel_seq,sel_l
	for seq=0,4 do
		if dis&(1<<(16+seq))~=0 then
			sel_seq=seq sel_l=LOCATION_MZONE
		end
		if dis&(1<<(24+seq))~=0 then
			sel_seq=seq sel_l=LOCATION_SZONE
		end
	end
	if not sel_seq then return end
	local tc=Duel.GetFieldCard(opp,sel_l,sel_seq)
	if tc then Duel.SendtoGrave(tc,REASON_RULE) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(aux.SequenceToGlobal(opp,sel_l,sel_seq))
	e1:SetCondition(c29055523.discon2)
	Duel.RegisterEffect(e1,tp)
end
function c29055523.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end

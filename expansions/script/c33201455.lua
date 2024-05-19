--混沌圣堂的破坏者
local s,id,o=GetID()
Duel.LoadScript("c33201450.lua")
function s.initial_effect(c)
	VHisc_HDST.fth(c,id)
	--Position+Negate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetLabel(0)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
s.VHisc_hdst=true


function s.filter(c)
	return c:IsFaceup()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=Duel.GetFirstTarget()
	if VHisc_HDST.nck(tc) then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(24,0,aux.Stringid(id,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_REDIRECT,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(c:GetCode(),1))
		if e:GetLabel()==1 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
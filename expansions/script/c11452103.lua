--灯光舞台啸叫狂潮
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id-2,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local counter_eff=Effect.CreateEffect(c)
	counter_eff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	counter_eff:SetCode(EVENT_CHAINING)
	counter_eff:SetReset(RESET_PHASE+PHASE_END)
	counter_eff:SetLabel(0)
	counter_eff:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if rp==1-tp then
			e:SetLabel(e:GetLabel()+1)
		end
	end)
	Duel.RegisterEffect(counter_eff,tp)
	local e1=counter_eff:Clone()
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if rp==1-tp then
			counter_eff:SetLabel(counter_eff:GetLabel()+1)
		end
	end)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetLabelObject(counter_eff)
	e2:SetValue(s.damval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
end
function s.damval(e,re,val,r,rp,rc)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then
		local mult=1
		for i=1,ct do
			mult = mult * 2
		end
		return val * mult
	else
		return val
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetFlagEffect(tp,id-2)==0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,id-2,RESET_PHASE+PHASE_END,0,1)
	end
end
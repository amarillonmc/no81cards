--锦帆游侠 甘兴霸
function c33200032.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()   
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200032,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33200032)
	e1:SetCondition(c33200032.thcon)
	e1:SetTarget(c33200032.thtg)
	e1:SetOperation(c33200032.thop)
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--SendtoGrave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c33200032.rmcon)
	e3:SetTarget(c33200032.rmtg)
	e3:SetOperation(c33200032.rmop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c33200032.desreptg)
	e4:SetValue(c33200032.desrepval)
	e4:SetOperation(c33200032.desrepop)
	c:RegisterEffect(e4)
end

--e1
function c33200032.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c33200032.thfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c33200032.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c33200032.cfilter,1,nil,1-tp)
end
function c33200032.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function c33200032.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c33200032.thfilter,nil,e,1-tp)
	if sg:GetCount()>0 then
		if sg:GetCount()>1 then 
			local thg=sg:RandomSelect(tp,1)
			Duel.SendtoHand(thg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		else
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--e3
function c33200032.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() 
	and bc:IsRelateToBattle()
end
function c33200032.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetLabelObject(),1,0,0)
end
function c33200032.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.SendtoGrave(bc,REASON_EFFECT)
	end
end

--e4
function c33200032.repfilter(c,tp)
	return  c:IsLocation(LOCATION_ONFIELD) and c:IsAbleToHand() and c:IsControler(tp)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c33200032.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33200032.repfilter,1,nil,tp) 
		and e:GetHandler():GetFlagEffect(33200032)==0 end
	if Duel.SelectYesNo(tp,aux.Stringid(33200032,0)) then
		local g=eg:Filter(c33200032.repfilter,nil,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c33200032.desrepval(e,c)
	return c33200032.repfilter(c,e:GetHandlerPlayer())
end
function c33200032.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject() 
	Duel.SendtoHand(tg,nil,REASON_EFFECT+REASON_REPLACE)
	Duel.ConfirmCards(1-tp,tg)
	e:GetHandler():RegisterFlagEffect(33200032,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,nil,0,aux.Stringid(33200032,1))
end
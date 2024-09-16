--黄金哥布林
local m=22348425
local cm=_G["c"..m]
function cm.initial_effect(c)
	--dr1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348425,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1,22348425)
	e1:SetCost(c22348425.drcost)
	e1:SetCondition(c22348425.drcon)
	e1:SetOperation(c22348425.drop)
	c:RegisterEffect(e1)
	--dr2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22349425,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c22348425.cdcon)
	e2:SetOperation(c22348425.cdop)
	c:RegisterEffect(e2)
	
end
function c22348425.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22348425.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c22348425.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1=0
	local d2=0
	if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(22348425,1)) then
		d1=1
	end
	if Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(22348425,1)) then
		d2=1
	end
	if d1==1 then
	   d1=Duel.Draw(tp,3,REASON_EFFECT)
	end
	if d2==1 then
	   d2=Duel.Draw(1-tp,3,REASON_EFFECT)
	end
	if d1<1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DRAW)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if d2<1 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_DRAW)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end

function c22348425.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c22348425.cdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetValue(3)
	Duel.RegisterEffect(e1,tp)
end


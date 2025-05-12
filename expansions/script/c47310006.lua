-- 面灵气 欢喜的狮子面
Duel.LoadScript('c47310000.lua')
local s,id=GetID()

function s.effgain(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
	e1:SetOperation(s.op)
	return e1
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(s.drcon)
	e1:SetOperation(s.drop)
	e1:SetLabelObject(c)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and e:GetOwner():GetFlagEffect(id)>0
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:IsOnField() and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.draw(c)
    local e1=Hnk.become_target(c,id)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetTarget(s.drtg2)
	e1:SetOperation(s.drop2)
	c:RegisterEffect(e1)
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.initial_effect(c)
    Hnk.hnk_equip(c,id,s.effgain(c))
    Hnk.fun_eq(c)
	s.draw(c)
end

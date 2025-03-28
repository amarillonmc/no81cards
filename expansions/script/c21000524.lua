--加奈子冒险 - 一脚踢开
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_RECOVER)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_CHAIN_SOLVED)
	e11:SetRange(LOCATION_SZONE)
	e11:SetOperation(s.prop0)
	c:RegisterEffect(e11)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con)
	e2:SetTarget(s.target)
	e2:SetOperation(s.prop)
	c:RegisterEffect(e2)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(s.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function s.prop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler()~=c then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Recover(tp,200,REASON_EFFECT)
	end
end

function s.filter2(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x608) or (c:IsSetCard(0x605) and c:IsType(TYPE_SPIRIT)))
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x605)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1500,REASON_EFFECT)
	Duel.BreakEffect()
	
	if Duel.GetLP(tp)>=10000 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DAMAGE)
		e2:SetCondition(s.reccon)
		e2:SetOperation(s.recop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.atktg(e,c)
	return c:IsSetCard(0x605) and c:IsType(TYPE_SPIRIT)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsSetCard(0x605) and eg:GetFirst():IsType(TYPE_SPIRIT)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end


function s.indcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())>=10000
end
--极简出售
function c65850065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65850065+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65850065.target)
	e1:SetOperation(c65850065.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65850065,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c65850065.rmcon)
	c:RegisterEffect(e3)
end


function c65850065.filter(c)
	return c:IsSetCard(0xa35) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c65850065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(c65850065.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c65850065.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850065.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65850065.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c65850065.splimit(e,c)
	return not c:IsSetCard(0xa35)
end
function c65850065.filter1(c)
	return c:IsSetCard(0xa35) and c:IsFaceup()
end
function c65850065.rmcon(e)
	return (Duel.IsExistingMatchingCard(c65850065.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0)
end
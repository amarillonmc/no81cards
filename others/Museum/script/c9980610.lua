--平成骑士幽汽·劫持形态
function c9980610.initial_effect(c)
	  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6bcb),aux.AND(aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),aux.FilterBoolFunction(Card.IsFusionSetCard,0x3bcd)),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980610.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c9980610.aclimit)
	e2:SetCondition(c9980610.actcon)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980610,1))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9980610.drtg)
	e4:SetOperation(c9980610.drop)
	c:RegisterEffect(e4)
end
function c9980610.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980610,0))
end
function c9980610.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c9980610.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end 
function c9980610.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980610.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0x3bcd,0x6bcb) and tc:IsType(TYPE_MONSTER) then
		Duel.Damage(1-tp, tc:GetAttack(),REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980610,1))
--  Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
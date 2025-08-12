--冷面杀手
function c28326245.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c28326245.atkval)
	c:RegisterEffect(e1)
	--be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28326245,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c28326245.thcon)
	e2:SetTarget(c28326245.thtg)
	e2:SetOperation(c28326245.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
end
function c28326245.atkfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk-1)
end
function c28326245.atkval(e,c)
	return Duel.GetMatchingGroupCount(c28326245.atkfilter,c:GetControler(),0,LOCATION_MZONE,nil,c:GetBaseAttack())*1000
end
function c28326245.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c28326245.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c28326245.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

--fate·店长哈桑
function c9950494.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba5),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950494,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9950494.con)
	e1:SetOperation(c9950494.op)
	c:RegisterEffect(e1)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950494,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9950494.cost)
	e1:SetTarget(c9950494.target)
	e1:SetOperation(c9950494.activate)
	c:RegisterEffect(e1)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950494.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950494.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950494,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950494,2))
end
function c9950494.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9950494.filter2(c)
	return c:IsFaceup() and c:IsLevelBelow(2) and c:IsSetCard(0xba5)
end
function c9950494.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9950494.filter2,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=0
		local tc=g:GetFirst()
		while tc do
			atk=atk+tc:GetAttack()
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c9950494.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9950494.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c9950494.filter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk)
end
function c9950494.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9950494,1))
		local tg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsAttackAbove(0) and Duel.IsExistingMatchingCard(c9950494.filter,tp,LOCATION_MZONE,0,1,nil,tc:GetAttack()) then
				Duel.Destroy(tc,REASON_EFFECT)
				Duel.Damage(1-tp,500,REASON_EFFECT)
			else
				Duel.Damage(tp,500,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(1-tp)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950494,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950494,3))
end
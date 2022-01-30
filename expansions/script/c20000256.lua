--食星鸟的啼唤
function c20000256.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,20000256)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c20000256.tg2)
	e2:SetOperation(c20000256.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c20000256.tg3)
	e3:SetValue(c20000256.val3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(c20000256.con5)
	e5:SetTarget(c20000256.tg5)
	c:RegisterEffect(e5)
end
--e2
function c20000256.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(c20000256.tgf2,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 
	if chk==0 then return b1 or b2 end
end
function c20000256.tgf2(c)
	return c:IsSetCard(0x3fd2)
end
function c20000256.op2(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(c20000256.tgf2,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(20000256,0),aux.Stringid(20000256,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(20000256,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(20000256,1))+1
	else return end
	if op==0 then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20000256,0))
		local g=Duel.SelectMatchingCard(tp,c20000256.tgf2,tp,LOCATION_DECK,0,1,1,nil) 
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
--e3
function c20000256.tg3(e,c)
	return c:IsSetCard(0x3fd2)
end
function c20000256.valf3(c)
	return c:IsType(TYPE_MONSTER)
end
function c20000256.val3(e,c)
	local g=Duel.GetMatchingGroup(c20000256.valf3,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return 0 end
	local tc=g:GetMaxGroup(Card.GetOriginalLevel)
	local c=tc:GetFirst()
	return c:GetOriginalLevel()*300
end
--e5
function c20000256.cf5(c) 
	return c:IsCode(20000205) and c:IsFaceup()
end
function c20000256.con5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20000256.cf5,tp,LOCATION_MZONE,0,1,nil)
end
function c20000256.tg5(e,c)
	return c:IsLevel(0)
end
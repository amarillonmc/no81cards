--阿米娅·瑟谣浮收藏-执棋者
function c79029363.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029037)
	c:RegisterEffect(e2)  
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79029363.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e4)  
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,79029363)
	e5:SetTarget(c79029363.ddtg)
	e5:SetOperation(c79029363.ddop)
	c:RegisterEffect(e5)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029363,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,09029363)
	e1:SetTarget(c79029363.datg)
	e1:SetOperation(c79029363.daop)
	c:RegisterEffect(e1) 
end
function c79029363.val(e,c)
	return Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_HAND,0):GetCount()*800
end
function c79029363.tgfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGrave()
end
function c79029363.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local m=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029363.tgfil,tp,LOCATION_HAND,0,1,nil) and m>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c79029363.ddop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我知道了！")
	Duel.Hint(HINT_SOUND,tp,aux.Stringid(79029363,2))
	local m=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.SelectMatchingCard(tp,c79029363.tgfil,tp,LOCATION_HAND,0,1,m,nil)
	if g:GetCount()>0 then
	Duel.SendtoGrave(g,REASON_EFFECT)
	local x=Duel.Draw(tp,g:GetCount(),REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SetLP(tp,Duel.GetLP(tp)-x*500)
	end
end
function c79029363.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0xa900) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end
end
function c79029363.daop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("行动开始！")
	Duel.Hint(HINT_SOUND,tp,aux.Stringid(79029363,3))
	local tc1=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0xa900):GetFirst()
	local tc2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	Duel.CalculateDamage(tc1,tc2) 
end


















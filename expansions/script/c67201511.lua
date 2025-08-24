--死神-“死亡执政官”
function c67201511.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	c:EnableReviveLimit()
	--aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	aux.AddCodeList(c,67201503,67201512)   
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67201511)
	e1:SetCost(c67201511.limcost)
	e1:SetOperation(c67201511.limop)
	c:RegisterEffect(e1)
	c67201511.pendulum_effect=e1  
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c67201511.target)
	e2:SetOperation(c67201511.activate)
	c:RegisterEffect(e2)
end
function c67201511.cfilter(c)
	return aux.IsCodeListed(c,67201503) and c:IsDiscardable()
end
function c67201511.limcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201511.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c67201511.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c67201511.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c67201511.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67201511.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
--
function c67201511.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToRemove() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function c67201511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c67201511.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67201511.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local g=Duel.SelectTarget(tp,c67201511.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c67201511.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=tc:IsRelateToEffect(e) and tc:IsAbleToRemove()
	local b2=tc:IsRelateToEffect(e) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and aux.NecroValleyFilter()(tc) 
	if b1 or b2 then
		local s
		if b1 and b2 then
			s=Duel.SelectOption(tp,aux.Stringid(67201511,1),aux.Stringid(67201511,2))
		elseif b1 then
			s=Duel.SelectOption(tp,aux.Stringid(67201511,1))
		else
			s=Duel.SelectOption(tp,aux.Stringid(67201511,2))+1
		end
		if s==0 then
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:GetBaseAttack()>=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
				e1:SetValue(tc:GetBaseAttack())
				c:RegisterEffect(e1)
			end
		end
		if s==1 then
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c10111124.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),8,3,c10111124.ovfilter,aux.Stringid(10111124,0))
	c:SetUniqueOnField(1,0,10111124)
	c:EnableReviveLimit()
    	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)
	e1:SetCost(c10111124.cost)
	e1:SetTarget(c10111124.damtg)
	e1:SetOperation(c10111124.damop)
	c:RegisterEffect(e1)
    	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111124,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c10111124.drtg)
	e2:SetOperation(c10111124.drop)
	c:RegisterEffect(e2)
end
function c10111124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10111124.ovfilter(c)
	return c:IsFaceup() and c:IsRank(4,5) and c:IsSetCard(0x1b8)
end
function c10111124.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end 
function c10111124.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(4) and c:IsSetCard(0x1b8)   
end 
function c10111124.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c10111124.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10111124,1)) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,c10111124.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c10111124.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanRemove(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
end
function c10111124.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)<1 then return end
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,99,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)<1 then return end
	local c=e:GetHandler()
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if c:IsRelateToEffect(e) and c:IsFaceup() and ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(ct*400)
		c:RegisterEffect(e1)
	end
end
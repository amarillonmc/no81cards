--霜叶·瑟谣浮收藏-冷饮
function c79029327.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c79029327.matfilter,5,2,c79029327.ovfilter,aux.Stringid(79029327,0))
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029108)
	c:RegisterEffect(e2)	
	--duel status
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e1:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029327.cost)
	e1:SetCondition(c79029327.condition)
	e1:SetTarget(c79029327.target)
	e1:SetOperation(c79029327.operation)
	c:RegisterEffect(e1)  
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c79029327.discon)
	e2:SetTarget(c79029327.distg)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)  
	c:RegisterEffect(e3)	  
end
function c79029327.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_DUAL)
end
function c79029327.matfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c79029327.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029327.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rc:GetControler()~=tp
end
function c79029327.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029327.spfil(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029327.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	Debug.Message("让头脑清醒点吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029327,2))
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(c79029327.spfil,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79029327,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c79029327.spfil,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	Debug.Message("各行其道，各尽其职。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029327,3))
	end
end
function c79029327.dixfil(c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_DUAL)
end
function c79029327.discon(e,c)
	return e:GetHandler():GetOverlayGroup():IsExists(c79029327.dixfil,1,nil)
end
function c79029327.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end









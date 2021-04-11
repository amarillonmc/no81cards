--极光战姬 塞拉丝怀特
function c40009611.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c40009611.ovfilter,aux.Stringid(40009611,0))
	c:EnableReviveLimit()   
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009611,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009611)
	e1:SetCost(c40009611.cost)
	e1:SetTarget(c40009611.target)
	e1:SetOperation(c40009611.operation)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009611,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16691075)
	e2:SetCondition(c40009611.spcon)
	e2:SetTarget(c40009611.sptg)
	e2:SetOperation(c40009611.spop)
	c:RegisterEffect(e2)
end
function c40009611.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbf1b) and c:IsType(TYPE_XYZ) and c:IsRank(3)
end
function c40009611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c40009611.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function c40009611.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.GetType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) and Duel.IsExistingMatchingCard(c40009611.xctgfilter,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,2,nil)
end
function c40009611.operation(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(c40009611.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if g0:GetCount()>0 and tg:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,c40009611.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local tc=g2:GetFirst()
		Duel.Overlay(tc,tg)
	end
end
function c40009611.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(c40009611.xctgfilter,tp,LOCATION_FZONE,0,1,nil)
end
function c40009611.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40009611.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c40009611.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) then
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		   local g1=tc:GetOverlayGroup()
		   if g1:GetCount()==0 then return end
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40009611,3))
		   local mg=g1:Select(tp,1,1,nil)
		   local oc=mg:GetFirst():GetOverlayTarget()
		   Duel.Overlay(c,mg)
		   Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)



		end
	end
end






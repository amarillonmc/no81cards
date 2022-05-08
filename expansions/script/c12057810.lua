--教导的蛟龙神
function c12057810.initial_effect(c)
	--nontuner
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCode(EFFECT_NONTUNER)
	e0:SetValue(c12057810.tnval)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(12057810,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,12057810)
	e1:SetTarget(c12057810.sptg)
	e1:SetOperation(c12057810.spop)
	c:RegisterEffect(e1)
	--t or p  
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12057810,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,32057810)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c12057810.xthtg)
	e4:SetOperation(c12057810.xthop)
	c:RegisterEffect(e4)
end
function c12057810.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c12057810.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c12057810.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil) 
	if g:GetCount()<=0 then return end 
	local dg=g:Select(tp,1,1,nil) 
	if Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c12057810.xthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetTurnPlayer()==1-tp and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c12057810.xthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e3)
	end 
end



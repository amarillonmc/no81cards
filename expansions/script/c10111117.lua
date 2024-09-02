function c10111117.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c10111117.mfilter,5,3,c10111117.ovfilter,aux.Stringid(10111117,0),3,c10111117.xyzop)
	c:EnableReviveLimit()
  --immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10111117.efilter1)
	c:RegisterEffect(e1)
--disable special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111117,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10111117.discon)
	e2:SetCost(c10111117.discost)
	e2:SetTarget(c10111117.distg)
	e2:SetOperation(c10111117.disop)
	c:RegisterEffect(e2)
end
function c10111117.mfilter(c)
	return c:IsRace(RACE_WARRIOR) 
end
function c10111117.ovfilter(c)
	return c:IsFaceup() and c:IsCode(48009503)
end
function c10111117.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c10111117.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c10111117.costfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c10111117.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10111117.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c10111117.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
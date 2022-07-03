--屠谕者 大群意志
function c79078000.initial_effect(c)

	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79078000)
	e1:SetCondition(c79078000.xspcon)
	e1:SetTarget(c79078000.xsptg)
	e1:SetOperation(c79078000.xspop)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetRange(LOCATION_DECK)
	c:RegisterEffect(e2)	

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79078000,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,79078000+1500)
	e3:SetCondition(c79078000.spcon1)
	e3:SetTarget(c79078000.sptg1)
	e3:SetOperation(c79078000.spop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
c79078000.named_with_Massacre=true 
function c79078000.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FISH) and c:IsAbleToRemoveAsCost()
end

function c79078000.xspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79078000.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,c) and (Duel.GetFlagEffect(tp,79078007)~=0 or not c:IsLocation(LOCATION_DECK))
end
function c79078000.xsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c79078000.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c79078000.xspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end


function c79078000.cfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH)
end
function c79078000.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79078000.cfilter1,1,nil)
end
function c79078000.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c79078000.spop1(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

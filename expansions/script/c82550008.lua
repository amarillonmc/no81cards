--领袖钢战-神力火焰擎天柱
function c82550008.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),8,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82550008,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c82550008.adcost)
	e2:SetCountLimit(1,82550008)
	e2:SetTarget(c82550008.target)
	e2:SetOperation(c82550008.activate)
	e2:SetValue(c82550008.rdval)
	c:RegisterEffect(e2)
	--Overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82550008,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82550108)
	e3:SetCondition(c82550008.olcon)
	e3:SetTarget(c82550008.oltg)
	e3:SetOperation(c82550008.olop)
	c:RegisterEffect(e3)
end
function c82550008.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c82550008.olcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c82550008.cfilter,1,nil,1-e:GetHandler():GetControler()) 
end
function c82550008.olfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x829) 
end
function c82550008.oltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) 
	  and Duel.IsExistingMatchingCard(c82550008.olfilter,tp,LOCATION_MZONE,0,1,nil)  
	end
	e:SetLabelObject(eg)
end
function c82550008.olop(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetLabelObject()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local ol=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local xyz=Duel.SelectMatchingCard(tp,c82550008.olfilter,tp,LOCATION_MZONE,0,1,1,nil) 
	local xyzz=xyz:GetFirst()
	if ol:GetCount()>0 then
	local tc=ol:GetFirst()
	local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	if eg:GetCount()>0 then
	ol:Merge(eg)
	end
	Duel.Overlay(xyzz,ol)
	end
end
function c82550008.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82550008.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x829)
end
function c82550008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82550008.filter,tp,LOCATION_MZONE,0,nil)
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82550008.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82550008.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82550008.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
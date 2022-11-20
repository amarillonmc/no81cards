--未知飞龙
function c10113057.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c10113057.mfilter,c10113057.xyzcheck,1,99)
	--xyzlimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)  
	--gaineffect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10113057,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c10113057.rmcon)
	e3:SetTarget(c10113057.rmtg)
	e3:SetOperation(c10113057.rmop)
	c:RegisterEffect(e3)
	if not c10113057.cardval then
	   c10113057.cardval=c
	end
end
function c10113057.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10113057.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()~=0 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsAbleToGrave,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c10113057.rmop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	if og:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=og:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) then
	   e:GetHandler():CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000)
	end
end
function c10113057.mfilter(c,xyzc)
	c10113057.cardval=c
	return c:IsXyzLevel(xyzc,4) or (c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0)
end
function c10113057.nmfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c10113057.xyzcheck(g)
	if g:FilterCount(c10113057.nmfilter,nil)==g:GetCount() then return true end
	if g:GetCount()<6 and g:FilterCount(Card.IsXyzLevel,nil,c10113057.cardval,4)==g:GetCount() then return true end
	return false
end

--推进之王·生命之地收藏-遗石
function c79029273.initial_effect(c)
	c:SetSPSummonOnce(79029273)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c79029273.ovfilter,aux.Stringid(79029273,0))
	c:EnableReviveLimit()  
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029022)
	c:RegisterEffect(e2)
	--0v
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,79029273)
	e2:SetCondition(c79029273.ovcon)
	e2:SetTarget(c79029273.ovtg)
	e2:SetOperation(c79029273.ovop)
	c:RegisterEffect(e2)	 
	--ov 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c79029273.ovcon2)
	e3:SetOperation(c79029273.op)
	c:RegisterEffect(e3)
end
function c79029273.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_XYZ) and c:IsRank(7) and c:GetOverlayCount()==0
end
function c79029273.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029273.ovfil(c)
	return c:GetSequence()>4
end
function c79029273.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029273.ovfil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c79029273.ovfil,tp,0,LOCATION_MZONE,nil)
	Duel.SetTargetCard(g)
end
function c79029273.ovop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Overlay(e:GetHandler(),g)
	Debug.Message("一口气解决。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029273,1))   
end
function c79029273.ovcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(Card.IsReason,nil,REASON_COST):GetCount()>0 and re:IsHasType(0x7e0) and eg:Filter(Card.IsPreviousLocation,nil,LOCATION_OVERLAY):GetCount()>0
	and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
end
function c79029273.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
	local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_OVERLAY)
	Duel.Overlay(e:GetHandler(),g)
	Debug.Message("保持冷静，继续前行。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029273,2))  
	end
end








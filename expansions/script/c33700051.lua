--GUARDIAN 瑚太朗
function c33700051.initial_effect(c)
 c:EnableCounterPermit(0x1021)	 
  --xyz summon
	aux.AddXyzProcedure(c,c33700051.mfilter,5,2,c33700051.ovfilter,aux.Stringid(33700051,0),2,c33700051.xyzop)
	c:EnableReviveLimit()
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700051,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c33700051.spcost)
	e1:SetTarget(c33700051.sptg)
	e1:SetOperation(c33700051.spop)
	c:RegisterEffect(e1)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700051,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33700051)
	e3:SetCost(c33700051.ccost)
	e3:SetTarget(c33700051.ctg)
	e3:SetOperation(c33700051.cop)
	c:RegisterEffect(e3) 
	--Remove counter replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700051,2))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_RCOUNTER_REPLACE+0x1021)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c33700051.rcon)
	e4:SetOperation(c33700051.rop)
	c:RegisterEffect(e4)
end
function c33700051.mfilter(c)
	return  c:IsAttribute(ATTRIBUTE_EARTH)
end
function c33700051.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x441) and c:GetLevel()==5
end
function c33700051.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33700051)==0 end
	Duel.RegisterFlagEffect(tp,33700051,RESET_PHASE+PHASE_END,0,1)
end
function c33700051.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():GetCounter(0x1021)>1 end
  e:GetHandler():RemoveCounter(tp,0x1021,2,REASON_COST)
end
function c33700051.filter(c,e,tp)
	return c:IsSetCard(0x441) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700051.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>-1
		and Duel.IsExistingMatchingCard(c33700051.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c33700051.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700051.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c33700051.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end
function c33700051.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsCanAddCounter(0x1021,3) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x1021)
end
function c33700051.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x1021,3)
	end
end
function c33700051.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0  and e:GetHandler():GetCounter(0x1021)>=ev and re:GetHandler()~=e:GetHandler()
end
function c33700051.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1021,1,REASON_EFFECT)
end
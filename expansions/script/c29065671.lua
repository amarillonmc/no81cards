--灵知隐者 不可思议的魔法面包
function c29065671.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	c:SetSPSummonOnce(29065671)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,c29065671.ovfilter,aux.Stringid(29065671,0))
	c:EnableReviveLimit()  
	--p
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c29065671.pcost)
	e1:SetTarget(c29065671.ptg)
	e1:SetOperation(c29065671.pop)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c29065671.rvtg)
	e1:SetOperation(c29065671.rvop)
	c:RegisterEffect(e1)   
end
c29065671.pendulum_level=6
function c29065671.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x87aa) and c:IsType(TYPE_LINK)
end
function c29065671.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065671.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c29065671.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(29065671,1)) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c29065671.cnfil(c,e,tp)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:IsControler(tp)
end
function c29065671.spfil(c,e,tp)
	return c:IsSetCard(0x87aa) and c:IsFaceup() and  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c29065671.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c29065671.cnfil,nil,e,tp)
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(c29065667.spfil,tp,LOCATION_EXTRA,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29065671.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c29065671.spfil,tp,LOCATION_EXTRA,e:GetHandler(),nil,e,tp)
	if g1:GetCount()<=0 then return end
	tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end













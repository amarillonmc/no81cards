--方舟骑士团·驰援
local m=29012288
local c29012288=_G["c"..m]
function c29012288.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29012288,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,29012288)
	e1:SetTarget(c29012288.sptg)
	e1:SetOperation(c29012288.spop)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29012288,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,29012289)
	e2:SetCondition(c29012288.xyzcon)
	e2:SetTarget(c29012288.xyztg)
	e2:SetOperation(c29012288.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c29012288.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	
end
function c29012288.spfilter(c,e,tp)
	return c:IsSetCard(0x87af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0) or c:IsLocation(LOCATION_HAND))
end
function c29012288.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29012288.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c29012288.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29012288.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29012288.eftg(e,c)
	return c:IsSetCard(0x87af) and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and c:IsRankBelow(6)
end
function c29012288.xyzfilter(c,e)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(e:GetHandler()) and not c:IsCode(e:GetHandler():GetCode())
end
function c29012288.cfilter(c)
	return c:IsDiscardable()
end
function c29012288.xyzcon(e,c,tp)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c29012288.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e) and Duel.IsExistingMatchingCard(c29012288.cfilter,tp,LOCATION_HAND,0,1,nil) 
end
function c29012288.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=Duel.GetMatchingGroup(c29012288.xyzfilter,tp,LOCATION_MZONE,0,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Duel.DiscardHand(tp,c29012288.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
		local xg=g:Select(tp,1,1,nil)
		xg:KeepAlive()
		e:SetLabelObject(xg)
	return true
	else return false end
end
function c29012288.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
	   Duel.Overlay(c,mg2)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
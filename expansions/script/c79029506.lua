--CiNo.5 亡胧龙 亡灵嵌合龙
function c79029506.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,4,nil,nil,99) 
	c:EnableReviveLimit() 
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029506.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c79029506.recost)
	e3:SetOperation(c79029506.reop)
	c:RegisterEffect(e3)
	--btd
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c79029506.tdcon)
	e4:SetOperation(c79029506.tdop)
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,79029506+EFFECT_COUNT_CODE_DUEL)
	e7:SetTarget(c79029506.sptg)
	e7:SetOperation(c79029506.spop)
	c:RegisterEffect(e7)
end
aux.xyz_number[79029506]=5
function c79029506.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetCount()*1500
end
function c79029506.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029506.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local a=g:RandomSelect(tp,1)
	local tc=a:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	tc:RegisterFlagEffect(79029506,0,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_MSET+EFFECT_CANNOT_SUMMON+EFFECT_CANNOT_SPECIAL_SUMMON+EFFECT_CANNOT_SSET+EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(1,1)
	e1:SetValue(c79029506.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c79029506.efilter(c)
	return c:GetFlagEffect(79029506)~=0
end
function c79029506.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029506.efilter,tp,0,LOCATION_REMOVED,1,nil) 
end
function c79029506.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029506.efilter,tp,0,LOCATION_REMOVED,nil)
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)~=0 then
	local x=g:GetCount()
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)	
	local sg=g1:RandomSelect(tp,x)
	Duel.Overlay(e:GetHandler(),sg) 
end
end
function c79029506.fill(c,e,tp)
	return c:IsSetCard(0x2048)
end
function c79029506.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and c79029506.fill(e,c,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c79029506.fill,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029506.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029506.fill,tp,LOCATION_EXTRA,0,nil)
	local a=g:RandomSelect(tp,1)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		Duel.SpecialSummon(a,1,tp,tp,false,false,POS_FACEUP)
	end
end

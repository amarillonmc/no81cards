--整合运动·无人机-法术大师A2
function c79020021.initial_effect(c)
	c:SetSPSummonOnce(79020021)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c79020021.ovfilter,aux.Stringid(79020021,0))
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79020021.spcost)
	e1:SetTarget(c79020021.sptg)
	e1:SetOperation(c79020021.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79020021.reptg)
	e2:SetOperation(c79020021.repop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetTarget(c79020021.target)
	e3:SetOperation(c79020021.operation)
	c:RegisterEffect(e3) 
end
function c79020021.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3903) and c:IsType(TYPE_LINK)
end
function c79020021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79020021.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsSetCard(0x3903)
end
function c79020021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and c79020021.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(c79020021.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79020021.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79020021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
end
end 
function c79020021.filter(c,g)
	return c:IsFaceup() and c:IsSetCard(0x3903)
		and g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c79020021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c79020021.filter,tp,LOCATION_MZONE,0,1,nil,lg) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),79029096)
end
function c79020021.repop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectReleaseGroup(tp,c79020021.filter,1,1,nil,lg)
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_EFFECT+REASON_REPLACE)
end
function c79020021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetLinkedGroupCount()~=0 end
	local dam=e:GetHandler():GetLinkedGroupCount()*700 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c79020021.operation(e,tp,eg,ep,ev,re,r,rp)
	 local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
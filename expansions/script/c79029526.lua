--CiNo.101 寂静荣誉方舟骑士·源望
function c79029526.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,4)
	c:EnableReviveLimit()   
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c79029526.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12744567,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029526.remct)
	e3:SetTarget(c79029526.remtg)
	e3:SetOperation(c79029526.remop)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12744567,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c79029526.spcon)
	e4:SetTarget(c79029526.sptg)
	e4:SetOperation(c79029526.spop)
	c:RegisterEffect(e4)
	--operator
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(52792430,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetTarget(c79029526.sptg1)
	e5:SetOperation(c79029526.spop1)
	c:RegisterEffect(e5)
end
c79029526.xyz_number=101
function c79029526.atkval(e,c)
	return c:GetOverlayCount()*500
end
function c79029526.remct(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local x=c:GetOverlayCount()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,x,x,REASON_COST)
end
function c79029526.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c79029526.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(79029526,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(79029526,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(79029526,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Overlay(e:GetHandler(),sg)
end
function c79029526.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c79029526.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local rec=e:GetHandler():GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c79029526.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,true,POS_FACEUP)>0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_EXTRA,0,1,nil) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(79029526,4)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.Overlay(e:GetHandler(),g1)
	end
end
end
function c79029526.spfilter(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029526.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029526.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c79029526.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029526.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

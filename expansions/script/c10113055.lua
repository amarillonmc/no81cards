--黑灵石
function c10113055.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113055,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c10113055.mtg)
	e1:SetOperation(c10113055.mop)
	c:RegisterEffect(e1)
	--xyzma
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113055,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c10113055.macost)
	e2:SetTarget(c10113055.matg)
	e2:SetOperation(c10113055.maop)
	c:RegisterEffect(e2)  
end
function c10113055.mafilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c10113055.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c10113055.mafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113055.mafilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10113055.mafilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10113055.maop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:GetOverlayCount()>0 then
	   local mg=tc:GetOverlayGroup()
	   Duel.SendtoGrave(mg,REASON_EFFECT)
	end
end
function c10113055.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10113055.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and ec:IsFaceup() and ec:IsType(TYPE_XYZ) and ec:GetSummonPlayer()~=tp end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,ec,1,0,0)
end
function c10113055.mop(e,tp,eg,ep,ev,re,r,rp)
	local c,ec=e:GetHandler(),eg:GetFirst()
	if not c:IsRelateToEffect(e) or not ec:IsRelateToEffect(e) then return end
	   Duel.Overlay(ec,Group.FromCards(c))
	   if ec:GetOverlayGroup():IsContains(c)then
		  Duel.ChangePosition(ec,POS_FACEDOWN_DEFENSE)
	   end
end
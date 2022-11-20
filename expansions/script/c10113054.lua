--白灵石
function c10113054.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113054,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c10113054.sptg)
	e1:SetOperation(c10113054.spop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10113054,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c10113054.pocost)
	e3:SetTarget(c10113054.potg)
	e3:SetOperation(c10113054.poop)
	c:RegisterEffect(e3)
end
function c10113054.pofilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_SYNCHRO)
end
function c10113054.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c10113054.pofilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113054.pofilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10113054.pofilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c10113054.poop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c10113054.pocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10113054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return eg:GetCount()==1 and ec:GetSummonPlayer()~=tp and ec:IsFaceup() and ec:IsType(TYPE_TUNER) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c10113054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,ec=e:GetHandler(),eg:GetFirst()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)~=0 and ec:IsRelateToEffect(e) then
	   Duel.SendtoDeck(ec,nil,1,REASON_EFFECT)
	end
end
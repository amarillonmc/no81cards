--CX S・H・Dark Knight - LIMBO RETURNER
function c82574567.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--SHDark summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82574567,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,82574567)
	e1:SetTarget(c82574567.sptg)
	e1:SetOperation(c82574567.operation)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82574567,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,82574568)
	e4:SetCondition(c82574567.spcon)
	e4:SetTarget(c82574567.sptg2)
	e4:SetOperation(c82574567.spop)
	c:RegisterEffect(e4)
end
function c82574567.spfilter(c,e,tp)
	return c:IsCode(12744567) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c82574567.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c82574567.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82574567.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82574567.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
	Duel.SetChainLimit(c82574567.chlimit)
end
function c82574567.chlimit(e,ep,tp)
	return tp==ep
end
function c82574567.negfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c82574567.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) 
		  and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
			Duel.BreakEffect()
				Duel.Recover(tp,800,REASON_EFFECT)
				if Duel.IsExistingMatchingCard(c82574567.negfilter,tp,0,LOCATION_MZONE,1,nil) and
				Duel.SelectYesNo(tp,aux.Stringid(82574567,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
				local g=Duel.SelectMatchingCard(tp,c82574567.negfilter,tp,0,LOCATION_MZONE,1,1,nil)
				if g:GetCount()>0 then
				local bc=g:GetFirst()
				local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		bc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		bc:RegisterEffect(e3)
				end
			end
		end
	end
end
function c82574567.shdarkfilter(c)
	return c:IsCode(12744567) 
end
function c82574567.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetTurnPlayer()==e:GetHandler():GetControler() and 
	   Duel.IsExistingMatchingCard(c82574567.shdarkfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil) 
end
function c82574567.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	   and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c82574567.spop(e,tp,eg,ep,ev,re,r,rp)
   if e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsRelateToEffect(e) then
   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
end
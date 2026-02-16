local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--material cannot be removed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(s.mattg)
	c:RegisterEffect(e1)
	--cannot remove hand/deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK)
	c:RegisterEffect(e2)
	--check remove reason
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.checkop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.mattg(e,c)
	return c:GetReasonCard()==e:GetHandler() and c:IsType(TYPE_MONSTER)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_REMOVED) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and not (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_REMOVED,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,c,e,tp)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and tc:IsRelateToChain()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g=Group.FromCards(c,tc)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			for sc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CANNOT_REMOVE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
			end
		end
	end
end
--晴空光行·庭园蝶语
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetType()==TYPE_CONTINUOUS+TYPE_SPELL
	end)
	c:RegisterEffect(e0)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1118)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetType()==TYPE_CONTINUOUS+TYPE_SPELL
	end)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.recon)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5A76) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:GetType()==TYPE_SPELL then 
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if c:IsRelateToEffect(e) and e:GetLabel()==1 then
		Duel.BreakEffect()
		c:CancelToGrave()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
		c:SetCardData(CARDDATA_TYPE,TYPE_SPELL+TYPE_CONTINUOUS)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(s.chop)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffect(id)~=0 then return end
	c:ResetFlagEffect(id)
	c:SetCardData(CARDDATA_TYPE,TYPE_SPELL)
	e:Reset()
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
  return re and re:GetHandler() and aux.GetValueType(re:GetHandler())=="Card" and e:GetHandler():IsFaceup() and eg:IsExists(s.repfilter,1,nil,re) and e:GetHandler():GetType()==TYPE_CONTINUOUS+TYPE_SPELL
end
function s.repfilter(c,re)
	if not (c:IsLocation(LOCATION_REMOVED) and c:IsFaceupEx()) then return false end
	if c:IsReason(REASON_REDIRECT) and c:GetFlagEffect(id)>0 then 
		return true
	else
  	return re:GetHandler():IsSetCard(0x5A76) and c:IsReason(REASON_EFFECT) 
	end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.repfilter,nil,re)
	if #g>0 then
		for tc in aux.Next(g) do
		 	if tc:GetFlagEffect(id)>0 then
				tc:ResetFlagEffect(id)
			end
		end
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end

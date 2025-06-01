--炯眼黑巨灵
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_RELEASE)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(custom_code)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetLabelObject(e0)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
function s.spcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsPreviousControler(tp) and bit.band(c:GetPreviousRaceOnField(),RACE_WYRM)~=0 and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_FIRE)~=0 and (se==nil or c:GetReasonEffect()~=se)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local f=not eg:IsContains(e:GetHandler()) and eg:IsExists(s.spcfilter,1,nil,tp)
	if f then 
		if eg:IsExists(Card.IsSetCard,1,nil,0xc30) then e:SetLabel(1) else e:SetLabel(0) end
	end
	return f
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and e:GetLabel()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(4)
		c:RegisterEffect(e1)
	end
end
function s.rmtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceupEx()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.rmtfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gt=Duel.GetMatchingGroupCount(s.rmtfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if gt<=0 then return end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct>gt then ct=gt end
	if ct>1 then
		local tbl={}
		for i=1,ct do
			table.insert(tbl,i)
		end
		ct=Duel.AnnounceNumber(tp,table.unpack(tbl))
	end
	Duel.ConfirmDecktop(1-tp,ct)
	Duel.SortDecktop(tp,1-tp,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(ct*200)
	c:RegisterEffect(e1)
end

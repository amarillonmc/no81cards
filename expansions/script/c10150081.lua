--希望龙
function c10150081.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10150081,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,10150081)
	e1:SetTarget(c10150081.sptg)
	e1:SetOperation(c10150081.spop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--name change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10150081,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10150181)
	e3:SetTarget(c10150081.nametg)
	e3:SetOperation(c10150081.nameop)
	c:RegisterEffect(e3)
end
function c10150081.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local code=e:GetHandler():GetCode()
	--c:IsSetCard(0x51) and not c:IsCode(code)
	c10150081.announce_filter={0xc2,OPCODE_ISSETCARD,TYPE_SYNCHRO,OPCODE_ISTYPE,OPCODE_AND,RACE_DRAGON,OPCODE_ISRACE,TYPE_SYNCHRO,OPCODE_ISTYPE,OPCODE_AND,OPCODE_OR}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c10150081.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
end
function c10150081.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tk=Duel.CreateToken(tp,ac)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if c:IsImmuneToEffect(e1) then return end
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and c:IsLevelAbove(0) and c:GetLevel()~=tk:GetLevel() and Duel.SelectYesNo(tp,aux.Stringid(10150081,2)) then
		   Duel.BreakEffect()
		   if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil,REASON_EFFECT)~=0 then
			  local e2=Effect.CreateEffect(c)
			  e2:SetType(EFFECT_TYPE_SINGLE)
			  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e2:SetCode(EFFECT_CHANGE_LEVEL)
			  e2:SetValue(tk:GetLevel())
			  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			  c:RegisterEffect(e2)
		   end
		end
	end
end
function c10150081.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_TUNER) and c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10150081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10150081.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10150081.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10150081.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

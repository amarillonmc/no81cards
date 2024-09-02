--幻想乡 八意永琳
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	--local e0=Effect.CreateEffect(c)
	--e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e0:SetType(EFFECT_TYPE_SINGLE)
	--e0:SetCode(EFFECT_ADD_RACE)
	--e0:SetValue(RACE_WARRIOR)
	--c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--s.deckdes(c)
	if not s.global_flag then
		s.global_flag=true
		--remove
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(s.target)
		ge1:SetValue(s.val)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.deckdes(c)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+1)
	e5:SetTarget(s.ddtg)
	e5:SetOperation(s.ddop)
	c:RegisterEffect(e5)
end
s.overlay_redirect_todeck=true
function s.target(e,c)
	return c.overlay_redirect_todeck==true
end
function s.val(e,c)
	if c:IsReason(REASON_RULE) then return false end
	return LOCATION_DECKSHF
end

function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x861) and c:IsType(TYPE_MONSTER)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x863) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardDeck(tp,5,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local sg=og:Filter(aux.NecroValleyFilter(s.spfilter),nil,e,tp)
	if #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.SelectYesNo(tp,aux.Stringid(1621413,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
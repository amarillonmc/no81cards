--蛋类料理食材
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return c:IsSetCard(0x9221)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x9221)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9221) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9221))
	e2:SetValue(s.indct)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0x9221) and tc:IsFaceup() then
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(TIMINGS_CHECK_MONSTER,TIMINGS_CHECK_MONSTER)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetCost(s.spcost)
			e1:SetTarget(s.sptg)
			e1:SetOperation(s.spop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			tc:RegisterEffect(e1)
		end
	end
end
function s.spcfilter2(c,e,tp)
	return c:IsSetCard(0x9221) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup() and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spfilter2(c,e,tp,v)
	local t=Auxiliary.GetValueType(v)
	local lv=0
	local tc=nil
	if t=='Card' then 
		lv=v:GetLevel()
		tc=v
	else lv=v end
	return c:IsSetCard(0x9221) and c:IsLevel(lv) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.spcfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	e:SetLabel(0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,s.spcfilter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp):GetFirst()
	e:SetLabel(tc:GetLevel())
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if not lv then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
	if not sc then return end
	Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
end
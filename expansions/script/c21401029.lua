--禁冠之魔女
local s,id=GetID()
local SET_FORBIDDEN=0x11d
local CARD_FORBIDDEN_CROWN=98829635

function s.initial_effect(c)
	-- Link Summon: 2+ monsters with different names
	aux.AddLinkProcedure(c,nil,2,nil,s.lcheck)
	c:EnableReviveLimit()

	-- ① End Phase: Set 1 "Forbidden Crown" from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg1)
	e1:SetOperation(s.setop1)
	c:RegisterEffect(e1)

	-- ② When this card leaves the field: Set 1 "Forbidden" Quick-Play Spell from your GY/banished
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.settg2)
	e2:SetOperation(s.setop2)
	c:RegisterEffect(e2)

	-- ③ In GY: banish 1 "Forbidden" Quick-Play Spell from your GY; Special Summon this card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

-- Link material check: different names
function s.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

-- main S/T zone only (exclude Field Zone)
function s.stmainfilter(c)
	return c:GetSequence()<5
end
function s.hasmainstzone(tp)
	return Duel.GetMatchingGroupCount(s.stmainfilter,tp,LOCATION_SZONE,0,nil)<5
end

-- ① filters & functions
function s.crownfilter(c)
	return c:IsCode(CARD_FORBIDDEN_CROWN) and c:IsSSetable()
end
function s.settg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s.hasmainstzone(tp)
			and Duel.IsExistingMatchingCard(s.crownfilter,tp,LOCATION_DECK,0,1,nil)
	end
end
function s.setop1(e,tp,eg,ep,ev,re,r,rp)
	if not s.hasmainstzone(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.crownfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end

-- ② / ③ filters
function s.fqsetfilter(c)
	return c:IsSetCard(SET_FORBIDDEN) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function s.fqcostfilter(c)
	return c:IsSetCard(SET_FORBIDDEN) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemoveAsCost()
end

-- ②
function s.settg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and s.fqsetfilter(chkc)
	end
	if chk==0 then
		return s.hasmainstzone(tp)
			and Duel.IsExistingTarget(aux.NecroValleyFilter(s.fqsetfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SelectTarget(tp,aux.NecroValleyFilter(s.fqsetfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function s.setop2(e,tp,eg,ep,ev,re,r,rp)
	if not s.hasmainstzone(tp) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end

-- ③
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.fqcostfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.fqcostfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_EXTRA)
		c:RegisterEffect(e1,true)
	end
end

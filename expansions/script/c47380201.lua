-- SymBIOSis深网巡卫 克蕾娜
local s,id=GetID()
function s.initial_effect(c)
	s.spsummon(c)
    s.eff2(c)
    s.ontograve(c)
end
function s.spsummon(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToDeckAsCost()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
end
function s.eff2(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.con2)
    c:RegisterEffect(e2)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.GetFlagEffect(tp,id)==0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.negcon)
    e1:SetOperation(s.negop)
	Duel.RegisterEffect(e1,tp)
    Duel.Hint(HINT_CARD,0,id)
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.negfilter(c)
    return c:IsType(TYPE_XYZ) and c:IsRace(RACE_CYBERSE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.thfilter(c)
    return c:IsSetCard(0xcc16) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==ep and eg:IsExists(s.negfilter,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and eg:FilterCount(Card.IsStatus,nil,STATUS_SUMMONING)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_CARD,0,id)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        Duel.NegateSummon(eg)
        Duel.Destroy(eg,REASON_EFFECT)
		Duel.BreakEffect()
    end
end
function s.ontograve(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ogcon)
	e1:SetTarget(s.ogtg)
	e1:SetOperation(s.ogop)
	c:RegisterEffect(e1)
end
function s.ogcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK) and Duel.GetFlagEffect(tp,id-1000)==0
end
function s.tgfilter(c)
    return c:IsSetCard(0xcc16) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tdfilter(c)
    return c:IsRace(RACE_CYBERSE) and c:IsAbleToDeck()
end
function s.ogtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.ogop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,id-1000)~=0 then return end
    Duel.RegisterFlagEffect(tp,id-1000,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #dg>0 then
			Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
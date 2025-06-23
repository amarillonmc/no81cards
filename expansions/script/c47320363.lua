-- 红英招来
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301,47320352)
	s.activate(c)
	s.banish_effect(c)
end
function s.activate(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,check,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsCode(47320352) or aux.IsCodeListed(c,47320352)) and (c:IsAbleToGrave() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.spfilter(c,e,tp)
	return c:IsCode(47320352) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
        local ck1=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,47320352) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,ck1,e,tp)
    end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local check=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,47320352)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,check,e,tp)
	local tc=g:GetFirst()
	local ct=0
	if tc then
		if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1191,1152)==1) then
			ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			ct=Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	if ct~=0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not aux.IsCodeListed(c,47320301)
end

function s.banish_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id-1000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
end

function s.refilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsCode(47320352) or aux.IsCodeListed(c,47320301)) and c:IsFaceup()
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.refilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.refilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if #g>0 then
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
    end
end

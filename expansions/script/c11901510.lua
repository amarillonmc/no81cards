--罗星 爱斯基摩星云
local s,id,o=GetID()
function s.initial_effect(c)
    --Set Card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x06)
    e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
    e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.cicon)
	e2:SetTarget(s.citg)
	e2:SetOperation(s.ciop)
	c:RegisterEffect(e2)
end
function s.rmfilter(c,tp)
    return c:IsSetCard(0x409) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
        and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function s.thfilter(c,lv)
    return c:IsSetCard(0x409) and c:GetLevel()<lv and c:IsAbleToHand()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,0x01,0,1,1,nil,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
        local lv=tc:GetLevel()
		if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 or not tc:IsLocation(0x20) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,0x40)
            Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.fi1ter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsControlerCanBeChanged() and c:IsLocation(0x04)
end
function s.fi2ter(c,e,tp)
	return c:IsRelateToEffect(e) and s.fi1ter(c,tp)
end
function s.cicon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        or not re:GetHandler():IsSetCard(0x409) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.fi1ter,1,e:GetHandler(),tp)
        and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.citg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.fi1ter,e:GetHandler(),tp)
	local tc=tg:GetFirst()
    while tc do
	    tc:CreateEffectRelation(e)
        tc=tg:GetNext()
    end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler()
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.fi2ter,c,e,tp)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then 
		Duel.Hint(3,tp,520)
        local sg=tg:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local tc=sg:GetFirst()
        Duel.GetControl(tc,tp)
	end 
end
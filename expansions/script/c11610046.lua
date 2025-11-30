--闪耀的奇迹之草场

--光角幻兔卡号
local key=25795273
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,25795273)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.dktohtg)
	e1:SetOperation(s.dktohop)
	c:RegisterEffect(e1)	
		--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.hgsptg)
	e2:SetOperation(s.hgspop)
	c:RegisterEffect(e2)	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.discon)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end

function s.tohfilter(c)
    return aux.IsCodeListed(c,25795273) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.dktohtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.dktohop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tohg=Duel.SelectMatchingCard(tp,s.tohfilter,tp,LOCATION_DECK,0,1,1,nil)
    if not (tohg:GetCount()>0) then return end
    Duel.SendtoHand(tohg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tohg)
end

function s.hgspfilter(c,e,tp)
    return c:IsCode(25795273) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.hgsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.hgspfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function s.hgspop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local spg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.hgspfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if not (spg:GetCount()>0) then return end
    Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():GetAttack()==0
		and re:GetHandler():IsLocation(LOCATION_MZONE)
		and e:GetHandler():GetFlagEffect(id)<=0
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then	
	    Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end

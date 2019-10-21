local cid=c98745671
local id=98745671
function cid.initial_effect(c)
	--Self-Special Summon from Hand (0)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id)
	e0:SetCondition(cid.spcon)
	e0:SetTarget(cid.sptg)
	e0:SetOperation(cid.spop)
	c:RegisterEffect(e0)
	--Search "Red Dragon Archfiend" Listed Spell/Traps (0)
	--cid.card_code_list={70902743}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(2,id)
	e1:SetTarget(cid.rdatg)
	e1:SetOperation(cid.rdaop)
	c:RegisterEffect(e1)
end

--Filters
function cid.rdafilter(c)
	return c:IsCode(50215517) and c:IsAbleToHand()
	or c:IsCode(87614611) and c:IsAbleToHand()
	or c:IsCode(02542230) and c:IsAbleToHand()
	or c:IsCode(02542230) and c:IsAbleToHand()
	or c:IsCode(18634367) and c:IsAbleToHand()
	or c:IsCode(60433216) and c:IsAbleToHand()
	or c:IsCode(24566654) and c:IsAbleToHand()
	or c:IsCode(98745673) and c:IsAbleToHand()
end

--Self-Special Summon from Hand (0)
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end

function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Search "Red Dragon Archfiend" Listed Spell/Traps (1)
function cid.rdatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.rdafilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cid.rdaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.rdafilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
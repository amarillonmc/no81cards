-- 新昼地的近侍 达芙妮尔
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301)
	s.sprule(c)
	s.move_effect(c)
	s.tohand_and_deck(c)
end

function s.sprule(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5c17) or aux.IsCodeListed(c,47320301))
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function s.move_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id-1000)
	e2:SetCondition(s.seqcon)
	e2:SetTarget(s.seqtg)
	e2:SetOperation(s.seqop)
	c:RegisterEffect(e2)
end
function s.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.seqfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5c17) or aux.IsCodeListed(c,47320301))
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	Duel.SelectTarget(tp,s.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(zone,2)
	Duel.MoveSequence(tc,nseq)
end

function s.tohand_and_deck(c)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,3))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,id-2000)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(s.tdtg)
    e3:SetOperation(s.tdop)
    c:RegisterEffect(e3)
end
function s.thfilter3(c)
    return c:IsSetCard(0x5c17) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.thfilter3(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.thfilter3,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToHand() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.thfilter3,tp,LOCATION_GRAVE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
    end
end

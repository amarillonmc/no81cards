-- 新昼地的袭击
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301,47320352)
	s.activate(c)
	s.move_effect(c)
end

function s.activate(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
    e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return (aux.IsCodeListed(c,47320301) or aux.IsCodeListed(c,47320352)) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.spfilter(c,e,tp,p)
    return c:IsCode(47320352) and c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_DEFENSE,p)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
    local ck1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,tp)
    local ck2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,1-tp)
    if chk==0 then return #g>0 and (ck1 or ck2) end
    local flag=0
    for tc in aux.Next(g) do
        local seq=tc:GetSequence()
        local lm=0
        if seq<5 then
            if tc:IsControler(1-tp) then
                lm=lm+16
            end
            flag=flag|(1<<(lm+seq))
        end
    end
    if not ck1 then
        flag=flag&0xffff0000
    end
    if not ck2 then
        flag=flag&0xffff
    end
    local zone=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0xffffffff-flag,47320352)
    e:SetLabel(zone)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local zone=e:GetLabel()
    local p=tp
    if zone>=(1<<16) then
		p=1-tp
		zone=zone>>16
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,p)
    if #g>0 then
        local seq=math.log(zone,2)
        local pc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
        if pc then
            Duel.Destroy(pc,REASON_RULE)
        end
        Duel.SpecialSummon(g,0,tp,p,false,true,POS_FACEUP_DEFENSE,zone)
    end
end

function s.move_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id-1000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.seqtg)
	e2:SetOperation(s.seqop)
	c:RegisterEffect(e2)
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

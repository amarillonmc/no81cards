--罗星姬 造父四
local s,id,o=GetID()
function s.initial_effect(c)
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --SynSum
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
    e2:SetTarget(s.sctg)
	e2:SetOperation(s.scop)
	c:RegisterEffect(e2)
end
function s.cfi1ter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsSetCard(0x409)
end
function s.cfi2ter(c)
	return c:IsFaceup() and c:IsSetCard(0x409)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(0x0c) and s.cfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.cfi1ter,tp,0x0c,0x0c,1,nil)
        and Duel.IsExistingMatchingCard(s.cfi2ter,tp,0x08,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.cfi1ter,tp,0x0c,0x0c,1,2,nil)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local cg=Group.CreateGroup()
        local val=0
        local tc=g:GetFirst()
        while tc do
            if tc:IsFaceup() then
                val=val+200
            elseif tc:IsFacedown() then
                cg:AddCard(tc)
            end
            tc=g:GetNext()
        end
        if val>0 then Duel.Damage(1-tp,val,REASON_EFFECT) end
        if #cg>0 then
            Duel.ConfirmCards(tp,cg)
        end
	end
end
function s.synfi1ter(c)
    return c:IsSynchroSummonable(nil) and c:IsSetCard(0x409)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.synfi1ter,tp,0x40,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.synfi1ter,tp,0x40,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
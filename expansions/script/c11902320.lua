--飓风海劫“回声”海豚号
local s,id,o=GetID()
function s.initial_effect(c)
    --RetCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
    --CheckCard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.scon)
	e3:SetTarget(s.stg)
	e3:SetOperation(s.sop)
	c:RegisterEffect(e3)
end
function s.thfilter(c,tid)
	return c:IsRace(RACE_AQUA) and c:IsType(TYPE_MONSTER)
        and c:IsAbleToHand() and c:GetTurnID()==tid
end
function s.spfi1ter(c,e,tp)
    return c:IsSetCard(0x540b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,0x04)>0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,0x10,0,1,nil,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,0x10,0,1,1,nil,Duel.GetTurnCount())
	if #g>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        if Duel.SendtoHand(tc,nil,0x40)>0 and s.spfi1ter(tc,e,tp) then
            if c:IsRelateToEffect(e) and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
                    Duel.SendtoHand(c,nil,0x40)
                end
            end
        end
	end
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,0x0e)>0 end
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,0x0e,nil)
	if #dg>0 then Duel.ConfirmCards(tp,dg) end
    local g=Duel.GetFieldGroup(tp,0,0x0e)
    if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and g:IsExists(Card.IsType,1,nil,TYPE_SPELL) and g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
        if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
            Duel.Draw(tp,1,0x40)
        end
    end
    Duel.ShuffleHand(1-tp)
end
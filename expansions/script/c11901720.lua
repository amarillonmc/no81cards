--炎魔的赤眼 安洛先
local s,id,o=GetID()
function s.initial_effect(c)
    --DesCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.dstg)
	e1:SetOperation(s.dsop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    --Desed
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
    e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.tgfilter(c,e)
	return c:IsSetCard(0x408) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsDestructable(e)
       and not (c:IsLocation(0x0c) and c:IsFacedown())
end
function s.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingMatchingCard(s.tgfilter,tp,0x0e,0,1,e:GetHandler(),e) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x0e)
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0x0e,0,1,1,e:GetHandler(),e)
	if g:GetCount()>0 then
        if g:GetFirst():IsLocation(0x0c) then Duel.HintSelection(g) end
		if Duel.Destroy(g,REASON_EFFECT)>0 then
            Duel.Draw(tp,1,0x40)
        end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x408) and c:IsLevelAbove(2) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,0x10,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,0x10,0,1,1,nil)
	if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
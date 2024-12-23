--幻龙兽 科思多
local s,id,o=GetID()
function s.initial_effect(c)
    --Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
    --ToHand(0x30)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function(e) 
	    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
    --DownAtk(0x04)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.recon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_TO_GRAVE)
    c:RegisterEffect(e3)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
        local c=e:GetHandler()
        local mg=c:GetMaterial():Filter(aux.NecroValleyFilter(s.mgfilter),nil,tp,c)
        return #mg>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0x30,1,0,0)
end
function s.mgfilter(c,tp,sync)
	return c:IsControler(tp) and c:IsLocation(0x30)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(aux.NecroValleyFilter(s.mgfilter),nil,tp,c)
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and #mg>0 then
        Duel.Hint(3,tp,506)
        local sg=mg:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
		Duel.SendtoHand(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return re and bit.band(r,REASON_EFFECT)==REASON_EFFECT
        and re:GetHandler():IsSetCard(0x40a)
end
function s.cfi1ter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.desfi1ter(c)
	return c:IsFaceup() and c:GetAttack()==0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfi1ter,tp,0,0x04,1,nil) end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.cfi1ter,tp,0,0x04,nil)
	if #g>0 then
        for tc in aux.Next(g) do
            local e1=Effect.CreateEffect(c)
	        e1:SetType(EFFECT_TYPE_SINGLE)
	        e1:SetCode(EFFECT_UPDATE_ATTACK)
	        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	        e1:SetValue(-2000)
	        tc:RegisterEffect(e1)
        end
        local dg=Duel.GetMatchingGroup(s.desfi1ter,tp,0,0x04,nil)
        if #dg>0 then
            Duel.BreakEffect()
            Duel.Destroy(dg,0x40)
        end
    end
end
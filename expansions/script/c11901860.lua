--幻龙兽“歌姬”大蛇
local s,id,o=GetID()
function s.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,nil,8,2)  
	c:EnableReviveLimit()
    --extra atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EXTRA_ATTACK)
	e0:SetValue(1)
	c:RegisterEffect(e0)
    --Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetCondition(function(e) 
	    local ph=Duel.GetCurrentPhase()
	    return ph<PHASE_BATTLE_START or ph>PHASE_BATTLE end)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
    --Tograve(0x0e)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCountLimit(1)
    e2:SetCondition(function(e)
	    local c=e:GetHandler()
	    return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) end)
    e2:SetTarget(s.tgtg1)
	e2:SetOperation(s.tgop1)
	c:RegisterEffect(e2)
    --BattleStart
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
    e3:SetTarget(s.tgtg2)
	e3:SetOperation(s.tgop2)
	c:RegisterEffect(e3)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,0x0e,nil)>0 end
end
function s.tgop1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0e,nil)
    if #g>0 then
        Duel.Hint(3,tp,504)
        local sg=g:Select(1-tp,1,1,nil)
        Duel.SendtoGrave(sg,0x400)
    end
end
function s.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0e,nil)
        return e:GetHandler():GetOverlayCount()>0 and #g>0
    end
end
function s.tgop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,0x40) then
        local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0e,nil)
       	if #g>0 then
            Duel.Hint(3,tp,504)
            local sg=g:Select(1-tp,1,1,nil)
            Duel.SendtoGrave(sg,0x400)
        end
	end
end
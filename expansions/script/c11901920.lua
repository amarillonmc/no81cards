--幻龙兽“龙姬”弗栗多
local s,id,o=GetID()
function s.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),8,2,nil,nil,99)  
	c:EnableReviveLimit()
    --Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
    --Tograve(0x0e)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetTarget(s.imtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
    --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.imcon)
	e3:SetTarget(s.imtg)
	e3:SetOperation(s.imop)
	c:RegisterEffect(e3)
end
function s.efilter(e,te)
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return te:GetOwner()~=e:GetOwner() and (not g or not g:IsContains(e:GetHandler()))
end
function s.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c)
end
function s.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
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
function s.imop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,0x40) then
        local e1=Effect.CreateEffect(c) 
    	e1:SetType(EFFECT_TYPE_SINGLE) 
	    e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	    e1:SetRange(LOCATION_MZONE) 
	    e1:SetValue(function(e,re) 
	        return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() end) 
	    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
	    c:RegisterEffect(e1,true)
        local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0e,nil)
       	if #g>0 then
            Duel.BreakEffect()
            Duel.Hint(3,tp,504)
            local sg=g:Select(1-tp,1,1,nil)
            Duel.SendtoGrave(sg,0x400)
        end
	end
end
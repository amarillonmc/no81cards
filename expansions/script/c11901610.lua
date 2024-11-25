--炎魔的迷光 鬼火
local s,id,o=GetID()
function s.initial_effect(c)
    --SpSummon To SZone
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,id)
	e1:SetCost(s.htgcost)
	e1:SetTarget(s.htgtg) 
	e1:SetOperation(s.htgop) 
	c:RegisterEffect(e1)
    --Desed
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.dsop)
	c:RegisterEffect(e2)
end
function s.htgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.defi1ter(c,e)
	return c:IsSetCard(0x408) and c:IsDestructable(e) and not c:IsCode(id)
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(s.defi1ter,tp,0x01,0,c,e)
        return #g>0
    end
end
function s.htgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.defi1ter,tp,0x01,0,c,e)
    if c:IsRelateToEffect(e) and #g>0 then
        Duel.Hint(3,tp,502)
        local sg=g:Select(tp,1,1,nil)
        sg:AddCard(c)
        Duel.Destroy(sg,0x40)
	end
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler()) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1) 
	e1:SetReset(RESET_PHASE+PHASE_END)  
	e1:SetOperation(s.xdesop)  
	Duel.RegisterEffect(e1,tp)
end
function s.xdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,0x0e,0) 
    Duel.Hint(HINT_CARD,0,id) 
    if #g>0 then
        Duel.Hint(3,tp,502)
        local sg=g:Select(tp,1,1,nil)
        if sg:GetFirst():IsLocation(0x0c) then Duel.HintSelection(sg) end
		Duel.Destroy(sg,REASON_EFFECT)  
	end 
end
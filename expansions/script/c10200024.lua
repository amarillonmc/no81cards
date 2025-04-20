-- 棉花糖与棉花球
function c10200024.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetTarget(c10200024.tg1)
	e1:SetOperation(c10200024.op1)
	c:RegisterEffect(e1)
end
function c10200024.filter1(sg)
    return sg:GetClassCount(function(c) return c:GetCode() end)==1 and sg:GetClassCount(function(c) return c:GetOriginalCode() end)==2
end
function c10200024.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
        return Duel.IsPlayerCanDraw(tp,2)
            and g:CheckSubGroup(function(sg)
                return sg:GetClassCount(function(c) return c:GetCode() end)==1
                    and sg:GetClassCount(function(c) return c:GetOriginalCode() end)==2
            end,2,2)
    end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c10200024.op1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local sg=g:SelectSubGroup(tp,c10200024.filter1,false,2,2)
    if sg and sg:GetCount()==2 then
        Duel.ConfirmCards(1-tp,sg)
        Duel.BreakEffect()
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
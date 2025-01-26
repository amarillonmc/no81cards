--生命的盛宴
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(function(e)
        return Duel.GetCurrentChain()>=3 end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    e:SetLabel(Duel.GetCurrentChain())
end
function s.sumfilter(c,e,tp)
    return c:IsCode(11900202) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        local cv=e:GetLabel()
        if cv>=6 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) and Duel.Draw(tp,1,0x40)>0 then
            local g=Duel.GetMatchingGroup(s.sumfilter,tp,0x3,0,nil,e,tp)
            local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x2,0,nil)
            if cv>=8 and #g>0 and #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                Duel.ShuffleHand(tp)
                Duel.Hint(3,tp,507)
                local dg=hg:Select(tp,1,1,nil)
                if Duel.SendtoDeck(dg,nil,2,0x40)>0 then
                    Duel.Hint(3,tp,509)
                    local sg=g:Select(tp,1,1,nil)
                    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end
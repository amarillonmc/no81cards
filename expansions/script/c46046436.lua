--燃灼齿机 驱动加速
local s,id,o=GetID()
function s.initial_effect(c)
	--丢弃1张手卡，这张卡发动的回合的以下效果适用。这张卡的发动后，直到回合结束时自己不是机械族·炎属性怪兽不能特殊召唤。
    --●自己回合：自己额外卡组1只「燃灼齿机」同调怪兽给对方确认，等级合计直到和那个等级相同为止从卡组把最多2只「燃灼齿机」怪兽加入手卡。
    --●对方回合：自己场上·墓地1只「燃灼齿机」同调怪兽给对方确认，等级合计直到和那个等级相同为止从墓地把最多2只机械族·炎属性怪兽特殊召唤。
    --「直播☆双子入口页」「惊奇时段通行证」「骷髅指挥」
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.cffilter(c,g,ft)
    return c:IsSetCard(0x6f0) and c:IsType(TYPE_SYNCHRO)
        and #g>0 and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function s.thfilter(c)
    return c:IsSetCard(0x6f0) and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetTurnPlayer()==tp then
        if chk==0 then
        local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(s.cffilter,tp,LOCATION_EXTRA,0,1,nil,g,2) end
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) --「骷髅指挥」
	else
        if chk==0 then
        local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
        local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return Duel.IsExistingMatchingCard(s.cffilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,g,ft) end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) --「骷髅指挥」
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
        local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=Duel.SelectMatchingCard(tp,s.cffilter,tp,LOCATION_EXTRA,0,1,1,nil,g,2):GetFirst()
		if tc then
            Duel.ConfirmCards(1-tp,tc)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,2)
            if sg and #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
            end
		end
	else
		local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	    if ft<=0 then return end
	    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=Duel.SelectMatchingCard(tp,s.cffilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,g,ft):GetFirst()
	    if tc then
            if tc:IsLocation(LOCATION_MZONE) then Duel.HintSelection(Group.FromCards(tc)) end
            Duel.ConfirmCards(1-tp,tc)
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		    local sg=g:SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,ft)
            if sg and #sg>0 then
		    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            end
	    end
	end
    if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end --「直播☆双子入口页」
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE) or not c:IsRace(RACE_MACHINE)
end
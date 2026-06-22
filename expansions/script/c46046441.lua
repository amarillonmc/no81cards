--燃灼齿机 驱动制霸
local s,id,o=GetID()
function s.initial_effect(c)
	--以自己场上·墓地1只机械族·炎属性怪兽为对象才能发动。这张卡发动的回合的以下效果适用。这张卡的发动后，直到回合结束时自己不是炎属性·机械族怪兽不能特殊召唤。
    --武神姬-天照
        --●自己回合：作为对象的怪兽回到手卡。那之后，可以从手卡把1只「燃灼齿机」怪兽特殊召唤。
        --「圣夜骑士团·弗拉梅尔」「惊乐特别秀」「不死之腐食鸟」
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
        --●对方回合：选持有作为对象的怪兽的原本攻击力以下的攻击力的对方场上1只怪兽的效果无效。那之后，可以把那只对方的怪兽送去墓地。
        --「治安战警队 正名者」「魁炎星-羊武」「神手粉碎拳」「直播☆双子入口页」「龙仪巧-天龙流星DAD」「同调破解」
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.thfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE)
		and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x6f0)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and chkc:IsControler(tp) and s.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,tp)
    end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
            local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
            if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                Duel.BreakEffect()
			    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			    local sg=g:Select(tp,1,1,nil)
			    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            end
        end
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.tgfilter(c,tp)
    --「龙仪巧-天龙流星DAD」「同调破解」
    local atk=0
    if c:IsLocation(LOCATION_MZONE) then
		atk=c:GetBaseAttack()
	else
		atk=math.max(0,c:GetTextAttack())
	end
    --
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE)
        and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
        and Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_MZONE,1,nil,atk)
end
function s.disfilter(c,atk)
    return c:IsAttackBelow(atk)
        and aux.NegateEffectMonsterFilter(c)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then --「魁炎星-羊武」
        -- --「龙仪巧-天龙流星DAD」「同调破解」
        local atk=0
        if tc:IsLocation(LOCATION_MZONE) then
		    atk=tc:GetBaseAttack()
	    else
		    atk=math.max(0,tc:GetTextAttack())
	    end
        --
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
        local dc=Duel.SelectMatchingCard(tp,s.disfilter,tp,0,LOCATION_MZONE,1,1,nil,atk):GetFirst() --「神手粉碎拳」
        if dc then
		    local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_DISABLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		    dc:RegisterEffect(e1)
		    local e2=Effect.CreateEffect(c)
		    e2:SetType(EFFECT_TYPE_SINGLE)
		    e2:SetCode(EFFECT_DISABLE_EFFECT)
		    e2:SetValue(RESET_TURN_SET)
		    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		    dc:RegisterEffect(e2)
            Duel.NegateRelatedChain(dc,RESET_TURN_SET)
		    Duel.AdjustInstantly()
		    if dc:IsDisabled() and dc:IsControler(1-tp)
                and dc:IsAbleToGrave()
                and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
		    	Duel.SendtoGrave(dc,REASON_EFFECT)
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
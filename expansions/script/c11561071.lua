--征服斗魂 狂龙烬灭
local m=11561071
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--damage（合并）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561071,4))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c11561071.damcon)
	e2:SetCost(c11561071.damcost)
	e2:SetTarget(c11561071.damtg)
	e2:SetOperation(c11561071.damop)
	c:RegisterEffect(e2)
end

function c11561071.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,nil,1,LOCATION_MZONE)
end

function c11561071.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    -- 检查后续效果是否可用的标志
    local can_dark = Duel.GetFlagEffect(tp,21513082)==0
        and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11561071.TTFfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
    local can_earth = Duel.GetFlagEffect(tp,31513082)==0
        and Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
    local can_fire = Duel.GetFlagEffect(tp,41513082)==0
        and Duel.IsExistingMatchingCard(c11561071.spfil,tp,LOCATION_HAND,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0

    -- 收集手卡中“属性对应效果可用”的卡
    local g=Group.CreateGroup()
    if can_dark then
        g:Merge(Duel.GetMatchingGroup(c11561071.gkfilteran,tp,LOCATION_HAND,0,nil))
    end
    if can_earth then
        g:Merge(Duel.GetMatchingGroup(c11561071.gkfilterdi,tp,LOCATION_HAND,0,nil))
    end
    if can_fire then
        g:Merge(Duel.GetMatchingGroup(c11561071.gkfilteryan,tp,LOCATION_HAND,0,nil))
    end

    -- 发动前检查
    if chk==0 then
        local can_direct = c:GetFlagEffect(51513082)==0
        return can_direct or #g>0
    end

    -- 决定是否展示发动
    local show = false
    local can_direct = c:GetFlagEffect(51513082)==0
    if can_direct and #g>0 then
        show = Duel.SelectYesNo(tp,aux.Stringid(11561071,5))
    elseif #g>0 then
        show = true
    elseif can_direct then
        show = false
    end

    if show then
        -- 选择一张可用的手卡展示
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg=Duel.SelectMatchingCard(tp,c11561071.allfilter,tp,LOCATION_HAND,0,1,1,nil,g)
        local tc=sg:GetFirst()
        Duel.ConfirmCards(1-tp,sg)
        Duel.ShuffleHand(tp)
        e:SetLabelObject(tc)
        e:SetLabel(1)  -- 展示发动
    else
        e:SetLabelObject(nil)
        e:SetLabel(0)  -- 直接发动
    end
end
function c11561071.allfilter(c,g)
    return g:IsContains(c)
end
function c11561071.gkfilteran(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c11561071.gkfilterdi(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic()
end
function c11561071.gkfilteryan(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsPublic()
end

function c11561071.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(51513082,RESET_CHAIN,0,1) 
	local sel=e:GetLabel()
	local tc=e:GetLabelObject()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
	if sel==1 and tc then
		if tc:IsAttribute(ATTRIBUTE_DARK) then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
		elseif tc:IsAttribute(ATTRIBUTE_EARTH) then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		elseif tc:IsAttribute(ATTRIBUTE_FIRE) then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		end
	end
end

function c11561071.TTFfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c11561071.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x195)
end

function c11561071.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local sel=e:GetLabel()
	local tc=e:GetLabelObject()

	if Duel.Damage(p,d,REASON_EFFECT)~=0 and sel==1 and tc then
		if tc:IsAttribute(ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c11561071.TTFfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,21513082)==0 then
			Duel.RegisterFlagEffect(tp,21513082,RESET_PHASE+PHASE_END,0,1)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11561071.TTFfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
			if #sg>0 then
				Duel.HintSelection(sg)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		end
		if tc:IsAttribute(ATTRIBUTE_EARTH) and Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.GetFlagEffect(tp,31513082)==0 then
			Duel.RegisterFlagEffect(tp,31513082,RESET_PHASE+PHASE_END,0,1)
			local sc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil):GetFirst()
			Duel.LinkSummon(tp,sc,nil)
		end
		if tc:IsAttribute(ATTRIBUTE_FIRE) and Duel.IsExistingMatchingCard(c11561071.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,41513082)==0 then
			Duel.RegisterFlagEffect(tp,41513082,RESET_PHASE+PHASE_END,0,1)
			local sc=Duel.SelectMatchingCard(tp,c11561071.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
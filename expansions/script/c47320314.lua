-- 失梦交刃
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301)
	s.negate(c)
	s.level_change(c)
end

function s.negate(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
    return c:IsFaceupEx() and c:IsSetCard(0x3c17) and c:IsType(TYPE_MONSTER)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function s.tgfilter(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,0,1,c)
			and Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,#g1,0,0)
end
function s.rlfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsReleasable(REASON_EFFECT)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ng=g:Filter(Card.IsRelateToEffect,nil,e)
    if #ng>0 then
        local ct=0
        for tc in aux.Next(ng) do
            if tc:IsCanBeDisabledByEffect(e,false) then
                ct=ct+1
                Duel.NegateRelatedChain(tc,RESET_TURN_SET)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetCode(EFFECT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e2:SetCode(EFFECT_DISABLE_EFFECT)
                e2:SetValue(RESET_TURN_SET)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e2)
                if tc:IsType(TYPE_TRAPMONSTER) then
                    local e3=Effect.CreateEffect(c)
                    e3:SetType(EFFECT_TYPE_SINGLE)
                    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                    e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
                    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
                    tc:RegisterEffect(e3)
                end
            end
        end
        if ct>0 and Duel.IsExistingMatchingCard(s.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(s.rlfilter,tp,0,LOCATION_MZONE,1,nil)
            and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local rg1=Duel.SelectMatchingCard(tp,s.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local rg2=Duel.SelectMatchingCard(tp,s.rlfilter,tp,0,LOCATION_MZONE,1,1,nil)
            Duel.HintSelection(rg1)
            Duel.HintSelection(rg2)
            rg1:Merge(rg2)
            Duel.Release(rg1,REASON_EFFECT)
        end
    end
end

function s.level_change(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id-1000)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
end
function s.lvfilter(c)
	return c:IsFaceup() and c:GetLevel()>1
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sel=0
		local lvl=2
		if tc:IsLevel(1,2) then
			sel=Duel.SelectOption(tp,aux.Stringid(id,2))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		end
		if sel==1 then
			lvl=-2
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

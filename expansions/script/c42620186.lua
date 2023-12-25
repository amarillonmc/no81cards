--邪恶★双子 璃拉·秘密
local cm,m=GetID()

function cm.initial_effect(c)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,m)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m+1)
    e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function cm.thfilter(c)
	return c:IsSetCard(0x152) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local n=Duel.GetFlagEffect(0,m)
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(cm.regop)
		e1:SetLabel(g:GetFirst():GetCode()+(n*10))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
        local e3=e1:Clone()
        e3:SetCode(EVENT_SPSUMMON_SUCCESS)
        Duel.RegisterEffect(e3,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabel(g:GetFirst():GetCode()+(n*10))
		e2:SetCondition(cm.damcon)
		e2:SetOperation(cm.damop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m+e:GetLabel())~=0 then return end
	local tc=eg:GetFirst()
	if tc:IsSummonPlayer(tp) and tc:IsCode(e:GetLabel()) then
		Duel.RegisterFlagEffect(0,m+e:GetLabel(),RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m+e:GetLabel())==0
end

function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,1100,REASON_EFFECT)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function cm.tgtfilter(c)
    return c:IsSetCard(0x152) and c:IsType(TYPE_LINK) and c:IsAbleToDeck()
end

function cm.tgtfilter2(c,e)
    return c:IsSetCard(0x152) and c:IsType(TYPE_LINK) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end

function cm.tgsfilter(c,e,tp)
    return c:IsCode(62098216) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>0 and c:IsAbleToDeck() and Duel.IsExistingTarget(cm.tgtfilter,tp,0x14,0,1,nil) and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x12,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tgtfilter2,tp,0x14,0,1,1,nil,e,tp)
    g:AddCard(c)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x12,0,1,1,nil,e,tp)
        if #g>0 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP) then
            Duel.BreakEffect()
            local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToChain,nil)
            if #dg>0 then
                Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
            end
        end
    end
end
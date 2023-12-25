--直播☆双子星 姬丝基勒·璃拉·传说
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1151),2,2)
	c:EnableReviveLimit()
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=c:GetOverlayGroup()
    local b1=g:IsExists(Card.IsSetCard,1,nil,0x152) and Duel.IsPlayerCanDraw(tp,1)
    local b2=g:IsExists(Card.IsSetCard,1,nil,0x153) and Duel.GetFieldGroupCount(tp,0,0x0c)>0
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and (b1 or b2) end
    local g1=Group.CreateGroup()
    if b1 then g1:Merge(g:Filter(Card.IsSetCard,nil,0x152)) end
    if b2 then g1:Merge(g:Filter(Card.IsSetCard,nil,0x153)) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
    local gc=g1:Select(tp,1,1,nil):GetFirst()
    Duel.SendtoGrave(gc,REASON_COST)
    local i=0
    if gc:IsSetCard(0x152) then i=i|0x1 end
    if gc:IsSetCard(0x153) then i=i|0x2 end
    e:SetLabel(i)
end

function cm.thfilter(c)
	return c:IsSetCard(0x153,0x152) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    local i=e:GetLabel()
	if i&0x1==0x1 then
        e:SetCategory(e:GetCategory()|CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
    if i&0x2==0x2 then
        e:SetCategory(e:GetCategory()|CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,0x0c)
	end
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        Duel.BreakEffect()
		local i=e:GetLabel()
        if i&0x1==0x1 then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
        if i&0x2==0x2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	        local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
            if #dg>0 then
                Duel.HintSelection(dg)
                Duel.Destroy(dg,REASON_EFFECT)
            end
        end
	end
end

function cm.tgsfilter(c,e,tp)
	return c:IsSetCard(0x152,0x153) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end

function cm.tgsgfilter(g)
    local g1=g:Filter(Card.IsSetCard,nil,0x152)
    local g2=g:Filter(Card.IsSetCard,nil,0x153)
    local g3=g1:__add(g2)
    return #g1>=1 and #g2>=1 and #g3==2
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(cm.tgsfilter,tp,0x10,0,e:GetHandler(),e,tp)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(cm.tgsgfilter,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=g:SelectSubGroup(tp,cm.tgsgfilter,false,2,2)
    Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 or (#g==2 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return false end
	if #g<=ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c)
	return not c:IsRace(RACE_FIEND) and c:IsLocation(LOCATION_EXTRA)
end
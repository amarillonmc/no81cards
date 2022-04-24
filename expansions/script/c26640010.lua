--颜彩-碎彩舞台
local m=26640010
local cm=_G["c"..m]
function c26640010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26640010+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,26640110)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(cm.rectg)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,26640210)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(cm.sctg)
	e3:SetOperation(cm.scop)
	c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1,26640310)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(cm.nptg)
	e4:SetOperation(cm.npop)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:GetSequence()<5
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe51) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil):GetCount()>0  
	and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0))then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
---1效果
function cm.penfilter(c)
	return  c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsSetCard(0xe51)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_EXTRA,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
		    Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
    end
end
---2效果
function cm.scfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe51) and c:IsLevelAbove(0)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,cm.scfilter,tp,LOCATION_PZONE,0,1,1,nil)
	local sc=g:GetFirst()
	if sc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(sc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		sc:RegisterEffect(e2)
	end
end
----3效果
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe51) and c:IsType(TYPE_PENDULUM)
end
function cm.fselect(g,tp)
	return g:GetSum(Card.GetCurrentScale)>=9
end
function cm.gcheck(g)
	return g:GetSum(Card.GetLevel)<=9
end
function cm.nptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetCount()>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp)
        end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.npop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	aux.GCheckAdditional=cm.gcheck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local ng=g:SelectSubGroup(tp,cm.fselect,false,1,g:GetCount(),tp)
	aux.GCheckAdditional=nil
	Duel.Remove(ng,POS_FACEUP,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_PZONE,0,nil,e,tp) then
	Duel.BreakEffect()
    local yg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	local sg=yg:GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
---4效果
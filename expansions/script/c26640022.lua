--交界间的颜彩使
local m=26640022
local cm=_G["c"..m]
function c26640022.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26640022)
    e1:SetCost(cm.atkcost)
	e1:SetTarget(cm.rectg)
	e1:SetOperation(cm.recop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCost(cm.kcost)
    e2:SetCondition(cm.discon)
	e2:SetTarget(cm.nrectg)
	e2:SetOperation(cm.nrecop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCost(cm.cost)
    e3:SetCondition(cm.iscon)
	e3:SetTarget(cm.ectg)
	e3:SetOperation(cm.ecop)
	c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetCondition(cm.niscon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(600)
	e6:SetCondition(cm.hniscon)
	c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.hniscon)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
end
function cm.cfilter(c)
	return  (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) and c:IsType(TYPE_SYNCHRO)
end
----同调素材
function cm.filter(c)
	return  (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) and c:IsType(TYPE_MONSTER)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.cfilter,1,nil)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ng=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return ng:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
            if tc then
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
                    local e1=Effect.CreateEffect(tc)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_CANNOT_TRIGGER)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                    hg:RegisterEffect(e1)
					tc=g:GetNext()
				end
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
                e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
                e1:SetTargetRange(1,0)
                e1:SetTarget(cm.splimit)
                e1:SetReset(RESET_PHASE+PHASE_END)
                Duel.RegisterEffect(e1,tp)
            end
end
function cm.splimit(e,c)
	return not  (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) 
end
----1效果
function cm.kcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function cm.ccfilter1(c)
	return c:IsSetCard(0xe51) and c:IsType(TYPE_SYNCHRO)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetMaterial():FilterCount(cm.ccfilter1,nil)>0
end
function cm.nrectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_DECK)
end
function cm.thfilter(c,lv)
	return c:IsSetCard(0xe51) or c:IsSetCard(0xb81)
end
function cm.nrecop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		local ct=g:GetCount()
		if ct>0 and g:FilterCount(cm.thfilter,nil,ct)>0 then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil,ct)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
            Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil) then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
			local ng=sg:GetFirst()
			Duel.Remove(ng,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--颜彩同调怪兽为素材
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function cm.ccfilter2(c)
	return c:IsSetCard(0xb81) and c:IsType(TYPE_SYNCHRO)
end
function cm.iscon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetMaterial():FilterCount(cm.ccfilter2,nil)>0
end
function cm.ectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.ecop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
    if Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil) then
        Duel.BreakEffect()
        local sg=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil)
        local ng=sg:GetFirst()
        Duel.Remove(ng,POS_FACEUP,REASON_EFFECT)
    end
end
----交界同调怪兽为素材
function cm.ccfilter3(c)
	return c:IsSetCard(0xe51) and not c:IsType(TYPE_SYNCHRO)
end
function cm.niscon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetMaterial():FilterCount(cm.ccfilter3,nil)>0
end
--同调以外的颜彩同调怪兽为素材
function cm.ccfilter4(c)
	return c:IsSetCard(0xe51) and not c:IsType(TYPE_SYNCHRO)
end
function cm.hniscon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetMaterial():FilterCount(cm.ccfilter4,nil)>0
end
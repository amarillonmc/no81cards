--交界的颜彩医师
local m=26640025
local cm=_G["c"..m]
function c26640025.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCost(cm.kcost)
    e1:SetCondition(cm.discon)
	e1:SetTarget(cm.nrectg)
	e1:SetOperation(cm.nrecop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCost(cm.nkcost)
    e2:SetCondition(cm.ndiscon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.ecop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1000)
	e3:SetCondition(cm.hniscon)
	c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.hniscon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(1000)
	e5:SetCondition(cm.hhniscon)
	c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.hhniscon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function cm.kcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function cm.ccfilter1(c)
	return c:IsSetCard(0xb81) and c:IsType(TYPE_TUNER)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():FilterCount(cm.ccfilter1,nil)>0
end
function cm.nrectg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==3 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_DECK)
end
function cm.thfilter(c,lv)
	return (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) and c:IsType(TYPE_MONSTER)
end
function cm.nrecop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	if ct>3 then ct=3 end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    if g:FilterCount(cm.thfilter,nil,ct)>0 then
        local sg=g:FilterSelect(tp,cm.thfilter,1,3,nil,ct)
        local tc=sg:GetFirst()
            if tc then
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					tc=sg:GetNext()
				end
                Duel.SpecialSummonComplete()
            end 
    end
end
----调整的交界怪兽
function cm.nkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    if (g:GetFirst():IsSetCard(0xe51) or g:GetFirst():IsSetCard(0xb81))then
        e:SetLabelObject(tc)
    end
	
end
function cm.nthfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) )
end
function cm.ccfilter2(c)
	return c:IsSetCard(0xe51) and c:IsType(TYPE_TUNER)
end
function cm.ndiscon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():FilterCount(cm.ccfilter2,nil)>0
end
function cm.thspfilter(c,e,tp)
	return (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	
end
function cm.filter(c,e,tp,tc)
	return c==tc--c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ecop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp,tc) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
end
---调整的彩绘怪兽
function cm.ccfilter3(c)
	return c:IsSetCard(0xb81) and not c:IsType(TYPE_TUNER)
end
function cm.hniscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():FilterCount(cm.ccfilter3,nil)>0
end
---非调整的交界怪兽
function cm.ccfilter4(c)
	return c:IsSetCard(0xe51) and not c:IsType(TYPE_TUNER)
end
function cm.hhniscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():FilterCount(cm.ccfilter4,nil)>0
end
--颜彩-紊乱之彩
local m=26640017
local cm=_G["c"..m]
function c26640017.initial_effect(c)
    aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,cm.matfilter2,1,99)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false)
	--pendulum summon
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	--Def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e2:SetValue(-500)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,26640117)
	e3:SetCondition(cm.spcon2)
	e3:SetTarget(cm.sptg2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.indtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
c26640017.pendulum_level=8
function cm.matfilter2(c)
	return c:IsSynchroType(TYPE_PENDULUM) and c:IsSetCard(0xe51)
end
function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0xe51)
end
function cm.penfilter(c)
	return  c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup() and c:IsSetCard(0xe51)
end
function cm.cfilter(c,tp,rp)
	return  c:GetPreviousControler()==tp
		and c:IsPreviousSetCard(0xe51) and (rp==1-tp and c:IsReason(REASON_EFFECT)) and c:IsType(TYPE_MONSTER)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,rp) and e:GetHandler():IsLocation(LOCATION_PZONE)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
        if Duel.GetMatchingGroup(cm.penfilter,tp,LOCATION_EXTRA,0,nil):GetCount()>0 and not Duel.GetMatchingGroup(cm.penfilter,tp,LOCATION_EXTRA,0,nil):GetCount()==2 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.BreakEffect()
        local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
        local tc=g:GetFirst()
        Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        Duel.DiscardHand(tp,cm.aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
        end
	end
end
---灵摆效果
function cm.indtg(e,c)
	return c:IsSetCard(0xe51) and c:IsType(TYPE_MONSTER)
end
---1效果
function cm.desfilter1(c)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.desfilter1,tp,0,LOCATION_ONFIELD,1,nil)  end

	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
----2效果
function cm.peenfilter(c)
	return  c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup() and c:IsSetCard(0xe51)
	and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCurrentScale())
end
function cm.spfilter1(c,e,tp,lv)
	return c:IsSetCard(0xe51) and c:IsLevel(lv)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_PENDULUM) and re:IsLocation(LOCATION_PZONE) and re:IsControler(tp) and re:IsSetCard(0xe51)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.peenfilter,tp,LOCATION_PZONE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.peenfilter,tp,LOCATION_PZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local lv=tc:GetCurrentScale()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
            Duel.BreakEffect()
            local ng=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
			local yc=ng:GetFirst()
			if yc then
				Duel.SpecialSummon(yc,0,tp,tp,false,false,POS_FACEUP)
			end
		    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
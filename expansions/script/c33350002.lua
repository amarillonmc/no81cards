--传说之魂 耐心
local m=33350002
local cm=_G["c"..m]
function c33350002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(cm.xmatcon)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
end
cm.setname="TaleSouls"
function cm.spfilter(c,e,tp)
	return  c.setname=="TaleSouls" and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and not c:IsCode(m)
end
function cm.pfilter(c,e,tp)
	return  c:IsCode(33350001)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            if  Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
                Duel.BreakEffect()
                Duel.Recover(tp,500,REASON_EFFECT)
                Duel.Draw(tp,1,REASON_EFFECT)
            end
		end
	end
end
--效果1
function cm.xmatcon(e)
	local c=e:GetHandler()
	return c.setname=="TaleSouls"
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--炎魔的御者 赫利俄斯
local s,id,o=GetID()
function s.initial_effect(c)
    --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --Desed
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
    e2:SetTarget(s.htgtg)
	e2:SetOperation(s.htgop)
	c:RegisterEffect(e2)
end
function s.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x408) and c:GetOriginalType()&TYPE_MONSTER>0 and Duel.GetMZoneCount(tp,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,0x0c,0,1,nil,tp)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,0x0c,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.filter(c)
	return c:IsSetCard(0x408) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetLocationCount(tp,0x08)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.Hint(3,tp,518)
        local g=Duel.SelectMatchingCard(tp,s.filter,tp,0x01,0,1,1,nil)
        local tc=g:GetFirst()
      	if tc and Duel.Equip(tp,tc,c) then
        	local e1=Effect.CreateEffect(c)
        	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        	e1:SetType(EFFECT_TYPE_SINGLE)
        	e1:SetCode(EFFECT_EQUIP_LIMIT)
        	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        	e1:SetValue(s.eqlimit)
        	tc:RegisterEffect(e1)
    	end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.eqfi1ter(c)
	return c:IsSetCard(0x408) and c:IsFaceup()
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.eqfi1ter,tp,0x04,0,1,nil)
        and Duel.GetLocationCount(tp,0x08)>0 end
    Duel.Hint(3,tp,551)
    Duel.SelectTarget(tp,s.eqfi1ter,tp,0x04,0,1,1,nil)
end
function s.htgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local g=Duel.GetMatchingGroup(s.filter,tp,0x01,0,nil)
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and #g>0 and Duel.GetLocationCount(tp,0x08)>0 then
        Duel.Hint(3,tp,518)
        local tc2=g:Select(tp,1,1,nil):GetFirst()
        if Duel.Equip(tp,tc2,tc) then
            local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_EQUIP_LIMIT)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetLabelObject(tc)
		    e1:SetValue(s.eq2imit)
		    tc2:RegisterEffect(e1)
        end
	end
end
function s.eq2imit(e,c)
	return c==e:GetLabelObject()
end
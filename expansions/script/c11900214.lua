--普鲁托
local s,id,o=GetID()
function s.initial_effect(c)
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c56099748.tfilter(chkc,c,tp) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(s.tfilter,tp,0,LOCATION_MZONE,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tfilter,tp,0,LOCATION_MZONE,1,1,nil,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
            local code=tc:GetOriginalCodeRule()
            local cid=0
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
           	e1:SetCode(EFFECT_CHANGE_CODE)
            e1:SetValue(code)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e1)
            if not tc:IsType(TYPE_TRAPMONSTER) then
                cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		    end
            local e2=Effect.CreateEffect(c)
    		e2:SetType(EFFECT_TYPE_SINGLE)
    		e2:SetCode(EFFECT_UPDATE_ATTACK)
	    	e2:SetValue(tc:GetBaseAttack())
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
       		c:RegisterEffect(e2)
            local e3=e2:Clone()
           	e3:SetCode(EFFECT_UPDATE_DEFENSE)
            e3:SetValue(tc:GetBaseDefense())
            c:RegisterEffect(e3)
            Duel.SpecialSummonComplete()
		end
	end
end
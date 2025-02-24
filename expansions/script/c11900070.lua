--古之朝阳－亚顿
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--to grave  
	local e1=Effect.CreateEffect(c)  
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) end)
	e1:SetTarget(c11900070.tgtg) 
	e1:SetOperation(c11900070.tgop) 
	c:RegisterEffect(e1) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSummonLocation(LOCATION_GRAVE) end)
	e2:SetValue(aux.indoval) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end)
	c:RegisterEffect(e2)
end
function s.thfil(c) 
	return c:IsAbleToHand() and aux.IsCodeListed(c,11900061) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function s.desfilter1(c)
	return c:GetSequence()<5 and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function s.desfilter2(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end  
	if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(s.thfil,tp,LOCATION_GRAVE,0,e:GetHandler())  
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg:IsCanBeSpecialSummoned(e,0,tp,false,true) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
            sg:CompleteProcedure()
            local fid=e:GetHandler():GetFieldID()
           	sg:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
        	local e1=Effect.CreateEffect(e:GetHandler())
           	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        	e1:SetCode(EVENT_PHASE+PHASE_END)
        	e1:SetCountLimit(1)
        	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        	e1:SetLabel(fid)
        	e1:SetLabelObject(sg)
        	e1:SetCondition(s.etgcon)
        	e1:SetOperation(s.etgop)
        	Duel.RegisterEffect(e1,tp)
        else 
            Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end 
	end
end
function s.etgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.etgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
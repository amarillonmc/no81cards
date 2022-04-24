--方舟骑士升变
function c29065533.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,29065533+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29065533.actg) 
	e1:SetOperation(c29065533.acop) 
	c:RegisterEffect(e1)
end
function c29065533.rmfil(c) 
	return c:IsCode(29065500,29065508) and c:IsAbleToRemove()  
end
function c29065533.gck(g) 
	return g:GetClassCount(Card.GetCode)==g:GetCount() 
end 
function c29065533.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:GetOriginalCode()==29065513 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c29065533.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c29065533.rmfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil) 
	if chk==0 then return g:CheckSubGroup(c29065533.gck,2,2) and Duel.IsExistingMatchingCard(c29065533.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end
function c29065533.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c29065533.rmfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil) 
	local sg=Duel.GetMatchingGroup(c29065533.spfil,tp,LOCATION_EXTRA,0,nil,e,tp) 
	if g:CheckSubGroup(c29065533.gck,2,2) and sg:GetCount()>0 then 
	local rg=g:SelectSubGroup(tp,c29065533.gck,false,2,2)  
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	local tc=sg:Select(tp,1,1,nil):GetFirst() 
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:RegisterFlagEffect(29065533,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabel(Duel.GetTurnCount()+1)
		e2:SetLabelObject(tc)
		e2:SetCondition(c29065533.descon)
		e2:SetOperation(c29065533.desop)
		Duel.RegisterEffect(e2,tp)
	end 
end 
function c29065533.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(29065533)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function c29065533.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT) 
	Duel.SetLP(tp,Duel.GetLP(tp)/2)
end







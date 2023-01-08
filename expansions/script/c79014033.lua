--元气主唱
function c79014033.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--summon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79014033)
	e1:SetTarget(c79014033.sumtg)
	e1:SetOperation(c79014033.sumop)
	c:RegisterEffect(e1)
end
function c79014033.sumfil(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_SPIRIT) and not c:IsCode(79014033)
end
function c79014033.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79014033.sumfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND +LOCATION_MZONE)
end
function c79014033.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c79014033.sumfil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.Summon(tp,tc,true,nil) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0) 
		e1:SetLabelObject(e) 
		e1:SetLabel(tc:GetAttribute())
		e1:SetTarget(c79014033.splimit)
		Duel.RegisterEffect(e1,tp)
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c79014033.splimit(e,c,sump,sumtype,sumpos,targetp,se) 
	local att=e:GetLabel() 
	local te=e:GetLabelObject()
	return te==se and c:IsAttribute(att) 
end









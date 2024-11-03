local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return (c:IsRace(RACE_REPTILE) and c:IsAttribute(ATTRIBUTE_LIGHT)) or c:IsSetCard(0xc)
end
function s.spfilter(c)
	return c:IsFaceup() and c:GetCounter(0x100e)>0 and c:IsControlerCanBeChanged()
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local le={tc:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
	for _,v in pairs(le) do
		local val=v:GetValue()
		v:SetValue(s.chval(val,e))
	end
	if Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_REPTILE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e2,tp)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not ((c:IsRace(RACE_REPTILE) and c:IsAttribute(ATTRIBUTE_LIGHT)) or c:IsSetCard(0xc))
end
function s.chval(_val,ce)
	return function(e,te)
				if te==ce then return false end
				return _val(e,te)
			end
end

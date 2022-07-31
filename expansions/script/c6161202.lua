--破碎世界的月亮
function c6161202.initial_effect(c)
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcCodeRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x616),2,true)  
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)  
	--spsummon   
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6161202,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,6161202)
	e1:SetCost(c6161202.spcost)
	e1:SetTarget(c6161202.sptg)
	e1:SetOperation(c6161202.spop)
	c:RegisterEffect(e1) 
end
function c6161202.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c6161202.cfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c6161202.fselect(g,tg)
	return tg:IsExists(Card.IsLink,1,nil,#g)
end
function c6161202.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x616) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c6161202.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c6161202.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c6161202.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local _,maxlink=tg:GetMaxGroup(Card.GetLink)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if #tg==0 then return false end
		return cg:CheckSubGroup(c6161202.fselect,1,maxlink,tg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:SelectSubGroup(tp,c6161202.fselect,false,1,maxlink,tg)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c6161202.spfilter1(c,e,tp,lk)
	return c6161202.spfilter(c,e,tp) and c:IsLink(lk)
end
function c6161202.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c6161202.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c6161202.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c6161202.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
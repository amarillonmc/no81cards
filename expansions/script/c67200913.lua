--奥山修正者 操偶师
function c67200913.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c67200913.matfilter,3,4)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_PZONE,0)
	e0:SetValue(c67200913.matval)
	c:RegisterEffect(e0)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200913,1))
	e3:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,67200913)
	e3:SetCondition(c67200913.spcon2)
	e3:SetTarget(c67200913.sptg2)
	e3:SetOperation(c67200913.spop2)
	c:RegisterEffect(e3)	
end
function c67200913.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x67a) or (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a))
end 
function c67200913.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
--
function c67200913.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c67200913.descheck(c,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x67a) and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c67200913.descheck1(c,tp)
	return c:IsFaceupEx() and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c67200913.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c67200913.descheck,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c67200913.descheck1,tp,0,LOCATION_MZONE,1,nil) 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200913,2))
	local g1=Duel.SelectTarget(tp,c67200913.descheck,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200913,2))
	local g2=Duel.SelectTarget(tp,c67200913.descheck1,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c67200913.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a and b then
		if Duel.SwapControl(a,b)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

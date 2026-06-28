--疑散虚符族·Swift
local s,id,o=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.xyzcon)
	c:RegisterEffect(e2)
	if not s.global_flag then
		s.global_flag=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetCondition(s.chaincon)
		e2:SetOperation(s.chainop)
		Duel.RegisterEffect(e2,0)
	end
end
function s.sptfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc3d)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.sptfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.filter(c)
	return c:IsSetCard(0xc3d) and c:IsFaceup() and c:IsLevelAbove(0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.NecroValleyFilter()(c) and c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(sg:GetFirst():GetOriginalLevel())
		c:RegisterEffect(e1)
	end
end
function s.xyzcon(e)
	local c=e:GetHandler()
	return c:IsSetCard(0xc3d) and c:GetOverlayCount()>=4
end
function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsHasEffect(EVENT_CUSTOM+id)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(re,rp,tp)
	return tp==rp
end

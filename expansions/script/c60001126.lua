--圣兽装骑·鲨-参观
local m=60001126
local cm=_G["c"..m]

function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_SZONE+LOCATION_GRAVE)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	local e27=Effect.CreateEffect(c)
	e27:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e27:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e27:SetCode(EVENT_ADJUST)
	e27:SetOperation(cm.gravecheckop)
	Duel.RegisterEffect(e27,0)
end

function cm.gravecheckop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then
		e:GetHandler():RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60001111,0))
	end
end

function cm.consfilter(c)
	return c:IsSetCard(0x562e) and c:IsSummonLocation(LOCATION_EXTRA)
end

function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(cm.consfilter,tp,LOCATION_MZONE,0,nil)>=2
	and (c:IsLocation(LOCATION_FZONE) or Duel.GetFlagEffect(tp,m)==0)
end

function cm.tgspfilter(c,tp)
	if Duel.GetFlagEffectLabel(tp,600011260)==nil then
		return true 
	else
		return not c:IsCode(Duel.GetFlagEffectLabel(tp,600011260))
	end
end

function cm.tgsfilter(c,e,tp)
	return c:IsSetCard(0x562e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and cm.tgspfilter(c,tp)
end

function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and (not c:IsLocation(LOCATION_GRAVE) or c:IsSSetable()) end
	c:ResetFlagEffect(m)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
		c:RegisterFlagEffect(m,0,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function cm.opcannotspsummoncheck(c,tp,code)
	return c:IsCode(code) and c:GetOwner()==tp
end

function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
			local code=g:GetFirst():GetCode()
			Duel.RegisterFlagEffect(tp,600011260,0,0,1,code)
			local gg=Duel.GetMatchingGroup(cm.opcannotspsummoncheck,tp,0xff,0xff,nil,tp,code)
			local nc=gg:GetFirst()
			while nc do
				nc:RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
				nc=gg:GetNext()
			end
			if c:GetFlagEffect(m)~=0 and c:IsRelateToEffect(e) then
				Duel.SSet(tp,c)
			end
		end
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp) 
end

function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
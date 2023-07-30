--方舟骑士-琴柳
function c29096814.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(29096814)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29096814,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c29096814.sprcon)
	e1:SetOperation(c29096814.sprop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c29096814.splimit)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29096814,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c29096814.cttg)
	e3:SetOperation(c29096814.ctop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(29096814)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
end
function c29096814.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c29096814.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST)
end
function c29096814.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
end
function c29096814.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x10ae)
end
function c29096814.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then 
			e:GetHandler():AddCounter(0x10ae,1)
			Duel.RegisterFlagEffect(tp,29096815,RESET_PHASE+PHASE_END,0,1)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(29096814,0))
			e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e2:SetType(EFFECT_TYPE_IGNITION)
			e2:SetRange(LOCATION_HAND)
			e2:SetTarget(c29096814.sptg)
			e2:SetOperation(c29096814.spop)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(LOCATION_HAND,0)
			e1:SetTarget(c29096814.eftg)
			e1:SetLabelObject(e2)
			Duel.RegisterEffect(e1,tp)
	end
end
function c29096814.eftg(e,c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
end
function c29096814.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFlagEffect(tp,29096815)==1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29096814.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.ResetFlagEffect(tp,29096815)
	end
end







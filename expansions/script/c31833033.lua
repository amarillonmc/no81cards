--新炎狱古神
function c31833033.initial_effect(c)
	--link summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c31833033.linkcon)
	e0:SetOperation(c31833033.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	c:EnableReviveLimit()
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c31833033.econ)
	e2:SetTarget(c31833033.etarget)
	e2:SetValue(c31833033.efilter)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c31833033.effop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31833033,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_TOHAND+TIMING_END_PHASE)
	e4:SetCost(c31833033.cost)
	e4:SetTarget(c31833033.sptg)
	e4:SetOperation(c31833033.spop)
	c:RegisterEffect(e4)
end
function c31833033.linkfilter(c,lc,tp)
	return c:IsFaceup() and c:IsSetCard(0x2c) and c:IsCanBeLinkMaterial(lc) and not c:IsType(TYPE_LINK) and not c:IsType(TYPE_NORMAL)
end
function c31833033.linkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c31833033.linkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local mg2=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local mg3=Group.__add(mg,mg2)
	return mg:GetCount()>0 and mg3:GetCount()>3 and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c31833033.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c31833033.linkfilter,tp,LOCATION_MZONE,0,1,4,nil,c,tp)
	if g1:GetCount()==4 then
		c:SetMaterial(g1)
		Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,4-(g1:GetCount()),4-(g1:GetCount()),nil,c,tp)
		local g3=Group.__add(g1,g2)
		c:SetMaterial(g3)
		Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
		Duel.Remove(g2,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
	end
end

function c31833033.econ(e)
	return Duel.GetFieldGroupCount(e:GetOwnerPlayer(),0,LOCATION_GRAVE)<=3
end
function c31833033.etarget(e,c)
	return c:IsSetCard(0x2c) 
end
function c31833033.efilter(e,re)
	return not re:GetHandler():IsSetCard(0x2c)
end

function c31833033.efffilter(c,lg,ignore_flag)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x2c) and not c:IsCode(31833033)
		and (ignore_flag or c:GetFlagEffect(31833033)==0)
end
function c31833033.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c31833033.efffilter,tp,LOCATION_GRAVE,0,nil)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,1)
			c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
		end 
	end
end
function c31833033.cfilter(c,tp)
	return c:IsSetCard(0x2c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c31833033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31833033.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c31833033.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c31833033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
end
function c31833033.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_HAND,1,1,nil,e,0,tp,false,false)
	if g:GetCount()>0 and Duel.SpecialSummonStep(g:GetFirst(),0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK) then
		local tc=g:GetFirst()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(31833034,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(c31833033.rmcon1)
		e3:SetOperation(c31833033.rmop1)
		Duel.RegisterEffect(e3,tp)
		Duel.SpecialSummonComplete()
	end
end
function c31833033.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(31833034)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c31833033.rmop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetLabelObject(),POS_FACEUP,REASON_EFFECT)
end
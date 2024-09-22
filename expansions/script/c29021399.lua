--方舟骑士-阿米娅·奇美拉
c29021399.named_with_Arknight=1
function c29021399.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--change name
	aux.EnableChangeCode(c,29065500,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,29021399)
	e1:SetCost(c29021399.spcost)
	e1:SetTarget(c29021399.sptg)
	e1:SetOperation(c29021399.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c29021399.tgcon)
	e2:SetTarget(c29021399.tgtg)
	e2:SetOperation(c29021399.tgop)
	c:RegisterEffect(e2)
	c29021399.summon_effect=e2   
end
function c29021399.rfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c29021399.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c29021399.rfilter,1,REASON_COST,true,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c29021399.rfilter,1,1,REASON_COST,true,c,tp)
	local label=0
	if g:IsExists(Card.IsCode,1,nil,29065500) then label=1 end
	e:SetLabel(label)
	Duel.Release(g,REASON_COST)
end
function c29021399.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29021399.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,e:GetLabel(),tp,tp,false,false,POS_FACEUP)
	end
end
function c29021399.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c29021399.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c29021399.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	c:RegisterFlagEffect(29021399,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetCondition(c29021399.descon)
	e1:SetOperation(c29021399.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29021399.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(29021399)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c29021399.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end

--风暴瞭望
function c82568091.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,82568091)
	e2:SetCondition(c82568091.condition2)
	e2:SetTarget(c82568091.target2)
	e2:SetOperation(c82568091.activate2)
	c:RegisterEffect(e2)
end
function c82568091.spfilter(c,e,tp,ree)
	local lv=0
	local rk=0
	local lk=0
	if ree:GetLevel()>0 then
	lv=ree:GetLevel()
	end
	if ree:GetRank()>0 then
	rk=ree:GetRank()
	end
	if ree:GetLink()>0 then
	rk=ree:GetLink()
	end
	if c:IsLocation(LOCATION_EXTRA)
	  then return c:IsSetCard(0x825) and ((c:GetLevel()>0 and c:IsLevel(lv)) or (c:GetRank()>0 and c:IsRank(rk)) or (c:GetLink()>0 and c:IsLink(lk)))
		   and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		   and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else return c:IsSetCard(0x825) and c:IsLevel(lv) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
	end
end
function c82568091.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c82568091.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c82568091.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp,re:GetHandler())
	if chk==0 then return g:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA+LOCATION_DECK)
end
function c82568091.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ree=re:GetHandler()
	local g=Duel.GetMatchingGroup(c82568091.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp,ree) 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568091.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,ree)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(1)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
		 local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(82568091,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_CANNOT_DISABLE)
		e6:SetLabel(fid)
		e6:SetLabelObject(tc)
		e6:SetCondition(c82568091.tdcon)
		e6:SetOperation(c82568091.tdop)
		Duel.RegisterEffect(e6,tp)
	end
   end
   end
end
function c82568091.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(82568091)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c82568091.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
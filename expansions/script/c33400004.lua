--时崎狂三 中二
function c33400004.initial_effect(c)
	c:EnableCounterPermit(0x34f)
	--special summon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33400004)
	e1:SetLabel(2)
	e1:SetCost(c33400004.cost)
	e1:SetTarget(c33400004.sptg)
	e1:SetOperation(c33400004.spop)
	c:RegisterEffect(e1)
	--special summon from extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,33400004+10000)
	e2:SetTarget(c33400004.target)
	e2:SetOperation(c33400004.operation)
	c:RegisterEffect(e2)
end
--e2
function c33400004.filter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0x3341) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c33400004.exfilter,tp,LOCATION_EXTRA,0,1,nil,lv+4,e,tp)
end
function c33400004.exfilter(c,lv,e,tp)
	return c:IsSetCard(0x3341) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400004.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c33400004.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c33400004.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33400004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	local rg=Group.FromCards(c,tc)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==2 and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c33400004.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetLevel()+4,e,tp)
		local sc=sg:GetFirst()
		if sc and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then
		   local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  e1:SetValue(0)
		  sc:RegisterEffect(e1)
		  local e2=Effect.CreateEffect(e:GetHandler())
		  e2:SetType(EFFECT_TYPE_SINGLE)
		  e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		  e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		  e2:SetValue(0)
		  sc:RegisterEffect(e2)  
		end
	end
end
--e1
function c33400004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400004.spfilter(c,e,tp)
	return  c:IsSetCard(0x3341) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400004.spfilter(chkc,e,tp) end
	local nm=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return nm>0
		and Duel.IsExistingTarget(c33400004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if nm>2 then nm=2 end
	local g=Duel.SelectTarget(tp,c33400004.spfilter,tp,LOCATION_GRAVE,0,1,nm,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33400004.spop(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	 while tc do 
	  if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
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
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
	  end
	 tc=g:GetNext()
	 end
	end
	Duel.SpecialSummonComplete()
	 if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c33400004.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c33400004.splimit(e,c)
	return not c:IsSetCard(0x341)
end
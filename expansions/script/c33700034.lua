--Protoform的唤起术
function c33700034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33700034.target)
	e1:SetOperation(c33700034.activate)
	c:RegisterEffect(e1)
end
function c33700034.eqfilter(c)
   return c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c33700034.filter(c,e,tp)
	return c:IsSetCard(0x3440) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(c33700034.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function c33700034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c33700034.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and
		Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c33700034.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33700034.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33700034.activate(e,tp,eg,ep,ev,re,r,rp)
	 local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
	local g=Duel.GetMatchingGroup(c33700034.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	 if ft>g:GetCount() then ft=g:GetCount() end
	if ft==0 then return end
	for i=1,ft do
	  local ec=g:Select(tp,1,1,nil):GetFirst()
	  g:RemoveCard(ec)
	    Duel.Equip(tp,ec,tc)
	   local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33700034.eqlimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		ec:RegisterEffect(e1)
		ec:RegisterFlagEffect(33700034,RESET_EVENT+0x1fe0000,0,1)
	end
	 local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(33700034,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33700034.dacost)
	e2:SetTarget(c33700034.datg)
	e2:SetOperation(c33700034.daop)
	tc:RegisterEffect(e2)
end
end
function c33700034.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c33700034.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33700034.dafilter(c,ec)
	return c:GetFlagEffect(33700034)~=0 and c:GetEquipTarget()==ec and c:IsAbleToHand() and c:GetBaseAttack()>0
end
function c33700034.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c33700034.dafilter(chkc,c) end
	if chk==0 then return  Duel.IsExistingTarget(c33700034.dafilter,tp,LOCATION_SZONE,0,1,nil,c) end
	local g=Duel.SelectTarget(tp,c33700034.dafilter,tp,LOCATION_SZONE,0,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetBaseAttack())
end
function c33700034.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)>0 then
	 Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
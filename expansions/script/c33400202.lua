--洞彻万物 本条二亚
function c33400202.initial_effect(c)
	 --sps
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,33400202)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c33400202.condition)
	e1:SetOperation(c33400202.activate1)
	c:RegisterEffect(e1)
	--send to grave 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33400202+10000)
	e2:SetCondition(c33400202.sgcn)
	e2:SetOperation(c33400202.operation)
	c:RegisterEffect(e2)
   
end

function c33400202.cnfilter(c)
	return  c:IsSetCard(0x6342) and not c:IsCode(33400202)
end
function c33400202.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c33400202.cnfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end
function c33400202.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c33400202.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsCode(ac) then 
	   if Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil) then 
		  if Duel.SelectYesNo(tp,aux.Stringid(33400202,0)) then 
		  local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		  local tc1=g1:GetFirst()
		  local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(c33400202.efilter)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e4:SetOwnerPlayer(tp)
				tc1:RegisterEffect(e4)
		 
		  end
	   end
	Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	else  Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end

function c33400202.sgcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) or  e:GetHandler():IsReason(REASON_BATTLE)
end
function c33400202.tgfilter(c)
	return  c:IsSetCard(0x6342) and c:IsAbleToGrave()
end
function c33400202.operation(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   local g=Duel.SelectMatchingCard(tp,c33400202.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
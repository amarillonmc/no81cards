-- 绝强！绝顶！绝世！究绝之堕天！！！
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.tgcon)
	e3:SetOperation(s.mark)
	c:RegisterEffect(e3)
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3b:SetCode(EVENT_ADJUST)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetCondition(s.tgchk)
	e3b:SetOperation(s.tgop)
	c:RegisterEffect(e3b)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	e4:SetOperation(s.repop)
	c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
	return se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsRace(RACE_FAIRY)
end
function s.cfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsPublic()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	if e:IsHasType(EFFECT_TYPE_ACTIONS)	and e:GetLabelObject()==e:GetHandler() then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e:SetProperty(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	if Duel.GetMZoneCount(tp)<=0 then return end
	if sc==c and sc:IsRelateToChain(e) then
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT,1-tp)
		end
	elseif sc~=c and sc:IsRelateToChain(e) then 
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and not c:IsRelateToChain(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT,1-tp)
		elseif c:IsRelateToChain(e) then
			if Duel.SendtoGrave(c,REASON_EFFECT)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.HintSelection(g)
				Duel.SendtoGrave(g,REASON_EFFECT,1-tp)
			end
		end
	end
end
function s.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)	and c:IsPreviousControler(1-tp) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_REPLACE)
end
function s.mark(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.tgchk(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0 and Duel.GetCurrentChain()==0
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and eg:IsExists(s.filter,1,nil,tp)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(id)
	if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return end	
	if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) and Duel.IsExistingMatchingCard(aux.TRUE,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
		if #sg==0 or Duel.SendtoGrave(sg,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if #sg2>0 then
			Duel.HintSelection(sg2)
			if Duel.SendtoGrave(sg2,REASON_RULE,1-tp)~=0 then
				s.atkup(c)
				if sg2:GetFirst():IsPreviousLocation(LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(aux.TRUE,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then
					s.tgop(e,tp,eg,ep,ev,re,r,rp)
				end
			end
		end
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return end
	if chk==0 then return eg:IsContains(c) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,2)) then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,3))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
		if #g==0 then return false end
		e:SetLabelObject(g:GetFirst())
		return true
	end
end
function s.repval(e,c)
	return c==e:GetHandler()
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	e:SetLabelObject(nil)
	if tc and Duel.SendtoGrave(tc,REASON_REPLACE)~=0 then
		s.atkup(c)
	end
end
function s.atkup(c)
	if not c:IsFaceup() or not c:IsLocation(LOCATION_MZONE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
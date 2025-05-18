--看看好看的
function c60158211.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158211,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60158211+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c60158211.e1cost)
	e1:SetTarget(c60158211.e1tg)
	e1:SetOperation(c60158211.e1op)
	c:RegisterEffect(e1)
	
	--2xg
	--[[
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158211,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCost(c60158211.e2cost)
	e2:SetTarget(c60158211.e2tg)
	e2:SetOperation(c60158211.e2op)
	c:RegisterEffect(e2)
	]]
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetTarget(c60158211.reptg)
	e2:SetValue(c60158211.repval)
	e2:SetOperation(c60158211.repop)
	c:RegisterEffect(e2)
end

	--1xg
function c60158211.e1costf(c)
	return c:IsCode(60158001) and not c:IsPublic()
end
function c60158211.e1costff(c)
	return c:IsCode(60158001) and c:IsFaceup()
end
function c60158211.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158211.e1costf,tp,LOCATION_EXTRA,0,1,nil)
		or Duel.IsExistingMatchingCard(c60158211.e1costff,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(c60158211.e1costff,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c60158211.e1costf,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60158211.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):GetCount()>0 end
end
function c60158211.e1opf(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60158211.e1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local sg2=g:Filter(c60158211.e1opf,nil,e,1-tp)
		if #sg2<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=sg2:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:GetFirst()
		if tc then
			if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CHANGE_CODE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetValue(60158101)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
				--cannot link material
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e4:SetValue(c60158211.lmlimit)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
				tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE,1,0,aux.Stringid(60158211,2))
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c60158211.lmlimit(e,c)
	if not c then return false end
	return not (c:IsCode(60158001) or c:IsCode(60158101))
end

	--2xg
	
function c60158211.repfilter(c,tp)
	return c:IsFaceup() and c:IsCode(60158001,60158101)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c60158211.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(c60158211.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c60158211.repval(e,c)
	return c60158211.repfilter(c,e:GetHandlerPlayer())
end
function c60158211.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60158211)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end

--[[
function c60158211.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c60158211.e2tgf(c,sg)
	return c:IsLinkSummonable(sg)
end
function c60158211.e2tgff(c)
	return c:IsCode(60158101) and c:IsFaceup()
end
function c60158211.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c60158211.e2tgff,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return sg:GetCount()>0 and Duel.IsExistingMatchingCard(c60158211.e2tgf,tp,LOCATION_EXTRA,0,1,nil,sg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60158211.e2op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c60158211.e2tgff,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60158211.e2tgf,tp,LOCATION_EXTRA,0,1,1,nil,sg)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,sg)
	end
end
]]
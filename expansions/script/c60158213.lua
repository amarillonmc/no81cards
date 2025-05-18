--开窍了吗
function c60158213.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158213,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,60158213)
	e1:SetTarget(c60158213.e1tg)
	e1:SetOperation(c60158213.e1op)
	c:RegisterEffect(e1)
	
	--2xg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158213,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,6018213)
	e2:SetCondition(c60158213.e2con)
	e2:SetTarget(c60158213.e2tg)
	e2:SetOperation(c60158213.e2op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60158213,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,6018213)
	e3:SetCondition(c60158213.e2con)
	e3:SetTarget(c60158213.e2tg)
	e3:SetOperation(c60158213.e2op)
	c:RegisterEffect(e3)
	
end

	--1xg
function c60158213.e1tgf(c)
	return c:IsFaceup() and not c:IsCode(60158001)
end
function c60158213.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60158213.e1tgf,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c60158213.e1tgf,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	--Duel.SetChainLimit(c60158213.e1tglimit(g:GetFirst()))
end
function c60158213.e1tglimit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c60158213.e1opf(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(60158101)
end
function c60158213.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--[[
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		]]
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(60158213,2))
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(60158101)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local code=tc:GetCode()
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c60158213.e1opf),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,code)
		if Duel.GetTurnPlayer()==tp and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60158213,3)) then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158214,8))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60158213.lmlimit(e,c)
	if not c then return false end
	return not (c:IsCode(60158001) or c:IsCode(60158101))
end

	--2xg
function c60158213.e2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:GetHandler():IsCode(60158001)
end
function c60158213.e2tgf(c)
	return aux.IsCodeListed(c,60158001) and not c:IsCode(60158213) and (c:IsSSetable() or not c:IsForbidden())
		and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c60158213.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c60158213.e2tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158213,1))
end
function c60158213.e2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158213,6))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60158213.e2tgf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		local sc=g:GetFirst()
		if sc:IsSSetable() and not sc:IsForbidden() then 
			if Duel.SelectYesNo(tp,aux.Stringid(60158213,4)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				if sc:IsType(TYPE_FIELD) then
					Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				else
					Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			else
				Duel.SSet(tp,sc)
			end
		elseif sc:IsSSetable() and sc:IsForbidden() then
			Duel.SSet(tp,sc)
		elseif not sc:IsSSetable() and not sc:IsForbidden() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			if sc:IsType(TYPE_FIELD) then
				Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		else
			return false
		end
	end
end
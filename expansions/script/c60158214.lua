--格局打开
function c60158214.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	
	--1xg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60158214,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60158214)
	e1:SetTarget(c60158214.e1tg)
	e1:SetOperation(c60158214.e1op)
	c:RegisterEffect(e1)
	
	--2xg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60158214,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,6018214)
	e2:SetCondition(c60158214.e2con)
	e2:SetTarget(c60158214.e2tg)
	e2:SetOperation(c60158214.e2op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60158214,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,6018214)
	e3:SetCondition(c60158214.e2con)
	e3:SetTarget(c60158214.e2tg)
	e3:SetOperation(c60158214.e2op)
	c:RegisterEffect(e3)
end

	--1xg
function c60158214.e1tgf(c)
	return c:IsFaceup() and not c:IsCode(60158001)
end
function c60158214.e1tgc(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c60158214.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60158214.e1tgf,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	--[[
	if Duel.IsExistingMatchingCard(c60158214.e1tgc,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(60158214,7)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c60158214.e1tgc,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.SendtoGrave(g,REASON_COST)
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	end
	]]
end
function c60158214.e1opf(c)
	return c:IsCode(60158101) and c:IsFaceup()
end
function c60158214.e1opff(c,sg)
	return c:IsLinkSummonable(sg)
end
function c60158214.e1op(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetMatchingGroup(c60158214.e1tgf,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local km=pg:GetFirst()
	while km do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(60158214,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(60158101)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		km:RegisterEffect(e1)
		km=pg:GetNext()
	end
	
	local sg=Duel.GetMatchingGroup(c60158214.e1opf,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(c60158214.e1opff,tp,LOCATION_EXTRA,0,nil,sg)
	if sg2:GetCount()<=0 then return end
	if Duel.GetTurnPlayer()==tp and Duel.SelectYesNo(tp,aux.Stringid(60158214,10)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158214,9))
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c60158214.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60158214.e1opff,tp,LOCATION_EXTRA,0,1,1,nil,sg)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,sg)
		end
		
	end
end
function c60158214.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsCode(60158001,60158101) and c:IsLocation(LOCATION_EXTRA)
end

	--[[
	
function c60158214.e1opf(c,e,tp)
	local code=c:GetCode()
	return aux.IsCodeListed(c,60158001) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,TYPES_EFFECT_TRAP_MONSTER,1500,1500,2,RACE_MACHINE,ATTRIBUTE_WATER)
end

	local c=e:GetHandler()
	local zj=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)
	local zj2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
	if zj>=zj2 then return end
	local g=Duel.GetMatchingGroup(c60158214.e1opf,tp,LOCATION_DECK,0,nil,e,tp)
	if #g>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		local ft2=(zj2-zj)
		if ft2>=ft then ft2=ft end
		Duel.Hint(HINT_CARD,1-tp,60158214)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158214,8))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg2=g:SelectSubGroup(tp,aux.dncheck,false,ft2,ft2)
		local sc=tg2:GetFirst()
		while sc do
			if sc:IsType(TYPE_SPELL) then 
				sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500) 
			elseif sc:IsType(TYPE_TRAP) then
				sc:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP,ATTRIBUTE_WATER,RACE_MACHINE,2,1500,1500)
			else
				return false 
			end
			sc:CancelToGrave()
			Duel.SpecialSummon(sc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
			--
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(60158214,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(60158101)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			--cannot link material
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e2:SetValue(c60158214.e1ope2val)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			sc=tg2:GetNext()
		end
	end
function c60158214.e1ope2val(e,c)
	if not c then return false end
	return not (c:IsCode(60158001) or c:IsCode(60158101))
end
	
	]]

	--2xg
function c60158214.e2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:GetHandler():IsCode(60158001)
end
function c60158214.e2tgf(c)
	return aux.IsCodeListed(c,60158001) and not c:IsCode(60158214) and (c:IsSSetable() or not c:IsForbidden())
		and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c60158214.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c60158214.e2tgf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158214,2))
end
function c60158214.e2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60158213,6))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60158214.e2tgf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		local sc=g:GetFirst()
		if sc:IsSSetable() and not sc:IsForbidden() then 
			if Duel.SelectYesNo(tp,aux.Stringid(60158214,4)) then
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
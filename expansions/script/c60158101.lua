--静默的机偶
function c60158101.initial_effect(c)
	aux.AddCodeList(c,60158001,60158101)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),1)
	
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c60158101.lmlimit)
	c:RegisterEffect(e1)

	--1xg
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(60158101,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c60158101.spcon)
	e6:SetTarget(c60158101.sptg)
	e6:SetOperation(c60158101.spop)
	c:RegisterEffect(e6)
end
--link summon

--cannot link material

function c60158101.lmlimit(e,c)
	if not c then return false end
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) and not c:IsCode(60158001)
end


--1xg

function c60158101.spconf(c,tp)
	return c:IsSummonPlayer(tp) and (c:IsPreviousLocation(LOCATION_EXTRA) or c:IsPreviousLocation(LOCATION_DECK))
end
function c60158101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60158101.spconf,1,nil,1-tp)
end
function c60158101.spfilter(c,e,tp)
	return c:IsCode(60158101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c60158101.e2tgf(c,sg)
	return c:IsLinkSummonable(sg)
end
function c60158101.e2tgff(c)
	return c:IsCode(60158101) and c:IsFaceup()
end
function c60158101.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c60158101.e2tgff,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return (Duel.IsExistingMatchingCard(c60158101.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) or (sg:GetCount()>0 and Duel.IsExistingMatchingCard(c60158101.e2tgf,tp,LOCATION_EXTRA,0,1,nil,sg))) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60158101,1))
end
function c60158101.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c60158101.spfilter),tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp)
	local sg=Duel.GetMatchingGroup(c60158101.e2tgff,tp,LOCATION_MZONE,0,nil)
	local sg2=Duel.GetMatchingGroup(c60158101.e2tgf,tp,LOCATION_EXTRA,0,nil,sg)
	if #g>0 and #sg2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(60158101,2),aux.Stringid(60158101,3))
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=g:Select(tp,1,1,nil)
			local tc=g2:GetFirst()
			if tc:IsType(TYPE_LINK) then
				Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c60158101.e2tgf,tp,LOCATION_EXTRA,0,1,1,nil,sg)
			local tc=g2:GetFirst()
			if tc then
				Duel.LinkSummon(tp,tc,sg)
			end
		end
	elseif #g>0 and #sg2<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g:Select(tp,1,1,nil)
		local tc=g2:GetFirst()
		if tc:IsType(TYPE_LINK) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif #g<=0 and #sg2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c60158101.e2tgf,tp,LOCATION_EXTRA,0,1,1,nil,sg)
		local tc=g2:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,sg)
		end
	else
		return false
	end
	
		--[[
		
		local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c60158101.damcon)
			e1:SetValue(1)
			e1:SetOwnerPlayer(tp)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
			e2:SetCondition(c60158101.damcon2)
			tc:RegisterEffect(e2)
			--indes
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(c60158101.indval)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
			--immune
			local e4=e3:Clone()
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c60158101.immval)
			tc:RegisterEffect(e4,true)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60158101,5))
			
			
function c60158101.damcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c60158101.damcon2(e)
	return 1-e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c60158101.indval(e,c)
	return c:IsSummonLocation(LOCATION_EXTRA) or c:IsSummonLocation(LOCATION_GRAVE) or c:IsSummonLocation(LOCATION_REMOVED)
end
function c60158101.immval(e,te)
	local tc=te:GetOwner()
	return tc~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER)
		and te:GetActivateLocation()==LOCATION_MZONE and (tc:IsSummonLocation(LOCATION_EXTRA) or tc:IsSummonLocation(LOCATION_GRAVE) or tc:IsSummonLocation(LOCATION_REMOVED))
end

			]]
end
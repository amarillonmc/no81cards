--至高主宰·炎剠·炎之暴君
function c11182380.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6454),5,true)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c11182380.sprcon)
	e0:SetTarget(c11182380.sprtg)
	e0:SetOperation(c11182380.sprop)
	c:RegisterEffect(e0)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c11182380.reccon)
	e1:SetOperation(c11182380.recop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e11)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCountLimit(1,11182380)
	e2:SetTarget(c11182380.eqtg)
	e2:SetOperation(c11182380.eqop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c11182380.immunefilter)
	c:RegisterEffect(e3)
end
function c11182380.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
		and (te:GetHandler():IsAttribute(ATTRIBUTE_FIRE) or te:GetHandler():IsType(TYPE_FUSION)
			or te:GetHandlerPlayer()~=e:GetHandlerPlayer())
end
function c11182380.filter(c)
	return not c:IsForbidden()
end
function c11182380.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11182380.filter,tp,0x30,0x30,1,nil) end
end
function c11182380.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ch=Duel.GetCurrentChain()
	local ck=false
	if ch>1 then
		local code=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_CODE)
		if code==11182325 then ck=true end
	end
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsRelateToEffect(e) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c11182380.filter,tp,0x30,0x30,1,nil)
	local b2=ck and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(11182380,1)},{b2,aux.Stringid(11182380,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11182380.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if not Duel.Equip(tp,tc,c) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c11182380.eqlimit)
			tc:RegisterEffect(e1)
		end
	elseif op==2 then
		local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local rtc=sg:IsExists(Card.IsType,1,nil,TYPE_TOKEN) and Duel.IsPlayerCanRemove(tp)
		local ct=Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
		if ct==0 then return end
		local rg=sg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if not rtc and rg:GetCount()==0 then return end
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			--extra att
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(ct)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2)
		end
	end
end
function c11182380.eqlimit(e,c)
	return e:GetOwner()==c
end
function c11182380.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c11182380.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11182380.cfilter,1,nil,1-tp)
end
function c11182380.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11182380)
	Duel.Recover(tp,500,REASON_EFFECT)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c11182380.sprfilter(c)
	return (c:IsAbleToRemoveAsCost() or c:IsAbleToGraveAsCost()) and c:IsSetCard(0x6454)
end
function c11182380.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c11182380.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c11182380.sprfilter,tp,0xe,0,nil)
	return rg:CheckSubGroup(c11182380.fselect,2,2,tp)
end
function c11182380.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c11182380.sprfilter,tp,0xe,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c11182380.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11182380.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	while tc do
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_SPSUMMON)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_SPSUMMON)
		end
		tc=g:GetNext()
	end
	g:DeleteGroup()
end
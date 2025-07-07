--星间魔法少女队
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),nil,nil,s.matfilter1,1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.recop2)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetRange(0xff-LOCATION_MZONE)
		ge1:SetCondition(s.topcon)
		ge1:SetOperation(s.topop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end
end
function s.matfilter1(c)
	return c:GetOriginalType()&TYPE_SPELL~=0
end
function s.efilter(e,re)
	return not re:GetOwner():IsSetCard(0x854)
end
function s.cfilter(c)
	return c:IsCode(91300100)
end
function s.thfilter(c)
	return c:IsSetCard(0x854) and c:IsAbleToHand()
end
function s.topcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.topop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return end
	Duel.Hint(HINT_CARD,tp,c:GetCode())
	local g=Duel.GetMatchingGroup(s.cfilter,tp,0xff,0,nil)
	local sg=Duel.GetOverlayGroup(tp,1,1):Filter(Card.IsCode,nil,91300100)
	if #sg>0 then g:Merge(sg) end
	local sc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		sc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
	return not (c:IsCode(91300100) or c:GetOriginalType()&TYPE_SPELL>0 or c:GetLocation()==0) or c:IsType(TYPE_TOKEN)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and re:IsActiveType(TYPE_SPELL)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local rec=Duel.GetCurrentChain()*500
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	local ct=Duel.GetCurrentChain()
	if ct>3 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then
		local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_PZONE,0,nil)
		local tc=g:GetFirst()
		if tc then
			tc:SetMaterial(nil)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)>0 then
				tc:CompleteProcedure()
			end
		end
	end
end
function s.recop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(d)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local c=e:GetHandler()
	local ct=Duel.GetCurrentChain()
	if ct>2 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_DRAW)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(1,1)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
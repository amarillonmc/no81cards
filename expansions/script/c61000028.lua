--怪翎衣 百霞鸩羽
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcFunFunRep(c,s.mfilter,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),1,127,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.eqfilter)
	e2:SetCondition(s.actcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SUMMON_SUCCESS,g)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS,g)
end
function s.mfilter(c)
	return c:IsFusionSetCard(0x67c0) and c:IsFusionType(TYPE_FUSION)
end
function s.tgfilter(c,e,tp,chk)
	return c:IsSummonPlayer(1-tp)
		and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
		and (chk or Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,c,tp))
end
function s.cfilter(c,ec,tp)
	return c:IsFaceupEx() and c:IsRace(RACE_WINDBEAST)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetMaterialCount()
	if chkc then return eg:IsContains(chkc) and s.tgfilter(chkc,e,tp,true) end
	local g=eg:Filter(s.tgfilter,nil,e,tp,false)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():GetFlagEffect(id)<ct end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		local ec=sg:GetFirst()
		if ec then
			if Duel.Equip(tp,ec,tc) then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				ec:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_CANNOT_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e2)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				e3:SetValue(1000)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e3)
			end
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.actcon(e)
	return e:GetHandler():GetEquipTarget()
end
function s.eqcfilter(c)
	return bit.band(c:GetOriginalRace(),RACE_WINDBEAST)==RACE_WINDBEAST
		and bit.band(c:GetOriginalType(),TYPE_FUSION)==TYPE_FUSION
end
function s.eqfilter(e,c)
	return c:GetEquipGroup():IsExists(s.eqcfilter,1,nil)
end
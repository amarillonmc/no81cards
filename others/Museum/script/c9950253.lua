--欧布·疾风形态
function c9950253.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),3,3)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950253,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9950253.condition)
	e1:SetTarget(c9950253.target)
	e1:SetOperation(c9950253.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c9950253.mvalue)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_MAX_SZONE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(c9950253.svalue)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c9950253.aclimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c9950253.setlimit)
	c:RegisterEffect(e5)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c9950253.reptg)
	e5:SetValue(c9950253.repval)
	e5:SetOperation(c9950253.repop)
	c:RegisterEffect(e5)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950253.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950253.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950253,0))
end
function c9950253.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9950253.filter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c9950253.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9950253.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c9950253.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9950253.filter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
end
function c9950253.mvalue(e,fp,rp,r)
	if r~=LOCATION_REASON_TOFIELD then return 5 end
	return 2
end
function c9950253.svalue(e,fp,rp,r)
	if r~=LOCATION_REASON_TOFIELD then return 5 end
	local ct=2
	for i=5,7 do
		if Duel.GetFieldCard(fp,LOCATION_SZONE,i) then ct=ct-1 end
	end
	return ct
end
function c9950253.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	if re:IsActiveType(TYPE_FIELD) then
		return not Duel.GetFieldCard(tp,LOCATION_SZONE,5) and Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)>1
	elseif re:IsActiveType(TYPE_PENDULUM) then
		return Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)>1
	end
	return false
end
function c9950253.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and not Duel.GetFieldCard(tp,LOCATION_SZONE,5) and Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)>1
end
function c9950253.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsRace(RACE_WARRIOR) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:GetFlagEffect(9950253)==0
end
function c9950253.desfilter(c,e,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c9950253.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950253.desfilter,tp,0,LOCATION_MZONE,1,nil,e,tp)
		and eg:IsExists(c9950253.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(c9950253.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c9950253.desfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
		Duel.SetTargetCard(tg)
		tg:GetFirst():RegisterFlagEffect(9950253,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
		tg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c9950253.repval(e,c)
	return c==e:GetLabelObject()
end
function c9950253.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,9950253)
	local tc=Duel.GetFirstTarget()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end

--方舟骑士-稀音
--21.08.27
local cm,m=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--token
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetTarget(cm.immtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e4)
	--not immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.adjustop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(m)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
end
function cm.getsetcard(c)
	for i=0,0xfff do
		if c:IsOriginalSetCard(i) then
			for j=0xf,1,-1 do
				if c:IsOriginalSetCard(i+0x1000*j) then return i+0x1000*j end
			end
			return i
		end
	end
	return nil
end
function cm.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsType,nil,TYPE_TOKEN)
	local eid=e:GetFieldID()
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,eid)
	cm[eid]={}
	for tc in aux.Next(g) do
		table.insert(cm[eid],{tc:GetOriginalCode(),cm.getsetcard(tc),TYPES_TOKEN_MONSTER,math.max(0,tc:GetTextAttack()),math.max(0,tc:GetTextDefense()),tc:GetOriginalLevel(),tc:GetOriginalRace(),tc:GetOriginalAttribute()})
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,1-tp) and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lab=e:GetHandler():GetFlagEffectLabel(m)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not lab then return false end
		local tkset=cm[lab]
		for i=1,#tkset do
			if type(tkset[i])=="table" and Duel.IsPlayerCanSpecialSummonMonster(tp,table.unpack(tkset[i])) then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lab=e:GetHandler():GetFlagEffectLabel(m)
	local tkset=cm[lab]
	local spset={}
	for i=1,#tkset do
		if type(tkset[i])=="table" and Duel.IsPlayerCanSpecialSummonMonster(tp,table.unpack(tkset[i])) then
			table.insert(spset,tkset[i][1])
		end
	end
	if #spset==0 then return end
	while #spset>1 do
		local token=Duel.CreateToken(tp,spset[1])
		Duel.Hint(HINT_CARD,tp,spset[1])
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			spset={spset[1]}
		else
			table.remove(spset,1)
		end
	end
	local token=Duel.CreateToken(tp,spset[1])
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function cm.immtg(e,c)
	return c:IsType(TYPE_TOKEN)
end
function cm.nmfilter(c,e,tp)
	return c:GetColumnGroup():IsExists(cm.tkfilter,1,nil,tp) and (c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) or c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)) and not c:IsImmuneToEffect(e)
end
function cm.tkfilter(c,tp)
	return c:IsType(TYPE_TOKEN) and c:IsControler(tp)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.nmfilter,tp,0,LOCATION_ONFIELD,nil,e,tp)
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or #g==0 then return end
	local opt=0
	for tc in aux.Next(g) do
		local eset1={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)}
		local eset2={tc:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)}
		for _,te in pairs(eset1) do
			if te:IsHasType(EFFECT_TYPE_FIELD) then
				local tg=te:GetTarget() or aux.TRUE
				te:SetTarget(cm.chtg(tg,e))
				opt=1
			else
				local con=te:GetCondition() or aux.TRUE
				te:SetCondition(cm.chcon(con,e))
				opt=1
			end
		end
		for _,te in pairs(eset2) do
			if te:IsHasType(EFFECT_TYPE_FIELD) then
				local tg=te:GetTarget() or aux.TRUE
				te:SetTarget(cm.chtg(tg,e))
				opt=1
			else
				local con=te:GetCondition() or aux.TRUE
				te:SetCondition(cm.chcon(con,e))
				opt=1
			end
		end
	end
	if opt==1 then Duel.Readjust() end
end
function cm.chtg(_tg,ce)
	return function(e,c,...)
				if c:GetColumnGroup():IsExists(cm.tkfilter,1,nil,1-c:GetControler()) and Duel.IsPlayerAffectedByEffect(c:GetControler(),m) and not c:IsImmuneToEffect(ce) then return false end
				return _tg(e,c,...)
			end
end
function cm.chcon(_con,ce)
	return function(e,...)
				local tp=e:GetHandler():GetControler()
				if e:IsHasType(EFFECT_TYPE_EQUIP) then tp=e:GetHandler():GetEquipTarget():GetControler() end
				if e:GetHandler():GetColumnGroup():IsExists(cm.tkfilter,1,nil,1-tp) and Duel.IsPlayerAffectedByEffect(tp,m) and not e:GetHandler():IsImmuneToEffect(ce) then return false end
				return _con(e,...)
			end
end
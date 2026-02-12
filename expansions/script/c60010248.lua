--祸殃鱼
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.pkcon)
	e1:SetTarget(cm.pktg)
	e1:SetOperation(cm.pkop)
	c:RegisterEffect(e1)
	--re
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.atktg)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
end
function cm.pkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.pktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FISH,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.pkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_FISH,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,m+1)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
	--not immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetOperation(cm.adjustop)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(m)
	e6:SetTargetRange(1,1)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
function cm.nmfilter(c)
	return c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) or c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET) or c:IsHasEffect(EFFECT_INDESTRUCTABLE) or c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or c:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT) or c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET) or c:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET) or c:IsHasEffect(EFFECT_IMMUNE_EFFECT)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.nmfilter,tp,0xff,0xff,nil)
	local opt=0
	for tc in aux.Next(g) do
		local eset1={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)}
		local eset2={tc:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)}
		local eset3={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		local eset4={tc:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET)}
		local eset5={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)}
		local eset6={tc:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET)}
		local eset7={tc:IsHasEffect(EFFECT_INDESTRUCTABLE)}
		local eset8={tc:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
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
		for _,te in pairs(eset3) do
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
		for _,te in pairs(eset4) do
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
		for _,te in pairs(eset5) do
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
		for _,te in pairs(eset6) do
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
		for _,te in pairs(eset7) do
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
		for _,te in pairs(eset8) do
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
				if Duel.IsPlayerAffectedByEffect(c:GetControler(),m) then return false end
				return _tg(e,c,...)
			end
end
function cm.chcon(_con,ce)
	return function(e,...)
				local tp=e:GetHandler():GetControler()
				if e:IsHasType(EFFECT_TYPE_EQUIP) then tp=e:GetHandler():GetEquipTarget():GetControler() end
				if Duel.IsPlayerAffectedByEffect(tp,m) then return false end
				return _con(e,...)
			end
end
function cm.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,lg) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	if not Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,lg) then return end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,lg)
	if Duel.Release(g,REASON_EFFECT)~=0 then
		local atkup=Duel.GetOperatedGroup():GetFirst():GetBaseAttack()
		if atkup==0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atkup)
		e:GetHandler():RegisterEffect(e1)
	end
end
















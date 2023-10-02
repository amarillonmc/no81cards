--龙仪巧-射手流星＝SAG
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=11612632
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/11610000") end) then require("script/11610000") end
cm.text=zhc_lhq_ss
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e00=fpjdiy.Zhc(c,cm.text)
	--  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e13=e1:Clone()
	e13:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e13)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.matcon)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,m*2+1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCost(cm.decost)
	e4:SetTarget(cm.detg)
	e4:SetOperation(cm.deop)
	c:RegisterEffect(e4)
end
--0
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--
--1
function cm.atktg(e,c)
	return c:IsSetCard(0x154) and c~=e:GetHandler()
end
function cm.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*200
end
--2
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	--EVENT_CHAINING
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	--e1:SetLabel(ac)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetLabel(ac)
	e2:SetCondition(cm.drawcon)
	e2:SetOperation(cm.drawop)
	c:RegisterEffect(e2)
	--sp_summon effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(ac)
	e3:SetCondition(cm.drcon1)
	e3:SetOperation(cm.drop1)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
	--sp_summon effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(ac)
	e4:SetCondition(cm.regcon)
	e4:SetOperation(cm.regop)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabel(ac)
	e5:SetCondition(cm.drcon2)
	e5:SetOperation(cm.drop2)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.drawcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=e:GetLabel()
	return ep~=tp and re:GetHandler():IsCode(ac) and Duel.GetFlagEffect(tp,m)~=0
end
function cm.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--
function cm.filter(c,sp,ac)
	return c:IsSummonPlayer(sp) and c:IsCode(ac)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return eg:IsExists(cm.filter,1,nil,1-tp,ac)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return eg:IsExists(cm.filter,1,nil,1-tp,ac)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m*2+1,RESET_CHAIN,0,1)
	--Debug.Message('123')
end
--
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m*2+1)>0
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,m*2+1)
	Duel.ResetFlagEffect(tp,m*2+1)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--123
--03
function cm.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.costfilter(c,e,tp)
	local atk=c:GetAttack()
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0  and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,atk,tp)
end

function cm.filter2(c,e,atk,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x154) and c:GetBaseAttack()<=atk and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.spgck(g,e,tp,atk) 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and g:GetCount()>1 then return false end 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() and  g:GetSum(Card.GetAttack)<=atk
end 

function cm.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		e:SetLabel(0)
		return Duel.CheckReleaseGroupEx(tp,cm.costfilter,1,nil,e,tp)
	end
	local g=Duel.SelectReleaseGroupEx(tp,cm.costfilter,1,99,nil,e,tp)
	local atk=g:GetSum(Card.GetAttack)
	Duel.Release(g,REASON_COST)
	e:SetLabel(atk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function cm.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,atk,tp)
	if ft<=0  then return false end
	--if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=tg:SelectSubGroup(tp,cm.spgck,false,1,5,e,tp,atk) 
	local ct=0
	local sc=sg:GetFirst() 
	while sc do 
		Duel.SpecialSummon(sc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP_DEFENSE) 
		ct=ct+1
	sc=sg:GetNext() 
	end 
	Duel.BreakEffect()
	--if ct==0 or not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),1-tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,1-tp) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local loc=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ct<1 or loc<1 then return end
	if ct>loc then ct=loc end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	if ct>1 and Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ct=1 end
	--Debug.Message(ct)
	local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(cm.spfilter),1-tp,LOCATION_DECK+LOCATION_GRAVE,0,ct,ct,nil,e,1-tp)
	cm.sp(g,1-tp,POS_FACEUP)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sp(g,tp,pos)
	local sc=g:GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,pos)
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		sc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
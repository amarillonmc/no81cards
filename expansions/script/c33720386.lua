--[[动物朋友 孙薮猫
Anifriends SonServal
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableReviveLimit()
	aux.AddCodeList(c,CARD_MEMORIES_OF_THE_SANDSTAR)
	--"Anifriends Serval" + 1 monster Special Summoned from the Extra Deck
	aux.AddFusionProcCodeFun(c,CARD_ANIFRIENDS_SERVAL,s.mfilter,1,true,true)
	--This card's name becomes "Anifriends Serval" while in the GY.
	aux.EnableChangeCode(c,CARD_ANIFRIENDS_SERVAL,LOCATION_GRAVE)
	--You can send the above cards from either player's field to the GY; Special Summon this card from your Extra Deck.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetFunctions(nil,s.spcost,s.sptg,s.spop)
	c:RegisterEffect(e1)
	--If this card is Summoned: Send 1 "Memories of the Sandstar" from your hand or Deck to the GY, OR send this card to the GY.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TOGRAVE|CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetFunctions(nil,nil,s.tgtg,s.tgop)
	c:RegisterEffect(e2)
	e2:SpecialSummonEventClone(c)
	e2:FlipSummonEventClone(c)
	--At the start of the Battle Phase: You can take 1 Spell/Trap from your Deck or GY and Special Summon it as a Normal Monster. That monster always has the same Attribute, Type, Level, ATK and DEF as this card, also shuffle it into the Deck at the end of that Battle Phase.
	local e3=Effect.CreateEffect(c)
	e3:Desc(2,id)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE|PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:OPT()
	e3:SetFunctions(nil,nil,s.sptg2,s.spop2)
	c:RegisterEffect(e3)
end
function s.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonLocation(LOCATION_EXTRA)
end

--E1
function s.fmatfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function s.spchk(g,tp,fus)
	return fus:CheckFusionMaterial(g,nil,tp|0x200,true)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.Group(s.fmatfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	if chk==0 then
		return g:CheckSubGroup(s.spchk,2,2,tp,c)
	end
	local tg=Duel.SelectFusionMaterial(tp,c,g,nil,tp|0x200,true)
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_COST)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return e:IsCostChecked() or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--E2
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
	if c:IsRelateToChain() then
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	end
end
function s.tgfilter(c)
	return c:IsCode(CARD_MEMORIES_OF_THE_SANDSTAR) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExists(false,s.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil)
	local b2=c:IsRelateToChain() and c:IsAbleToGrave()
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,id,1,b1,b2)
	if opt==0 then
		local g=Duel.Select(HINTMSG_TOGRAVE,false,tp,s.tgfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	elseif opt==1 then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end

--E3
function s.spfilter(c,e,tp,atk,def,lv,race,attr)
	if not (c:IsType(TYPE_SPELL|TYPE_TRAP) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)) then return false end
	local setcode=Duel.ReadCard(c,CARDDATA_SETCODE)
	for _,code in ipairs({c:GetCode()}) do
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,code,setcode,TYPE_MONSTER|TYPE_NORMAL,atk,def,lv,race,attr) then
			return false
		end
	end
	return true
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local atk,def,lv,race,attr=c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute()
		return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp,atk,def,lv,race,attr)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsFaceup() then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE,0,1,fid)
	local atk,def,lv,race,attr=c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute()
	local tc=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp,atk,def,lv,race,attr):GetFirst()
	if tc then
		local resets=RESET_TOGRAVE|RESET_REMOVE|RESET_TEMP_REMOVE|RESET_TOHAND|RESET_TODECK|RESET_OVERLAY
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(TYPE_NORMAL|TYPE_MONSTER)
		e1:SetReset(RESET_EVENT|resets)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetCondition(s.adcon)
		e2:SetLabel(fid)
		e2:SetValue(s.raceval)
		tc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetLabelObject(e2)
		e3:SetValue(s.attrval)
		tc:RegisterEffect(e3,true)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetLabelObject(e3)
		e4:SetValue(s.lvval)
		tc:RegisterEffect(e4,true)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_SET_ATTACK_FINAL)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE,EFFECT_FLAG2_OPTION)
		e5:SetRange(LOCATION_MZONE)
		e5:SetValue(s.atkval)
		tc:RegisterEffect(e5,true)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e6:SetValue(s.defval)
		tc:RegisterEffect(e6,true)
		local e7=Effect.CreateEffect(tc)
		e7:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_ADJUST)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetLabel(fid)
		e7:SetLabelObject(e4)
		e7:SetOperation(s.efilter)
		e7:SetReset(RESET_EVENT|resets)
		tc:RegisterEffect(e7,true)
		local e8=Effect.CreateEffect(tc)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_SELF_TOGRAVE)
		e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e8:SetRange(LOCATION_MZONE)
		e8:SetCondition(s.sdcon)
		e8:SetReset(RESET_EVENT|resets)
		tc:RegisterEffect(e8,true)
		tc:RegisterFlagEffect(id,RESET_EVENT|resets|RESET_PHASE|PHASE_BATTLE,0,1,fid)
	end
	if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		tc:SetCardTarget(c)
		local de=Effect.CreateEffect(c)
		de:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		de:SetCode(EVENT_PHASE|PHASE_BATTLE)
		de:SetReset(RESET_PHASE|PHASE_BATTLE)
		de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		de:SetCountLimit(1)
		de:SetLabel(fid)
		de:SetLabelObject(tc)
		de:SetCondition(s.tdcon)
		de:SetOperation(s.tdop)
		Duel.RegisterEffect(de,tp)
	end
	Duel.SpecialSummonComplete()
end
function s.adcon(e)
	local c=e:GetHandler():GetFirstCardTarget()
	return c~=nil and c:HasFlagEffectLabel(id+100,e:GetLabel())
end
function s.attrval(e,c)
	return e:GetHandler():GetFirstCardTarget():GetAttribute()
end
function s.raceval(e,c)
	return e:GetHandler():GetFirstCardTarget():GetRace()
end
function s.lvval(e,c)
	return e:GetHandler():GetFirstCardTarget():GetLevel()
end
function s.atkval(e,c)
	return e:GetHandler():GetFirstCardTarget():GetAttack()
end
function s.defval(e,c)
	return e:GetHandler():GetFirstCardTarget():GetDefense()
end
function s.efilter(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local c=tc:GetFirstCardTarget()
	if c and c:HasFlagEffectLabel(id+100,e:GetLabel()) then
		local le=e:GetLabelObject()
		local ae=le:GetLabelObject()
		local re=ae:GetLabelObject()
		local le_new,ae_new,re_new
		if tc:GetRace()~=c:GetRace() then
			re_new=re:Clone()
			tc:RegisterEffect(re_new,true)
			re:Reset()
		end
		if tc:GetAttribute()~=c:GetAttribute() then
			ae_new=ae:Clone()
			tc:RegisterEffect(ae_new,true)
			ae:Reset()
		end
		if tc:GetLevel()~=c:GetLevel() then
			le_new=le:Clone()
			tc:RegisterEffect(le_new,true)
			le:Reset()
		end
		if le_new then e:SetLabelObject(le_new) end
		if ae_new then
			if le_new then
				le_new:SetLabelObject(ae_new)
			else
				le:SetLabelObject(ae_new)
			end
		end
		if re_new then
			if ae_new then
				ae_new:SetLabelObject(re_new)
			else
				ae:SetLabelObject(re_new)
			end
		end
	else
		tc:SetStatus(STATUS_NO_LEVEL,true)
		e:Reset()
	end
end
function s.sdcon(e)
	local tc=e:GetHandler()
	if not tc:HasFlagEffectLabel(id) then return false end
	local c=tc:GetFirstCardTarget()
	return not c or not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup()
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if not tc or not tc:HasFlagEffectLabel(id,fid) then
		e:Reset()
		return false
	end
	return true
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ShuffleIntoDeck(tc)
end
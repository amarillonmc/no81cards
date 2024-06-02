--[[
永劫心锁
Semper Clausa
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--If you control other cards in your Spell & Trap Zone, send this card to the GY.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_SELF_TOGRAVE)
	e0:SetCondition(s.sdcon)
	c:RegisterEffect(e0)
	--[[Declare 1 Monster Card name that was sent to the GY this turn. While you control this face-up card, the name, Attribute, Type, Level/Rank, ATK,
	and DEF of all monsters you control become the same ones as the card that has the declared name as original name, also replace their effects with the effects of that card (if any).]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--[[If this card is destroyed: Special Summon any number of "Spatium Vacua" (Level 1) to either player's field.
	These Tokens' Attribute, Type, ATK and DEF are the same as the card that has the declared name as original name, but they cannot be used as a material for a Special Summon from the Extra Deck. 
	Each time a "Spatium Vacua" is destroyed, you take 2000 damage.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORIES_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetLabelObject(e2)
	e3:SetOperation(s.setlabel)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s.check=false
		s.valid_names={}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetCountLimit(1)
		ge2:SetCondition(s.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		ge3:SetOperation(s.createtoken)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local codes={tc:GetCode()}
		for _,code in ipairs(codes) do
			s.valid_names[code]=true
			if not s.check then
				s.check=true
			end
		end
	end
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	for k,v in pairs(s.valid_names) do
	  s.valid_names[k]=nil
	end
	s.check=false
end
function s.createtoken(e)
	s.GlobalToken=Duel.CreateToken(0,0)
	e:Reset()
end

--E0
function s.sdcon(e)
	return Duel.GetMatchingGroupCount(Card.IsInBackrow,e:GetHandlerPlayer(),LOCATION_SZONE,0,e:GetHandler())>0
end

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.check end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.announce_filter={}
	local insertOR=false
	for code,check in pairs(s.valid_names) do
		if check then
			table.insert(s.announce_filter,code)
			table.insert(s.announce_filter,OPCODE_ISCODE)
			table.insert(s.announce_filter,TYPE_MONSTER)
			table.insert(s.announce_filter,OPCODE_ISTYPE)
			table.insert(s.announce_filter,OPCODE_AND)
			if not insertOR then
				insertOR=true
			else
				table.insert(s.announce_filter,OPCODE_OR)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(s.announce_filter))
	c:SetHint(CHINT_CARD,ac)
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0,ac)
	c:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD,0,0,fid)
	s.GlobalToken:SetEntityCode(ac,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(ac)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	c:RegisterEffect(e1)
	local attr=s.GlobalToken:GetOriginalAttribute()
	if attr~=0 then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(attr)
		c:RegisterEffect(e2)
	end
	local race=s.GlobalToken:GetOriginalRace()
	if race~=0 then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(race)
		c:RegisterEffect(e2)
	end
	local rating,rtype=s.GlobalToken:GetOriginalRatingAuto()
	if rating~=0 then
		local ecode=rtype==TYPE_XYZ and EFFECT_CHANGE_RANK or EFFECT_CHANGE_LEVEL
		local e2=e1:Clone()
		e2:SetCode(ecode)
		e2:SetValue(rating)
		c:RegisterEffect(e2)
	end
	if s.GlobalToken:HasAttack() then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(s.GlobalToken:GetTextAttack())
		c:RegisterEffect(e2)
	end
	if s.GlobalToken:HasDefense() then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(s.GlobalToken:GetTextDefense())
		c:RegisterEffect(e2)
	end
	if s.GlobalToken:IsType(TYPE_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_SZONE)
		e1:SetLabel(ac,fid)
		e1:SetOperation(s.replaceop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

function s.replaceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code,fid=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	g:Remove(Card.HasFlagEffectLabel,nil,id+200,fid)
	if #g<=0 or c:IsDisabled() then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id+200,RESET_EVENT|RESETS_STANDARD,0,0,fid)
		local cid=tc:ReplaceEffect(code,RESET_EVENT|RESETS_STANDARD,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabel(cid,fid)
		e1:SetLabelObject(e0)
		e1:SetOperation(s.resetop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local h=e:GetOwner()
	local cid,fid=e:GetLabel()
	if not h:HasFlagEffectLabel(id+100,fid) or h:IsDisabled() then
		c:ResetEffect(cid,RESET_COPY)
		for _,fe in ipairs({c:IsHasEffect((id+200)|EFFECT_FLAG_EFFECT)}) do
			if fe:GetLabel()==fid then
				fe:Reset()
			end
		end
		e:Reset()
	end
end

--E2
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetLabel()
	if chk==0 then
		return code~=0 and e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
	end
	Duel.SetTargetParam(code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetTargetParam()
	if not code then return end
	local ftab={[tp+1]=Duel.GetMZoneCount(tp);[2-tp]=Duel.GetMZoneCount(1-tp,nil,tp)}
	local ft=Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and 1 or ftab[tp+1]+ftab[2-tp]
	if ft<=0 then return end
	s.GlobalToken:SetEntityCode(code,true)
	local c=e:GetHandler()
	local attr,race,atk,def=s.GlobalToken:GetOriginalAttribute(),s.GlobalToken:GetOriginalRace(),s.GlobalToken:GetTextAttack(),s.GlobalToken:GetTextDefense()
	local ok=0
	while ok>=0 and ok<13 do
		local breakchk=true
		local checks={false,false}
		for p=tp,1-tp,1-2*tp do
			if Duel.IsPlayerCanSpecialSummonMonster(tp,33720082,0,TYPES_TOKEN_MONSTER,atk,def,1,race,attr,POS_FACEUP,p) and ftab[p+1]>0 then
				checks[p+1]=true
				if breakchk then
					breakchk=false
				end
			end
		end
		if breakchk or (not breakchk and ok>0 and not Duel.SelectYesNo(tp,aux.Stringid(id,4))) then
			break
		end
		local opt=aux.Option(tp,id,2,checks[tp+1],checks[2-tp])
		local fieldp=opt==0 and tp or 1-tp
		local token=Duel.CreateToken(tp,33720082)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		token:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(race)
		token:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e4:SetValue(attr)
		token:RegisterEffect(e4,true)
		if Duel.SpecialSummonStep(token,0,tp,fieldp,false,false,POS_FACEUP) then
			ok=ok+1
			aux.CannotBeEDMaterial(token,nil,nil,nil,RESET_EVENT|RESETS_STANDARD,c,nil,false,true)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetCode(EVENT_LEAVE_FIELD)
			e5:SetLabel(tp)
			e5:SetOperation(s.damop)
			token:RegisterEffect(e5,true)
		end
		ftab[tp+1]=Duel.GetMZoneCount(tp)
		ftab[2-tp]=Duel.GetMZoneCount(1-tp,nil,tp)
	end
	Duel.SpecialSummonComplete()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(e:GetLabel(),2000,REASON_EFFECT)
	end
	e:Reset()
end

--E3
function s.setlabel(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if not c:HasFlagEffect(id) then
		se:SetLabel(0)
	else
		se:SetLabel(c:GetFlagEffectLabel(id))
	end
end
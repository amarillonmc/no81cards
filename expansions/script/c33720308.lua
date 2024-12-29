--[[天使之梦↗绝体绝命810！
BranD-810!'s Angel Dream
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
Duel.LoadScript("glitchylib_lprecover.lua")

local FLAG_DELAYED_EVENT = id
local FLAG_SIMULT_CHECK = id+100
local PFLAG_REPLACING_DAMAGE = id
local PFLAG_STORED_DAMAGE = id+100

function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id+200
	else
		s.progressive_id=s.progressive_id+1
	end
	c:EnableReviveLimit()
	--You can only control 1 face-up "BranD-810!'s Angel Dream".
	c:SetUniqueOnField(1,0,id)
	--[[If you would take damage from a "BranD-810!" card's effect (max. 2950), you can make that damage become 0, then Special Summon this card
	from your Extra Deck, and if you do, this card's ATK becomes equal to the damage you would have taken]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REPLACE_DAMAGE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	c:RegisterEffect(e1)
	--[[If another "BranD-810!" monster(s) is destroyed by your opponent: You can Special Summon that monster(s) from your GY, and if you do,
	you take damage equal to the total DEF of those monsters during the next Standby Phase (even if this card is no longer on the field.)]]
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,EVENT_TO_GRAVE,s.cfilter,FLAG_DELAYED_EVENT,LOCATION_MZONE,nil,LOCATION_MZONE,nil,FLAG_SIMULT_CHECK)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CUSTOM+s.progressive_id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(
		nil,
		nil,
		s.sptg,
		s.spop
	)
	c:RegisterEffect(e2)
end

function s.damval(e,re,val,r,rp,rc)
	if not re or (aux.DamageReplacementEffectAlreadyUsed[e]~=nil or (aux.IsReplacedDamage and aux.DamageReplacementEffectWasApplied)) then return val end
	local rec=re:GetHandler()
	if val>0 and val<=2950 and r&REASON_EFFECT>0 and rec and rec:IsSetCard(ARCHE_BRAND_810) then
		aux.IsReplacedDamage=true
		aux.DamageReplacementEffectAlreadyUsed[e]=true
		local c=e:GetHandler()
		local tp=e:GetHandlerPlayer()
		local fid=c:GetFieldID()
		Duel.RegisterFlagEffect(tp,PFLAG_REPLACING_DAMAGE,0,0,0,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CUSTOM+id)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,val)
		e1:SetCondition(s.damrepcon)
		e1:SetOperation(s.damrepop)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.IgnoreActionCheck(Duel.RaiseEvent,rec,EVENT_CUSTOM+id,re,r,rp,tp,val)
		return 0
	else
		return val
	end
end
function s.damrepcon(e,tp,eg,ep,ev,re,r,rp)
   return Duel.PlayerHasFlagEffectLabel(tp,PFLAG_REPLACING_DAMAGE,e:GetSpecificLabel(1))
end
function s.damrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=s.damrep(e,tp,e:GetSpecificLabel(2))
	aux.DamageReplacementEffectWasApplied=res
	Duel.ResetFlagEffect(tp,PFLAG_REPLACING_DAMAGE)
end
function s.damrep(e,tp,val)
	local c=e:GetHandler()
	if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.SpecialSummonATKDEF(e,c,0,tp,tp,false,false,POS_FACEUP,nil,val)
		return true
	end
	return false
end

--E2
function s.cfilter(c,e,tp,_,_,_,_,_,_,obj)
	return c:GetReasonPlayer()==1-tp and c:IsReason(REASON_DESTROY) and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsMonster() and c:IsSetCard(ARCHE_BRAND_810)
		and aux.AlreadyInRangeFilter(nil,nil,obj)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	local ct=#g
	if chk==0 then
		return ct>0 and Duel.GetMZoneCount(tp)>=ct
			and (ct<2 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
	end
	local sg=aux.SelectSimultaneousEventGroup(g,tp,FLAG_SIMULT_CHECK,1,e,id+200)
	Duel.SetTargetCard(sg)
	Duel.SetCardOperationInfo(sg,CATEGORY_SPECIAL_SUMMON)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards()
	if #g==0 or (#g>=2 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			sg:AddCard(tc)
		end
	end
	if Duel.SpecialSummonComplete()>0 then
		sg=sg:Filter(Card.IsFaceup,nil)
		if #sg>0 then
			local val=sg:GetSum(Card.GetDefense)
			if val>0 then
				local c=e:GetHandler()
				local tct=Duel.GetTurnCount()
				local spchk=Duel.GetCurrentPhase()>PHASE_STANDBY and 1 or 0
				local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_STORED_DAMAGE,tct+spchk)
				if not fe then
					local rct=Duel.GetNextPhaseCount(PHASE_STANDBY)
					fe=Effect.CreateEffect(c)
					fe:SetType(EFFECT_TYPE_FIELD)
					fe:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					fe:SetCode(EFFECT_FLAG_EFFECT|PFLAG_STORED_DAMAGE)
					fe:SetTargetRange(1,0)
					fe:SetLabel(tct+spchk,val)
					fe:SetReset(RESET_PHASE|PHASE_STANDBY,rct)
					Duel.RegisterEffect(fe,tp)
					local e3=Effect.CreateEffect(c)
					e3:SetDescription(aux.Stringid(id,3))
					e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
					e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
					e3:SetLabel(tct+spchk)
					e3:SetCountLimit(999)
					e3:SetFunctions(s.damcon2,nil,nil,s.damop2)
					e3:SetReset(RESET_PHASE|PHASE_STANDBY,rct)
					Duel.RegisterEffect(e3,tp)
				else
					fe:SetSpecificLabel(val,0)
				end
			end
		end
	end
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tct=Duel.GetTurnCount()
	local tgoal=e:GetLabel()
	if tct~=tgoal then
		return false
	end
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_STORED_DAMAGE,tct)
	local labels={fe:GetLabel()}
	if #labels<2 then
		e:Reset()
		return false
	end
	return true
end
function s.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	local tct=Duel.GetTurnCount()
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_STORED_DAMAGE,tct)
	local labels={fe:GetLabel()}
	local vals={fe:GetLabel()}
	table.remove(vals,1)
	local val
	if #vals==1 then
		val=vals[1]
	else
		Duel.HintMessage(tp,aux.Stringid(id,4))
		val=Duel.AnnounceNumber(tp,table.unpack(vals))
	end
	for i,label in ipairs(labels) do
		if label==val then
			table.remove(labels,i)
			break
		end
	end
	fe:SetLabel(table.unpack(labels))
	Duel.Damage(tp,val,REASON_EFFECT)
end
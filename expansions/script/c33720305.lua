--[[珠算专员→绝体绝命810！
Soroban, Adept of BranD-810!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--(Quick Effect): You can discard this card; inflict 100 damage to both players
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:HOPT()
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(aux.DiscardSelfCost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--[[If this card is sent to the GY: Activate this effect; you take no damage until the Xth Standby Phase after this effect resolves,
	also apply the following effect during the Xth End Phase after this effect resolves. (X is the total number of "BranD-810" monsters destroyed
	by your opponent this turn up to the point this effect resolves. If X is 0 or less, this effect applies during the End Phase of this turn, instead).
	● You take damage equal to the total damage you would have taken had this card's effect not been applied.]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:HOPT()
	e2:SetOperation(s.applyop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

local PFLAG_COUNT_DESTROYED_CARDS = id
local PFLAG_STORED_DAMAGE = id+100

function s.regcfilter(c,p)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsReasonPlayer(p)
		and (c:IsPreviousLocation(LOCATION_MZONE) or (not c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsMonster()))
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ct=eg:FilterCount(s.regcfilter,nil,p)
		if ct>0 then
			if not Duel.PlayerHasFlagEffect(p,PFLAG_COUNT_DESTROYED_CARDS) then
				Duel.RegisterFlagEffect(p,PFLAG_COUNT_DESTROYED_CARDS,RESET_PHASE|PHASE_END,0,1,0)
			end
			Duel.UpdateFlagEffectLabel(p,PFLAG_COUNT_DESTROYED_CARDS,ct)
		end
	end
end

--E1
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,100)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	for p in aux.TurnPlayers() do
		Duel.Damage(p,d,REASON_EFFECT,true)
	end
	Duel.RDComplete()
end

--E2
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.PlayerHasFlagEffect(1-tp,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(1-tp,PFLAG_COUNT_DESTROYED_CARDS) or 0
	if x==0 then return end
	local c=e:GetHandler()
	local tct=Duel.GetTurnCount()
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_STORED_DAMAGE,tct+x-1)
	if not fe then
		fe=Effect.CreateEffect(c)
		fe:SetType(EFFECT_TYPE_FIELD)
		fe:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		fe:SetCode(EFFECT_FLAG_EFFECT|PFLAG_STORED_DAMAGE)
		fe:SetTargetRange(1,0)
		fe:SetLabel(tct+x-1,0)
		fe:SetReset(RESET_PHASE|PHASE_END,x)
		Duel.RegisterEffect(fe,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,3))
		e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE|PHASE_END)
		e3:SetLabel(tct+x-1)
		e3:SetCountLimit(999)
		e3:SetFunctions(s.damcon2,nil,nil,s.damop2)
		e3:SetReset(RESET_PHASE|PHASE_END,x)
		Duel.RegisterEffect(e3,tp)
	else
		fe:SetSpecificLabel(0,0)
	end
	local pos=fe:GetLabelCount()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REPLACE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetLabel(pos)
	e1:SetLabelObject(fe)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE|PHASE_STANDBY,x)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function s.damval(e,re,val,r,rp,rc)
	if re and re:GetOwner()==e:GetHandler() then
		return val
	else
		local tp=e:GetHandlerPlayer()
		local pos=e:GetLabel()
		local fe=e:GetLabelObject()
		if fe and aux.GetValueType(fe)=="Effect" then
			local oldval=fe:GetSpecificLabel(pos)
			local updated_stored_damage=oldval+val
			fe:SetSpecificLabel(updated_stored_damage,pos)
		end
		return 0
	end
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tct=Duel.GetTurnCount()
	local tgoal=e:GetLabel()
	if tct~=tgoal then
		c:SetTurnCounter(math.abs(tgoal-tct))
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
--[[
【背景音台】别有用心（重制版）
Ulterior Motives - Restored
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
if not TYPE_SOUNDSTAGE then
	Duel.LoadScript("glitchylib_soundstage.lua")
end
function s.initial_effect(c)
	aux.AddSoundStageProc(c,c:Activation(),id,4,0)
	--[[At the start of each End Phase: Activate this effect; the turn player's opponent can declare up to 5 card names. If they do not, the turn player draws 2 cards.
	Also, if card names were declared by this card's effect on the previous turn, and if the effects of those cards, and of no other cards, were successfully activated this turn by the player
	who declared them, that player can draw cards equal to the number of cards declared the previous turn. Otherwise, they take 1000 damage for each card they declared the previous turn.]]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE_START|PHASE_END)
	e0:SetRange(LOCATION_FZONE)
	e0:SetOperation(s.raiseev)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_ANNOUNCE|CATEGORY_DRAW|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_FZONE)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetLabelObject(e1)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
end

local FLAG_DECLARED_NAMES_SELF			= id
local FLAG_DECLARED_NAMES_OPPO			= id+100
local FLAG_BROKE_ACTIVATION_OATH		= id+200
local FLAG_TRACK_ACTIVATED_CODES		= id+300

function s.raiseev(e,tp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,tp,tp,0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local p=Duel.GetTurnPlayer()
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,p,2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer()
	local flag1=p==tp and FLAG_DECLARED_NAMES_SELF or FLAG_DECLARED_NAMES_OPPO
	local flag2=p==tp and FLAG_DECLARED_NAMES_OPPO or FLAG_DECLARED_NAMES_SELF
	if Duel.SelectYesNo(1-p,aux.Stringid(id,1)) then
		for i=1,5 do
			if i==1 then
				if s.announce_filter then
					aux.ClearTable(s.announce_filter)
				else
					s.announce_filter={}
				end
			end
			Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_CODE)
			local code=i==1 and Duel.AnnounceCard(1-p) or Duel.AnnounceCard(1-p,table.unpack(s.announce_filter))
			table.insert(s.announce_filter,code)
			table.insert(s.announce_filter,OPCODE_ISCODE)
			table.insert(s.announce_filter,OPCODE_NOT)
			if i>1 then
				table.insert(s.announce_filter,OPCODE_AND)
			end
			if not c:HasFlagEffect(flag2) then
				local fe=Effect.CreateEffect(c)
				fe:SetType(EFFECT_TYPE_SINGLE)
				fe:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				fe:SetCode(EFFECT_FLAG_EFFECT|flag2)
				fe:SetLabel(code)
				fe:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,2)
				c:RegisterEffect(fe,true)
			else
				local fe=c:IsHasEffect(EFFECT_FLAG_EFFECT|flag2)
				fe:SetSpecificLabel(code,i)
			end
			if i<5 and not Duel.SelectYesNo(1-p,aux.Stringid(id,2)) then
				break
			end
		end
	else
		Duel.Draw(p,2,REASON_EFFECT)
	end
	
	local fe=c:IsHasEffect(EFFECT_FLAG_EFFECT|flag1)
	if fe then
		local labels={fe:GetLabel()}
		local ct=#labels
		local te=c:IsHasEffect(EFFECT_FLAG_EFFECT|FLAG_TRACK_ACTIVATED_CODES)
		if te and not c:HasFlagEffect(FLAG_BROKE_ACTIVATION_OATH) then
			local tracked_codes={te:GetLabel()}
			if #tracked_codes==ct then
				if Duel.IsPlayerCanDraw(p,ct) and Duel.SelectYesNo(p,aux.Stringid(id,3)) then
					Duel.Draw(p,ct,REASON_EFFECT)
				end
				return
			end
		end
		Duel.Damage(p,ct*1000,REASON_EFFECT)
	end
end

--E2
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():HasFlagEffect(FLAG_BROKE_ACTIVATION_OATH) and re~=e:GetLabelObject() and Duel.GetTurnPlayer()==ep
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag1=ep==tp and FLAG_DECLARED_NAMES_SELF or FLAG_DECLARED_NAMES_OPPO
	local fe=c:IsHasEffect(EFFECT_FLAG_EFFECT|flag1)
	if fe then
		local check=false
		local labels={fe:GetLabel()}
		local actcode1,actcode2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
		for _,code in ipairs(labels) do
			if actcode1==code or (actcode2~=0 and actcode2==code) then
				check=true
				if not c:HasFlagEffect(FLAG_TRACK_ACTIVATED_CODES) then
					local fe=Effect.CreateEffect(c)
					fe:SetType(EFFECT_TYPE_SINGLE)
					fe:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					fe:SetCode(EFFECT_FLAG_EFFECT|FLAG_TRACK_ACTIVATED_CODES)
					fe:SetLabel(code)
					fe:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,2)
					c:RegisterEffect(fe,true)
				else
					local fe=c:IsHasEffect(EFFECT_FLAG_EFFECT|FLAG_TRACK_ACTIVATED_CODES)
					local labels={fe:GetLabel()}
					if not aux.FindInTable(labels,code) then
						fe:SetSpecificLabel(code,#labels+1)
					end
				end
			end
		end
		if not check then
			c:RegisterFlagEffect(FLAG_BROKE_ACTIVATION_OATH,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,2)
		end
	end
end
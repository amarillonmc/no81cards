--[[
这不断回转舞动的世界
Dancing, Revolving World
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--[[Target 1 monster you control that has a higher ATK/DEF than its original ATK/DEF, and that you did not target with the effect of "Dancing, Revolving World" this turn;
	gain LP equal to the sum of the differences between its current ATK/DEF and its original ATK/DEF.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetFunctions(nil,nil,s.lptg,s.lpop)
	c:RegisterEffect(e1)
	--If you gain LP: You can make all monsters you currently control gain ATK/DEF equal to that amount.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORIES_ATKDEF)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_FZONE)
	e2:SetLabelObject(aux.AddThisCardInFZoneAlreadyCheck(c))
	e2:SetFunctions(s.atkcon,nil,s.atktg,s.atkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end

local FLAG_TRACK_APPLIED_EFFECT			= id
local FLAG_ALREADY_TARGETED_THIS_TURN	= id+100
local FLAG_TRACK_RECOVER				= id+200

--E1
function s.lpfilter(c)
	return c:IsFaceup() and (c:IsAttackAbove(c:GetBaseAttack()+1) or (c:HasDefense() and c:IsDefenseAbove(c:GetBaseDefense()+1))) and not c:HasFlagEffect(FLAG_ALREADY_TARGETED_THIS_TURN)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and s.lpfilter(chkc) end
	if chk==0 then
		return not Duel.PlayerHasFlagEffectLabel(0,FLAG_TRACK_APPLIED_EFFECT,1) and Duel.IsExists(true,s.lpfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.RegisterFlagEffect(0,FLAG_TRACK_APPLIED_EFFECT,RESET_PHASE|PHASE_END,0,1,0)
	local tc=Duel.Select(HINTMSG_FACEUP,true,tp,s.lpfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	tc:RegisterFlagEffect(FLAG_ALREADY_TARGETED_THIS_TURN,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	Duel.SetTargetPlayer(tp)
	local atk=tc:GetAttack()-tc:GetBaseAttack()
	local def=tc:HasDefense() and tc:GetDefense()-tc:GetBaseDefense() or 0
	local val=atk+def
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() and (tc:IsAttackAbove(tc:GetBaseAttack()+1) or (tc:HasDefense() and tc:IsDefenseAbove(tc:GetBaseDefense()+1))) then
		local p=Duel.GetTargetPlayer()
		local atk=tc:GetAttack()-tc:GetBaseAttack()
		local def=tc:HasDefense() and tc:GetDefense()-tc:GetBaseDefense() or 0
		local val=atk+def
		if val>0 then
			Duel.Recover(p,val,REASON_EFFECT)
		end
	end
end

--E2
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==ep and aux.AlreadyInRangeCondition(e,re)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		local c=e:GetHandler()
		local labelset={c:GetFlagEffectLabel(FLAG_TRACK_RECOVER)}
		local validlabels={}
		for _,label in ipairs(labelset) do
			local p,val=label>>16,label&0xffff
			if p==ep then
				table.insert(validlabels,val)
			end
		end
		if #validlabels>0 then
			e:SetLabel(table.unpack(validlabels))
			c:ResetFlagEffect(FLAG_TRACK_RECOVER)
		else
			return false
		end
		return ep==tp and not Duel.PlayerHasFlagEffectLabel(0,FLAG_TRACK_APPLIED_EFFECT,0) and #g>0
	end
	Duel.RegisterFlagEffect(0,FLAG_TRACK_APPLIED_EFFECT,RESET_PHASE|PHASE_END,0,1,1)
	local val=0
	local valset={e:GetLabel()}
	if #valset==1 then
		val=valset[1]
	else
		for i=#valset,2,-1 do
			if #valset<2 then break end
			local temp_val=valset[i]
			for j=#valset-1,1,-1 do
				if valset[j]==temp_val then
					table.remove(valset)
					break
				end
			end
		end
		val=#valset==1 and valset[1] or Duel.AnnounceNumber(tp,table.unpack(valset))
	end
	Duel.SetTargetParam(val)
	Duel.SetCustomOperationInfo(0,CATEGORIES_ATKDEF,g,#g,0,0,val)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=Duel.GetTargetParam()
	local g=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		tc:UpdateATKDEF(val,val,true,{c,true})
	end
end

--E3
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(FLAG_TRACK_RECOVER,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,0,((ep<<16)|ev)&0x7fffffff)
end
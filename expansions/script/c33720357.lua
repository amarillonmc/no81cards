--[[
多彩战斗！
Colorful Battle!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_soundstage.lua")
function s.initial_effect(c)
	c:Activation()
	--There can be only 1 "Colorful Battle!" on the field.
	c:SetUniqueOnField(1,1,id)
	--Unaffected by other card effects if a Sound Stage Card is on the field.
	c:Unaffected(UNAFFECTED_OTHER,s.imcon)
	--[[Each time exactly 1 Sound Stage Card is sent to the GY by its own effect: The opponent of its previous controller can activate 1 Sound Stage Card directly from their Deck. If they do not, then
	the other player can activate 1 Sound Stage Card directly from their Deck instead. If a Sound Stage Card with the same name as the card sent to the GY is activated this way, its controller takes
	3000 damage after this effect resolves.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SOUNDSTAGE_CONTRACT_EXPIRED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(aux.AddThisCardInFZoneAlreadyCheck(c))
	e1:SetFunctions(aux.AlreadyInRangeEventCondition(s.cfilter),nil,s.target,s.operation)
	c:RegisterEffect(e1)
end

function s.imcon(e)
	return Duel.IsExists(false,aux.FaceupFilter(Card.IsType,TYPE_SOUNDSTAGE),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

--E1
function s.filter(c,tp)
	return c:IsType(TYPE_SOUNDSTAGE) and c:IsDirectlyActivatable(tp)
end
function s.cfilter(c)
	return c:IsType(TYPE_SOUNDSTAGE) and c:IsLocation(LOCATION_GRAVE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	Duel.SetTargetParam(tc:GetPreviousControler())
	local ch=Duel.GetCurrentChain()
	local fe=Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	fe:SetLabel(ch,tc:GetCode())
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_EITHER,3000)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,id,Duel.GetCurrentChain())
	local labels={fe:GetLabel()}
	table.remove(labels,1)
	local prev=Duel.GetTargetParam()
	for p = 1-prev, prev, 2*prev-1 do
		local g=Duel.Group(s.filter,p,LOCATION_DECK,0,nil,p)
		if #g>0 and Duel.SelectYesNo(p,aux.Stringid(id,1)) then
			Duel.HintMessage(p,HINTMSG_TOFIELD)
			local tc=g:Select(p,1,1,nil):GetFirst()
			Duel.ActivateDirectly(tc,p)
			if tc:IsCode(table.unpack(labels)) then
				aux.ApplyEffectImmediatelyAfterResolution(s.damop,c,e,tc:GetControler(),eg,ep,ev,re,r,rp)
			end
			break
		end
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp,_e,chain_end)
	Duel.Damage(tp,3000,REASON_EFFECT)
end
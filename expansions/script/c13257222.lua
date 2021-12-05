--宇宙军阀首领 邪神红水晶
local m=13257222
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(function(e,c) return c~=e:GetHandler() end)
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--double tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(cm.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(cm.bgmop)
	c:RegisterEffect(e12)
end
function cm.condition(e,c)
	return c:IsRace(RACE_MACHINE)
end
function cm.filter(c)
	return c:IsSetCard(0x353) and c:IsSummonable(true,nil,1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		if s1 then
			Duel.Summon(tp,tc,true,nil,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,5))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(TAMA_COSMIC_BATTLESHIP_CODE_ADD_CORE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1,true)
			--[[
			local label=tc:GetFlagEffectLabel(13257200)
			tc:ResetFlagEffect(13257200)
			tc:RegisterFlagEffect(13257200,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,label+2,aux.Stringid(m,5))
			tc:RegisterFlagEffect(13257200,0,0,0,label)
			]]
			local e1=Effect.CreateEffect(e:GetHandler())
			local e2=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_LEAVE_FIELD_P)
			e1:SetLabelObject(e2)
			e1:SetOperation(cm.checkop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1)

			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetOperation(cm.spop)
			e2:SetLabelObject(e:GetHandler())
			tc:RegisterEffect(e2)
		end
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:GetLabelObject():SetLabel(1)
	else e:GetLabelObject():SetLabel(0) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=0 then return end
	local tc=e:GetLabelObject()
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(11,0,aux.Stringid(m,4))
		e:Reset()
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(m,6))
end

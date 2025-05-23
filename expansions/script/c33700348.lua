--虚拟YouTuber 辉夜月
local m=33700348
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsAttackAbove,2100),2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	local function pfilter(c)
		return not c:IsPosition(POS_FACEUP_ATTACK) and c:IsLocation(LOCATION_MZONE)
	end
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if chk==0 then return #g>0 end
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local ct=Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		local c=e:GetHandler()
		if #g>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetValue(ct*200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end)
	c:RegisterEffect(e1)
end

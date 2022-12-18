--契龙圣约 辉耀之审判
local m=33201271
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201250") end,function() require("script/c33201250") end)
function cm.initial_effect(c)
	VHisc_Dragonk.eqa(c)
	--Def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	VHisc_Dragonk.eqgef(c,e2)
end
cm.VHisc_DragonRelics=true

function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()>0 and re:GetActivateLocation()==LOCATION_MZONE and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local rc=re:GetHandler()
		if tc.VHisc_DragonRelics or tc.VHisc_DragonCovenant and rc:IsLocation(LOCATION_MZONE) and rc:GetAttack()>0 then
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetValue(0)
			rc:RegisterEffect(e3)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e5:SetRange(LOCATION_MZONE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e5:SetValue(1)
			rc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e6:SetValue(cm.fuslimit)
			rc:RegisterEffect(e6)
			local e7=e5:Clone()
			e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			rc:RegisterEffect(e7)
			local e8=e5:Clone()
			e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			rc:RegisterEffect(e8)
			rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		end
		Duel.ShuffleHand(tp)
	end
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
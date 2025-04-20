--朱斯贝克·反抗黎骑·疾风
local m=40010637
local cm=_G["c"..m]
cm.named_with_Rebellionform=1
cm.named_with_Youthberk=1
function cm.initial_effect(c)
	aux.AddCodeList(c,40010501)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	--e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.mttg)
	e1:SetOperation(cm.mtop)
	c:RegisterEffect(e1) 
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.damcon)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfliter,1,nil,rp) then
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cfliter(c)
	return c:IsCode(40010501) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40010501)
end
function cm.mtfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,e:GetHandler()) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,e:GetHandler(),e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
		if (Duel.GetFlagEffect(tp,m)>1 or c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,40020005))  and e:GetHandler():IsAttackable() then
			if not c:IsAttackable() or not c:IsRelateToEffect(e) then return end 
			value=c:GetAttack()
			ef=c:IsHasEffect(EFFECT_DEFENSE_ATTACK)
			if ef and ef:GetValue()==1 then 
				value=c:GetDefense()
			end
			if Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_AVOID_BATTLE_DAMAGE) then
				value=0
			end
			Duel.Damage(1-tp,value,REASON_BATTLE)
				--Duel.Damage(1-tp,Duel.GetLP(1-tp),REASON_RULE)
			--end
		end
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--朱斯贝克·反抗黎骑·翠岚
local m=40010752
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
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.atkcon)
	e1:SetOperation(cm.atkop)
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
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.damcon)
	--e2:SetTarget(cm.damtg)
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
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) --and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40010501)
end
function cm.tdfilter(c,type)
	return c:IsType(type) and c:IsFaceup()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local gh=Duel.GetDecktopGroup(tp,1)
	local gc=gh:GetFirst()
	local type=bit.band(gc:GetType(),0x7)
	if (Duel.GetFlagEffect(tp,m)>1 or c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,40020005) ) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 and gc:IsAbleToHand() then
		Duel.BreakEffect()
		--Duel.ConfirmDecktop(p,2)
		if Duel.SendtoHand(gc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,gc)
			local gd=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_ONFIELD,nil,type)
			if #gd>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				--Duel.Destroy(gd,REASON_EFFECT)
				Duel.SendtoDeck(gd,nil,2,REASON_EFFECT)
			end
		end
	end
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end



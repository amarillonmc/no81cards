local m=11634044
local cm=_G["c"..m]
cm.name="永火欺诈"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(m)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	if not cm.check then
		cm.check=true
		local e_enum=Effect.CreateEffect(c)
		e_enum:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_enum:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e_enum:SetOperation(cm.enumop)
		e_enum:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
		Duel.RegisterEffect(e_enum,0)
		local e_handcheck=Effect.CreateEffect(c)
		e_handcheck:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_handcheck:SetCode(EVENT_ADJUST)
		e_handcheck:SetOperation(cm.handcheckop)
		Duel.RegisterEffect(e_handcheck,0)
		local e_movecheck=Effect.CreateEffect(c)
		e_movecheck:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e_movecheck:SetCode(EVENT_MOVE)
		e_movecheck:SetOperation(cm.movecheckop)
		Duel.RegisterEffect(e_movecheck,0)
		--cm._ConfirmCards=Duel.ConfirmCards
		--Duel.ConfirmCards=function(p,tg)
		--	cm._ConfirmCards(p,tg)
		--	local g=
		--end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.handsetcon(e)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),m) and e:GetHandler():GetFlagEffect(m)>0
end
function cm.enumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK,LOCATION_HAND+LOCATION_DECK)
	g:ForEach(
		function (c)
			if c:IsType(TYPE_MONSTER) then
				local e=Effect.CreateEffect(c)
				e:SetType(EFFECT_TYPE_SINGLE)
				e:SetCode(EFFECT_MONSTER_SSET)
				e:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				e:SetCondition(cm.handsetcon)
				e:SetLabel(m)
				c:RegisterEffect(e)
				c:RegisterFlagEffect(m,nil,EFFECT_FLAG_SET_AVAILABLE,0)
			end
		end
	)
end
function cm.handcheckop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(0,LOCATION_HAND,LOCATION_HAND)
	g:ForEach(
		function (c)
			if c:IsType(TYPE_MONSTER) then
				local eset={c:IsHasEffect(EFFECT_MONSTER_SSET)}
				local flag=false
				for _,te in ipairs(eset) do
					if not te:GetLabel() or te:GetLabel()~=m then
						flag=true
					end
				end
				if flag then
					c:ResetFlagEffect(m)
				end
			end
		end
	)
end
function cm.movecheckfilter(c)
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEDOWN) and c:GetFlagEffect(m)~=0
end
function cm.winfilter(c)
	local con_grave=c:IsLocation(LOCATION_GRAVE)
	local con_re_ex=(c:IsLocation(LOCATION_REMOVED) or c:IsLocation(LOCATION_EXTRA)) and c:IsFaceup()
	return con_grave or con_re_ex
end
function cm.movecheckop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.movecheckfilter,nil):Filter(cm.winfilter,nil)
	local lose_p0=false
	local lose_p1=false
	g:ForEach(
		function (c)
			if c:GetPreviousControler()==0 then lose_p0=true end
			if c:GetPreviousControler()==1 then lose_p1=true end
		end
	)
	if lose_p0 and not lose_p1 then
		Duel.ConfirmCards(1,g)
		Duel.Win(1,aux.Stringid(m,1))
	elseif not lose_p0 and lose_p1 then
		Duel.ConfirmCards(0,g)
		Duel.Win(0,aux.Stringid(m,1))
	elseif lose_p0 and lose_p1 then
		Duel.ConfirmCards(0,g)
		Duel.Win(PLAYER_NONE,aux.Stringid(m,1))
	end
end
function cm.filter(c)
	return c:IsSetCard(0xb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
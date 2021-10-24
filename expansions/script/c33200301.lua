--Dystopia 审查盘问
function c33200301.initial_effect(c)
	c:SetUniqueOnField(1,1,33200301)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--GetCards
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200301,11))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200301.thtg)
	e2:SetOperation(c33200301.thop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200301,12))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,33200301)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c33200301.discon)
	e3:SetTarget(c33200301.distg)
	e3:SetOperation(c33200301.disop)
	c:RegisterEffect(e3)
end

--e2
function c33200301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c33200301.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	local tg=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		if tg:GetCount()>0 then
			if Duel.SelectOption(1-tp,aux.Stringid(33200301,13),aux.Stringid(33200301,14)) then
				Duel.SendtoHand(tg,tp,REASON_EFFECT)
			else
				Duel.RegisterFlagEffect(1-tp,33200300,nil,0,1)
				local lp1=Duel.GetLP(1-tp)
				Duel.SetLP(1-tp,lp1-500)
				local zz=Duel.GetFlagEffect(1-tp,33200300)
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(33200300,zz))
				Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(33200301,zz))
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end

--e3
function c33200301.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) 
		and Duel.GetFlagEffect(1-tp,33200300)>=4
end
function c33200301.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33200301.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
